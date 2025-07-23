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