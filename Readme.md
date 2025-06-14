# Typing.lua

This program is based on a program I wrote in C called TypeBelow, except now in Lua (and with one less feature!).  It reads lines from a specified text file and shows them one by one in the terminal.  You follow along by typing each line and pressing Enter before continuing.  This program is very bare-bones because I don't personally need anything more complicated.  If you want to make modifications to it and republish, have at it.

## Features
- Shows one line at a time from the input file, piped-in text, or from the clipboard.

## Anti-Features
- Does not halt your progress if you type something wrong.
- Does not track your typing speed or mistakes.
- Does not store any data (no profiles, saves, etc).

## Usage
```bash
typing.lua filename.txt  # to type from the contents of a file
typing.lua -             # to type from piped-in text
typing.lua               # to type from clipboard contents
```