import { Dirent } from "node:fs";
import fs from "node:fs/promises";
import Path from "node:path";
import process from "node:process";
import { ParseError, SyntaxError } from "./lib/errors";
import Logger from "./lib/logger";
import { isDirectory, isFile } from "./lib/utils";

const parseArgs = (args: string[]) => {
  const parsedArgs: Record<string, string> = {};
  for (const arg of args) {
    if (arg.startsWith("--")) {
      const [key, value] = arg.slice(2).split("=");
      parsedArgs[key] = value || "";
    } else if (arg.startsWith("-")) {
      const key = arg.slice(1);
      parsedArgs[key] = "";
    }
  }
  return parsedArgs;
};

const platforms = ["pc", "nb"] as const;
type Platform = (typeof platforms)[number];

const SEARCH_DIR = "../";

const ignoredFolders = ["_generator", "node_modules", ".git"];

//Variables available in the templates if statements
let contextVariables: Record<string, string> = {};

const evaluateCondition = (condition: string): boolean => {
  return Boolean(
    new Function(...Object.keys(contextVariables), `return ${condition}`)(
      ...Object.values(contextVariables),
    ),
  );
};

const parseFile = (content: string) => {
  const lines = content.split("\n");
  const parsed: string[] = [];

  const stack: {
    matched: boolean;
    shouldEvaluate: boolean;
  }[] = [];

  const matches = {
    if: /{{\s*if\s+(.+?)\s*}}/,
    elseIf: /{{\s*else\s+if\s+(.+?)\s*}}/,
    else: /{{\s*else\s*}}/,
    endIf: /{{\s*end\s*}}/,
  };

  let _line = 0;
  for (const raw of lines) {
    ++_line;
    const line = raw.trim();

    if (matches.if.test(line)) {
      const condition = line.match(matches.if)?.[1]?.trim();
      if (!condition) {
        throw new SyntaxError("No condition found for if statement", _line);
      }
      try {
        const result = evaluateCondition(condition);
        stack.push({
          matched: result,
          shouldEvaluate: result,
        });
      } catch (error) {
        if (error instanceof Error) {
          throw new ParseError(error.message, _line);
        }
      }
    } else if (matches.elseIf.test(line)) {
      const top = stack[stack.length - 1];
      if (!top) {
        throw new SyntaxError("No previous if statement found", _line);
      }
      if (top.matched) {
        top.shouldEvaluate = false;
        continue;
      }

      const condition = line.match(matches.elseIf)?.[1]?.trim();
      if (!condition) {
        throw new SyntaxError(
          "No condition found for else if statement",
          _line,
        );
      }
      try {
        const result = evaluateCondition(condition);
        top.matched = result;
        top.shouldEvaluate = result;
      } catch (error) {
        if (error instanceof Error) {
          throw new ParseError(error.message, _line);
        }
      }
    } else if (matches.else.test(line)) {
      const top = stack[stack.length - 1];
      if (!top) {
        throw new SyntaxError("No previous if statement found", _line);
      }
      top.shouldEvaluate = !top.matched;
      top.matched = true;
    } else if (matches.endIf.test(line)) {
      if (stack.length === 0) {
        throw new SyntaxError("No previous if statement found", _line);
      }
      stack.pop();
    } else {
      if (stack.every((s) => s.shouldEvaluate)) {
        parsed.push(raw); // since we want to keep the original line
      }
    }
  }
  if (stack.length > 0) {
    throw new SyntaxError("Unclosed if statement", _line);
  }
  return parsed.join("\n");
};

const handleFile = async (file: Dirent<string>) => {
  if (file.isDirectory()) {
    //also create the directory on the destination
    if (!(await isDirectory(Path.join("../", file.parentPath, file.name)))) {
      await fs.mkdir(Path.join("../", file.parentPath, file.name), {
        recursive: true,
      });
    }
    return await walkFiles(Path.join(file.parentPath, file.name));
  }

  if (file.isSymbolicLink()) {
    if (file.name == "rules.conf") {
      //copy symbolic link as is
      const filePath = Path.join(file.parentPath, file.name);
      const destinationPath = Path.join(
        "../" /* For the destionation folder */,
        file.parentPath,
        file.name,
      );

      const symlinkTarget = await fs.readlink(filePath);
      //ignore error if symlink already exists
      await fs.symlink(symlinkTarget, destinationPath).catch(() => {});
    }
    //skip symbolic links
    return;
  }

  const filePath = Path.join(file.parentPath, file.name);
  const destinationPath = Path.join(
    "../" /* For the destionation folder */,
    file.parentPath,
    file.name,
  );

  try {
    const content = await fs.readFile(filePath, "utf-8");
    const originalStats = await fs.stat(filePath);

    const newContent = parseFile(content);
    await fs.writeFile(destinationPath, newContent, {
      mode: originalStats.mode,
    });
  } catch (error) {
    if (error instanceof SyntaxError) {
      console.error(
        `Syntax error in file ${filePath} at line ${error.line}: ${error.message}`,
      );
    } else if (error instanceof ParseError) {
      console.error(
        `Parse error in file ${filePath} at line ${error.line}: ${error.message}`,
      );
    } else {
      console.error(`Error reading file ${filePath}:`, error);
    }
  }
};

const walkFiles = async (dir = SEARCH_DIR) => {
  const files = await fs.readdir(dir, { withFileTypes: true });
  await Promise.all(
    files.filter((file) => !ignoredFolders.includes(file.name)).map(handleFile),
  );
};

const main = async () => {
  const l = new Logger("Dotfiles", "magenta");

  const args = parseArgs(process.argv.slice(2));
  let platform: Platform | null = null;
  if ("platform" in args) {
    if (!platforms.includes(args.platform as Platform)) {
      throw new Error(
        `Invalid platform: ${args.platform}. Valid platforms are: ${platforms.join(", ")}`,
      );
    }

    platform = args.platform as Platform;
  }

  if (!(await isFile("platform.txt"))) {
    if (platform) {
      await fs.writeFile("platform.txt", platform);
    } else {
      throw new Error(
        "No platform specified and platform.txt not found. Please specify a platform using --platform=pc or --platform=nb.",
      );
    }
  } else {
    const fileContent = await fs.readFile("platform.txt", "utf-8");
    if (platform) {
      await fs.writeFile("platform.txt", platform);
    } else {
      platform = fileContent.trim() as Platform;
      if (!platforms.includes(platform)) {
        throw new Error(
          `Invalid platform in platform.txt: ${platform}. Valid platforms are: ${platforms.join(", ")}`,
        );
      }
    }
  }

  contextVariables.platform = platform;

  l.start("Generating dotfiles for platform: " + platform);
  await walkFiles();
  l.stop("Dotfiles generated successfully");
};

main().catch((err) => {
  console.error("An error occurred:", err);
  process.exit(1);
});
