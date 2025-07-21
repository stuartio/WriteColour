function Write-ColourfulOutput {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]
        $InputObject
    )

    Process {
        $ColouredString = Convert-ColouredString $InputObject
        Write-Output $ColouredString
    }
}