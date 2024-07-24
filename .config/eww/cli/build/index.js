"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const commander_1 = require("commander");
commander_1.program.option("--genArray <int>", "Generate array from 1 to <int> number");
commander_1.program.parse();
const options = commander_1.program.opts();
const main = async (args) => {
    if (args.genArray) {
        let arrayMax;
        try {
            arrayMax = parseInt(args.genArray);
        }
        catch (_) {
            throw Error("Please enter number as argument");
        }
        return JSON.stringify(Array.from({ length: arrayMax }).map((_, i) => i + 1));
    }
};
main(options).then(console.log);
