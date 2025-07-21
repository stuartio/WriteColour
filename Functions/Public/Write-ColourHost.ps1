function Write-ColourHost {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]
        $InputObject
    )

    Process {
        $ColourfulInput = Convert-ColourfulString $InputObject
        Write-Host -Object $ColourfulInput
    }
}