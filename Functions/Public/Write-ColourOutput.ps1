function Write-ColourOutput {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]
        $InputObject
    )

    Process {
        $ColouredString = Convert-ColourfulString $InputObject
        Write-Output $ColouredString
    }
}