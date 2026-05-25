# json-parser

A simple CLI tool written in Dart that reads a JSON file and pretty-prints it to the terminal with syntax highlighting.

## Features

- Colorized output: keys in blue, strings in green, numbers in yellow, booleans/null in magenta
- Handles nested objects and arrays with proper indentation
- Clear error messages for missing or invalid files

## Requirements

- Dart SDK `^3.12.0`

## Usage

```bash
dart run bin/json_parser.dart --file <path-to-file.json>
# or short form
dart run bin/json_parser.dart -f <path-to-file.json>
```

Example with the included test file:

```bash
dart run bin/json_parser.dart -f assets/test.json
```

Or via `make`:

```bash
make dev
```

## Project structure

```
bin/
  json_parser.dart       # entry point
lib/
  config/                # CLI flag parsing
  core/json/             # JSON reading, formatting, color theme
  core/render/           # rendering helpers
  exceptions/            # custom exceptions
  utils/                 # shared utilities
  logger.dart            # colored logger
assets/
  test.json              # sample JSON file
```
