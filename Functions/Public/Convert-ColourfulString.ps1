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
        # Parse Input and extract colours
        $ColourPattern = '\|(#?[a-z0-9,]+)( [bfiuBrhs]+)?\|'
        $ParsedInput = $InputObject
        # Replace closing tag with reset
        $ParsedInput = $ParsedInput.Replace('|!|', $Reset)
    
        $ColourMatches = $ParsedInput | Select-String -Pattern $ColourPattern -AllMatches
    
        if ($ColourMatches) {
            Write-Debug "Convert-ColouredString: Found $($ColourMatches.Matches.count) matches"
            $ColourMatches.Matches | ForEach-Object {
                $Value = $_.Value
                $Colour = $_.Groups[1].Value
                if ($_.Groups[2]) {
                    $Flags = $_.Groups[2].Value.Trim()
                }
    
                # Colour is RGB
                if ($Colour -Match '[0-9]{1,3},[0-9]{1,3},[0-9]{1,3}') {
                    Write-Debug "Convert-ColouredString: $Colour is RGB"
                    $RGB = $Colour.split(',')
                    $R = $RGB[0]
                    $G = $RGB[1]
                    $B = $RGB[2]
                }
    
                # Colour is Hex
                elseif ($Colour -match '#?[a-fA-F0-9]{6}') {
                    Write-Debug "Convert-ColouredString: $Colour is hex"
                    if ($Colour.StartsWith('#')) {
                        $Colour = $Colour.Substring(1)
                    }
                    $RHex = $Colour.Substring(0, 2)
                    $GHex = $Colour.Substring(2, 2)
                    $BHex = $Colour.Substring(4, 2)
    
                    $R = [int] "0x$RHex"
                    $G = [int] "0x$GHex"
                    $B = [int] "0x$BHex"
                }
    
                # Check colours list
                else {
                    if ($null -ne $Colours.$Colour) {
                        Write-Debug "Convert-ColouredString: $Colour is in datastore"
                        $R = $Colours.$Colour.red
                        $G = $Colours.$Colour.green
                        $B = $Colours.$Colour.blue
                    }
                    else {
                        Write-Warning "Convert-ColouredString: Could not parse colour $Colour"
                    }
                }
    
                $FormattedValue = "$e[38;2;$R;$G;$B"
    
                # Add flags, if any
                if ($Flags) {
                    Write-Debug "Convert-ColouredString: Flags = $Flags"
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
            Write-Warning "Convert-ColouredString: Found no colour matches"
            return $InputObject
        }
    }
}