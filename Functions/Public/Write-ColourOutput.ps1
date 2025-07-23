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