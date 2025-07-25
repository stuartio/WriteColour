<#
.SYNOPSIS
Write-Output using colour-formatted string
.DESCRIPTION
Wrapper on top of Write-Output which supports custom colour-formatted strings (seee https://github.com/stuartio/writecolour).
.PARAMETER InputObject
Colour-formatted string to print
.EXAMPLE
Write-ColourOutput "Hello, my name is |red|Inigo Montoya|!|"
#>
function Write-ColourOutput {
    [Alias('Write-ColorOutput')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]
        $InputObject
    )

    Process {
        $ColouredString = Convert-ColourString $InputObject
        Write-Output $ColouredString
    }
}