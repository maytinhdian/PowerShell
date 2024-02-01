#Create function set username pcname with parameter

function Set-ComputerName {
    param (
        [String]$pcName,
        [String]$userName
    )
    Write-Host "Set $pcName $userName finish "
}