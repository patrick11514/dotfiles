import { program } from 'commander';
import { exec } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

program
    .option('--genArray <int>', 'Generate array from 1 to <int> number')
    .option('--toggle-calendar', 'Toggle calendar on bar')
    .option('--toggle-song', 'Toggle song on bar')
    .option('--artwork', 'Get artwork')
    .option('--follow', 'Follow artwork');

program.parse();

const eww = '/usr/bin/eww';

type Args = Partial<{
    genArray: string;
    toggleCalendar: boolean;
    toggleSong: boolean;
    artwork: boolean;
    follow: boolean;
}>;

const options = program.opts<Args>();

const getCacheDir = () => {
    const home = process.env.HOME;

    if (!home) {
        throw Error('Unknown home directory');
    }

    return path.join(home, '.cache');
};

const cmd = async (command: string) => {
    return new Promise<string>((resolve, reject) =>
        exec(command, (err, stdout) => {
            if (!err) {
                resolve(stdout);
                return;
            }

            reject(err);
        })
    );
};

const toggle = async (lockFileName: string, openCommand: string, closeCommand: string) => {
    const lockFile = path.join(getCacheDir(), lockFileName);

    try {
        if (fs.existsSync(lockFile)) {
            fs.rmSync(lockFile);
            await cmd(closeCommand);
            return true;
        } else {
            fs.writeFileSync(lockFile, '');
            await cmd(openCommand);
            return true;
        }
    } catch (_) {
        console.error(_);
        return false;
    }
};

const getPathToImage = async (url: string) => {
    const request = await fetch(url);
    if (!request.ok) {
        return null;
    }
    const data = await request.arrayBuffer();
    const path = '/tmp/.eww.image';
    fs.writeFileSync(path, Buffer.from(data));
    return path;
};

const getPath = async (imageOrUrl: string) => {
    try {
        new URL(imageOrUrl);

        const result = await getPathToImage(imageOrUrl);
        if (!result) {
            return '';
        }

        return result;
    } catch (_) {
        return imageOrUrl;
    }
};

const main = async (args: Args): Promise<string | void> => {
    if (args.genArray) {
        let arrayMax: number;
        try {
            arrayMax = parseInt(args.genArray);
        } catch (_) {
            throw Error('Please enter number as argument');
        }

        return JSON.stringify(Array.from({ length: arrayMax }).map((_, i) => i + 1));
    } else if (args.toggleCalendar) {
        const res = await toggle('eww-calendar.lock', `${eww} open calendar`, `${eww} close calendar`);
        if (res) {
            return 'ok';
        }
        return 'not-ok';
    } else if (args.toggleSong) {
        const res = await toggle('eww-song.lock', `${eww} open player`, `${eww} close player`);
        if (res) {
            return 'ok';
        }
        return 'not-ok';
    } else if (args.artwork) {
        if (!args.follow) {
            const urlOrPath = await cmd("playerctl metadata --format '{{ mpris:artUrl }}'");
            return await getPath(urlOrPath);
        }

        await new Promise((resolve, reject) => {
            const cmd = exec("playerctl --follow metadata --format '{{ mpris:artUrl }}'", (err) => {
                reject(err?.message);
            });

            cmd.stdout?.on('close', () => {
                resolve('');
            });

            cmd.stdout?.on('data', async (data: string) => {
                console.log(data);

                if (data.trim() == "") return "~/.config/eww/music.png"
                console.log(await getPath(data.trim()));
            });
        });
    }
};

main(options).then(console.log);
