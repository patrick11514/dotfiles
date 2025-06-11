import fs from "node:fs/promises";

export const isDirectory = async (path: string) => {
  try {
    const stats = await fs.stat(path);
    return stats.isDirectory();
  } catch {
    return false;
  }
};

export const isFile = async (path: string) => {
  try {
    const stats = await fs.stat(path);
    return stats.isFile();
  } catch {
    return false;
  }
};
