function Get-RGB {
    Param(
        [Parameter(Mandatory)]
        [string]
        $Colour
    )

    Write-Debug "Get-RGB: Parsing colour entry '$Colour'"

    $RGBMatch = '[0-9]{1,3},[0-9]{1,3},[0-9]{1,3}'
    $HexMatch = '#?[a-fA-F0-9]{6}'

    if ($Colour -Match $RGBMatch) {
        Write-Debug "Get-RGB: Colour '$Colour' is RGB"
        $RGB = $Colour.split(',')
        $Local:R = $RGB[0]
        $Local:G = $RGB[1]
        $Local:B = $RGB[2]
    }

    # Colour Colour is Hex
    elseif ($Colour -match $HexMatch) {
        Write-Debug "Get-RGB: Colour '$Colour' is hex"
        if ($Colour.StartsWith('#')) {
            $Colour = $Colour.Substring(1)
        }
        $RHex = $Colour.Substring(0, 2)
        $GHex = $Colour.Substring(2, 2)
        $BHex = $Colour.Substring(4, 2)

        $Local:R = [int] "0x$RHex"
        $Local:G = [int] "0x$GHex"
        $Local:B = [int] "0x$BHex"
    }

    # Colour - Check colours list
    else {
        if ($null -ne $Colours.$Colour) {
            Write-Debug "Get-RGB: Colour '$Colour' is in datastore"
            $Local:R = $Colours.$Colour.red
            $Local:G = $Colours.$Colour.green
            $Local:B = $Colours.$Colour.blue
        }
    }

    if ($null -ne $Local:R -and $null -ne $Local:G -and $null -ne $Local:B) {
        return [PSCustomObject] @{
            red   = $Local:R
            green = $Local:G
            blue  = $Local:B
        }
    }
    else {
        Write-Debug "Get-RGB: Could not determine colour from '$Colour'"
        return $null
    }
}