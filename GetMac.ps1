#Lấy MACADRESS của máy hiện tại
$LocalMacAddress = (Get-NetAdapter -Name "Ether*" | Select-Object MacAddress).MacAddress.ToString();
Write-Host $LocalMacAddress

#So sanh vs CSDL 
$computer = Invoke-RestMethod -Uri "http://127.0.0.1:8000/api/computer/search" -Method Post -Headers @{
    Accept = "application/json"
} -Body @{
    mac_address = "$LocalMacAddress";

}

if (!$computer.mac_address) {
    Write-Output "Local mac address: $LocalMacAddress not found- Begining save to database"
    $schoolName = Read-Host "Nhap ten truong "
    if ($schoolName.Length -eq 0) {
        # Set default value 
        $schoolName = 'THPT Di An'
    }
    $pcName = $env:COMPUTERNAME
    $userName = $env:USERNAME
    

    $Body = @{
        school_name = $schoolName
        pc_name     = $pcName
        user_name   = $userName
        mac_address = $LocalMacAddress
    }

    # Send a POST request including bearer authentication.
    $Params = @{
        Uri     = "http://127.0.0.1:8000/api/computer/create"
        Method  = "POST"  
        Body    = $body
        #Form = $Body
        Headers = @{
            "Accept" = 'application/json'
        }
    

    }
    Invoke-RestMethod @Params
}
else {
    Write-Host 'Exits in database'
    
}
