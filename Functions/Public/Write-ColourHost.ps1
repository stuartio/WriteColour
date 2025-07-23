<#
.SYNOPSIS
Write-Host using colour-formatted string
.DESCRIPTION
Wrapper on top of Write-Host which supports custom colour-formatted strings (seee https://github.com/stuartio/writecolour).
.PARAMETER InputObject
Colour-formatted string to print
.EXAMPLE
Write-ColourHost "Hello, my name is |red|Inigo Montoya|!|"
#>
function Write-ColourHost {
    [Alias('Write-ColorHost')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]
        $InputObject
    )

    Process {
        $ColourfulInput = Convert-ColourString $InputObject
        Write-Host -Object $ColourfulInput
    }
}