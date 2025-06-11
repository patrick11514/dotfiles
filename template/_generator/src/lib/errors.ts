export class SyntaxError extends Error {
  line: number;
  constructor(message: string, line: number) {
    super(message);
    this.name = "SyntaxError";
    this.line = line;
  }
}

export class ParseError extends Error {
  line: number;
  constructor(message: string, line: number) {
    super(message);
    this.name = "ParseError";
    this.line = line;
  }
}
