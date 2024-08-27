"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const commander_1 = require("commander");
const node_child_process_1 = require("node:child_process");
const node_fs_1 = __importDefault(require("node:fs"));
const node_path_1 = __importDefault(require("node:path"));
const monitor = 0;
commander_1.program
    .option('--genArray <int>', 'Generate array from 1 to <int> number')
    .option('--toggle-calendar', 'Toggle calendar on bar')
    .option('--toggle-song', 'Toggle song on bar')
    .option('--artwork', 'Get artwork')
    .option('--follow', 'Follow artwork');
commander_1.program.parse();
const eww = '/usr/bin/eww';
const options = commander_1.program.opts();
const getCacheDir = () => {
    const home = process.env.HOME;
    if (!home) {
        throw Error('Unknown home directory');
    }
    return node_path_1.default.join(home, '.cache');
};
const cmd = async (command) => {
    return new Promise((resolve, reject) => (0, node_child_process_1.exec)(command, (err, stdout) => {
        if (!err) {
            resolve(stdout);
            return;
        }
        reject(err);
    }));
};
const toggle = async (lockFileName, openCommand, closeCommand, force = false) => {
    const lockFile = node_path_1.default.join(getCacheDir(), lockFileName);
    try {
        if (node_fs_1.default.existsSync(lockFile)) {
            node_fs_1.default.rmSync(lockFile);
            if (!force) {
                await cmd(closeCommand);
            }
            else {
                cmd(closeCommand);
            }
            return true;
        }
        else {
            node_fs_1.default.writeFileSync(lockFile, '');
            if (!force) {
                await cmd(openCommand);
            }
            else {
                cmd(openCommand);
            }
            return true;
        }
    }
    catch (_) {
        console.error(_);
        return false;
    }
};
const getPathToImage = async (url) => {
    const request = await fetch(url);
    if (!request.ok) {
        return null;
    }
    const data = await request.arrayBuffer();
    const path = '/tmp/.eww.image';
    node_fs_1.default.writeFileSync(path, Buffer.from(data));
    return path;
};
const getPath = async (imageOrUrl) => {
    try {
        new URL(imageOrUrl);
        const result = await getPathToImage(imageOrUrl);
        if (!result) {
            return '';
        }
        return result;
    }
    catch (_) {
        return imageOrUrl;
    }
};
const main = async (args) => {
    if (args.genArray) {
        let arrayMax;
        try {
            arrayMax = parseInt(args.genArray);
        }
        catch (_) {
            throw Error('Please enter number as argument');
        }
        return JSON.stringify(Array.from({ length: arrayMax }).map((_, i) => i + 1));
    }
    else if (args.toggleCalendar) {
        const res = await toggle('eww-calendar.lock', `${eww} open calendar --screen ${monitor}`, `${eww} close calendar`);
        if (res) {
            return 'ok';
        }
        return 'not-ok';
    }
    else if (args.toggleSong) {
        const res = await toggle('eww-song.lock', `${eww} open player  --screen ${monitor}`, `${eww} close player`);
        if (res) {
            return 'ok';
        }
        return 'not-ok';
    }
    else if (args.artwork) {
        if (!args.follow) {
            const urlOrPath = await cmd("playerctl metadata --format '{{ mpris:artUrl }}'");
            return await getPath(urlOrPath);
        }
        await new Promise((resolve, reject) => {
            const cmd = (0, node_child_process_1.exec)("playerctl --follow metadata --format '{{ mpris:artUrl }}'", (err) => {
                reject(err?.message);
            });
            cmd.stdout?.on('close', () => {
                resolve('');
            });
            cmd.stdout?.on('data', async (data) => {
                console.log(data);
                if (data.trim() == "")
                    return "~/.config/eww/music.png";
                console.log(await getPath(data.trim()));
            });
        });
    }
};
main(options).then(console.log);
