<#
.SYNOPSIS
Convert string to coloured format
.DESCRIPTION
Takes a string using custom colour blocks (seee https://github.com/stuartio/writecolour) to ANSI escape sequences which can be used with regular printing functions such as Write-Host
.PARAMETER InputObject
Input string to convert
.EXAMPLE
Convert-ColourString "Hello, my name is |red|Inigo Montoya|!|"
#>
function Convert-ColourString {
    [Alias('Convert-ColorString')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]
        $InputObject
    )

    Process {
        $e = [char]0x1b
        $Reset = "$e[0m"
        $Separator = " "
        
        # Begin by removing end values
        $ParsedInput = $InputObject
        $ParsedInput = $ParsedInput.Replace('|!|', $Reset)
        
        # Parse Input and extract colours
        $ColourPattern = '\|([^\|]+)\|'
    
        # Find colour matches
        $ColourMatches = $ParsedInput | Select-String -Pattern $ColourPattern -AllMatches
    
        if ($ColourMatches) {
            Write-Debug "Convert-ColourfulString: Found $($ColourMatches.Matches.count) matches"
            $ColourMatches.Matches | ForEach-Object {
                Write-Debug "Parsing colour match $($_.Value)"
                $Value = $_.Value
                $ColourMatch = $_.Groups[1].Value
                $Foreground = $null
                $Background = $null
                $Flags = $null

                # Split value into components
                $ColourComponents = $ColourMatch.Split($Separator)
                Write-Debug "Found $($ColourComponents.count) components"

                # If single element then check between either foreground colour or flags
                if ($ColourComponents.Count -eq 1) {
                    $Foreground = Get-RGB -Colour $ColourComponents[0]
                    if ($null -eq $Foreground) {
                        Write-Debug "Using single element as flags"
                        $Flags = $ColourComponents[0]
                    }
                }

                # If 2 elements, then assume the first is the foreground, the 2nd can be either background or flags
                elseif ($ColourComponents.Count -eq 2) {
                    $Foreground = Get-RGB -Colour $ColourComponents[0]
                    $Background = Get-RGB -Colour $ColourComponents[1]
                    if ($null -eq $Background) {
                        Write-Debug "Using 2nd element as flags"
                        $Flags = $ColourComponents[1]
                    }
                }

                # If 3 elements, then 1st is foreground, 2nd is background, 3rd is flags
                elseif ($ColourComponents.Count -eq 3) {
                    $Foreground = Get-RGB -Colour $ColourComponents[0]
                    $Background = Get-RGB -Colour $ColourComponents[1]
                    $Flags = $ColourComponents[2]
                }

                # Otherwise panic
                else {
                    Write-Warning "Convert-ColourString: Prefix string is malformed"
                }
    
                # ---- Process foreground
                $FormattedValue = "$e[38;2;$($Foreground.red);$($Foreground.green);$($Foreground.blue)"
    
                # ---- Add background
                if ($Background) {
                    $FormattedValue += ";48;2;$($Background.red);$($Background.green);$($Background.blue)"
                }

                # ---- Add flags, if any
                if ($Flags) {
                    Write-Debug "Convert-ColourfulString: Flags = $Flags"
                    $FlagsArray = $Flags.ToCharArray()
                    foreach ($Flag in $FlagsArray) {
                        switch -CaseSensitive ($Flag) {
                            "b" { $FormattedValue += ";1" } # Bold
                            "f" { $FormattedValue += ";2" } # Dim/Faint
                            "i" { $FormattedValue += ";3" } # Italic
                            "u" { $FormattedValue += ";4" } # Underline
                            "B" { $FormattedValue += ";5" } # Blinking
                            "r" { $FormattedValue += ";7" } # Inverse/Reverse
                            "h" { $FormattedValue += ";8" } # Hidden/Invisible
                            "s" { $FormattedValue += ";9" } # Strikethrough
                        }
                    }
                }
    
                # Add closing char
                $FormattedValue += "m"
    
                # Update input string with formatted value
                $ParsedInput = $ParsedInput.Replace($Value, $FormattedValue)

                # Add trailing reset, just in case
                $ParsedInput += $Reset
            }
    
            return $ParsedInput
        }
        else {
            Write-Warning "Convert-ColourfulString: Found no colour matches"
            return $InputObject
        }
    }
}