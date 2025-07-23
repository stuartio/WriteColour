# Write Colour

This module contains functions to perform Write-Host and Write-Output actions using colours and other rich-text features. Function names use the UK spelling of `colour` by default, but aliases are included for the US-English `color`.

## Installation

The module can be installed from the PowerShell Gallery by running:

```powershell
Install-Module WriteColour
```

## Usage

The functions included use a simple syntax to prefix text blocks with one or more of: foreground colour, background colour, flags (bold, italics etc.). Colour blocks are contained within pipes (|) and the coloured block is then suffixed by a closing block `|!|`.

### Formatting block options

The formatting block can contain the following combinations of options
- foreground colour only
- foreground colour and flags
- foreground colour, background colour and flags

Formatting block options are separated by a space.

For example, if you wanted to write text whose foreground colour is green you would use

```
|green|
```

Or, if you wanted to write green text underlined then you would do

```
|green u|
```

Or, if you wanted green underlined text with a white background you could use

```
|green white u|
```

### Colours

Colours can be specified in one of 3 ways:
- case-insensitive HTML colour names. Currently 140 colours are supported.
- RGB numbers in the format `red,green,blue`
- HTML colours as 6-character hex strings, with or without the # prefix

For example, if you wanted to write text in green, you could use _either one of_:

```
|green|
```

```
|0,128,0|
```

```
|#008000|
```

>Note: Colour formats are interchangeable, so you could use hex for a foreground colour, and a name or rgb numbers for a background colour, or vice-versa

### Flags

The following flags are supported:
- b - Bold
- f - Dim/Faint
- i - Italic
- u - Underline
- B - Blinking
- r - Inverse/Reverse
- h - Hidden/Invisible
- s - Strikethrough

You can also use multiple flags in any order you wish.

## Examples

1. Write your name in red

```powershell
Write-ColourHost "Hello, my name is |red|Inigo Montoya|!|"
```

2. Write your name in red italics

```powershell
Write-ColourHost "Hello, my name is |red i|Inigo Montoya|!|"
```

3. Write your name in red italics, with a yellow background

```powershell
Write-ColourHost "Hello, my name is |red yellow i|Inigo Montoya|!|"
```

4. Write multiple colour entries, mixing formats

```powershell
Write-ColourHost "Hello, my name is |255,0,0 yellow i|Inigo Montoya|!|, you killed my |#00FF7F b|father|!|, prepare to |#93b000 255,255,255|die|!|!"
```