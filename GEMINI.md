# Project: Text Algorithms Study Materials

This project aims to create study materials for the "Text Algorithms" course taught at the Faculty of Mathematics and Physics, Charles University in Prague (MFF CUNI).

## Goal

The primary goal is to produce high-quality lecture notes in English (B2 level) for each topic covered in the course.

## Project Structure

- `main.typ`: The main Typst file that combines all chapters.
- `notes/`: This directory contains the individual chapter files in Typst format.
- `lectures/`: This directory contains the source PDF presentations for each lecture.
- `main.pdf`: The compiled output of the project. This file is not versioned.
- `GEMINI.md`: This file, containing the project's documentation.
- `.gitignore`: Specifies files and directories to be ignored by git.

## Output Format

The final study materials will be written in [Typst](https://typst.app/), a modern typesetting system. Each lecture is converted into a single file, which are then included in the main document.
If you want to use images, just add links to the images, do not try to download them.

## Scope of Work

1.  **Process each presentation:** Go through the PDF presentations in the `lectures/` directory one by one.
2.  **Extract key concepts:** Identify and summarize the core algorithms, data structures, and theoretical concepts from each presentation.
3.  **Translate and simplify:** Rewrite the extracted information in clear and concise B2 level English.
4.  **Structure the content:** Organize the material in a logical way, suitable for study.
5.  **Add examples/explain:** Add an example (inspired by the original presentation) and add key concepts.
6.  **Add tasks:** Add numbered tasks inspired by each lecture topic that could occur in an exam based on presentation and your judgment. After tasks, add solution to the tasks on a new page.
7.  **Format in Typst:** Create a `.typ` file for each topic, formatting the content using Typst's syntax. Always ensure that the syntax is correct, feel free to consult official documentation.
8.  **Git:** Commit and push the changes.

## Text format

1. Extract examples and explanations to a corresponding boxes so they do not disturb the main text information flow.
2. Use bullet-point lists where possible, try to not use long sentences.
3. Exclude all the history related notes.
4. Each chapter should start on a new page.
5. When a greek letter or match symbols should be used, use them as a proper symbols. Use either Typst `#sym.alpha` syntax or math mode `$ alpha $`. Note that Typst syntax is different from LaTeX symbol syntax!
6. Use math mode when needed (denoted by $$).
7. To bold text, use a single start `*bold text*`. To create italics text, use a single underscore `_italic text_`.

## How Typst works

Important: NEVER EVER USE LaTeX expressions prefixed by backslash!!!
In Typst, backslashes are only used for escaping, not for expressions nor symbols!!!

Dollars `$` that do not start the math mode should be prefixed by slash.
Strings in math mode are enclosed in quotes. When quotes are supposed to be used in the math mode,
they need to be enclosed in string and escaped.

## Process

- Always generate a single lecture only (you may use previous lectures as a reference) and include it in the main document.
- After each attempt, compile the project and after that format it using `typstyle -i .`.

## Versioning

After every significant change, a new git commit should be created and pushed. The `lectures/` directory and `*.pdf` files should not be versioned.
