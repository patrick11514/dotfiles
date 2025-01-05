const fs = require("fs");

const FILE = "source.css";

const variables = {
    background: "#1f1816",
    light: "#cdaca3",
    hover: "#724033",
    darker: "#bf6149",
    radius: "10px",
};

console.log("Watching for changes...");

fs.watchFile(FILE, () => {
    const start = Date.now();
    console.log("File changed, updating...");
    let content = fs.readFileSync(FILE, "utf8");

    for (const [key, value] of Object.entries(variables)) {
        content = content.replaceAll(`--${key}`, value);
    }

    fs.writeFileSync("style.css", content);
    console.log(`Done: ${Date.now() - start}ms`);
});
