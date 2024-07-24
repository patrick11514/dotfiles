import { program } from "commander";

program.option("--genArray <int>", "Generate array from 1 to <int> number")

program.parse()

type Args = Partial<{
    genArray: string
}>

const options = program.opts<Args>()

const main = async (args: Args): Promise<string | void> => {
    if (args.genArray) {
        let arrayMax: number
        try {
            arrayMax = parseInt(args.genArray)
        } catch (_) {
            throw Error("Please enter number as argument")
        }
    
        return JSON.stringify(Array.from({length: arrayMax}).map((_, i) => i + 1))
    }
}

main(options).then(console.log)