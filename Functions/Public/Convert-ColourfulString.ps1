function Convert-ColourfulString {
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

                # Identify format of foreground, which is required
                $Foreground = Get-RGB -Colour $ColourComponents[0]

                # Check additional elements to identify background and flags
                if ($ColourComponents.Count -eq 3) {
                    $Background = Get-RGB -Colour $ColourComponents[1]
                    $Flags = $ColourComponents[2]
                }
                else {
                    $Background = Get-RGB -Colour $ColourComponents[1]
                    if ($null -eq $Background) {
                        Write-Debug "Using 2nd element as flags"
                        $Flags = $ColourComponents[1]
                    }
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
            }
    
            return $ParsedInput
        }
        else {
            Write-Warning "Convert-ColourfulString: Found no colour matches"
            return $InputObject
        }
    }
}