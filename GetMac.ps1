#Hàm đặt tên computer và user 
function Set-ComputerName {
    param (
        [String]$pcName,
        [String]$userName
    )
    if ($env:COMPUTERNAME -ne $pcName) {
        #Rename-Computer -NewName $pcName
    }
    else {
        Write-Host "Current computer name is: $pcName"
    }
    if ($env:USERNAME -ne $userName) {
        #Write-Host $env:USERNAME
        #Rename-LocalUser -Name $Env:UserName -NewName $userName
    }
    else {
        Write-Host "Current user name is: $userName"
    }
}


#Lấy MACADRESS của máy hiện tại
$LocalMacAddress = (Get-NetAdapter -Name "Ether*" | Select-Object MacAddress).MacAddress.ToString();
Write-Host 'Local mac address: ' $LocalMacAddress

#So sanh vs CSDL 
$computer = Invoke-RestMethod -Uri "http://192.168.1.7:8000/api/computer/search" -Method Post -Headers @{
    Accept = "application/json"
} -Body @{
    mac_address = "$LocalMacAddress";

}
#Set tên máy tính và user 
if (!$computer.mac_address) {

    #Prepare data save to database
    Write-Output "Local mac address: $LocalMacAddress not found - Begining save to database"

    $schoolName = Read-Host "Nhap ten truong "
    if ($schoolName.Length -eq 0) {
        # Set default value 
        $schoolName = 'THPT Di An'
    }

    $pcName = Read-Host "Nhap ten may tinh "
    if ($pcName.Length -eq 0) {
        # Set Computer Name  default value 
        # Nếu không có trong CSDL thì dùng 4 số cuối của MAC hiện tại đặt tên cho PC
        $pcName = "PC-" + $LocalMacAddress.Substring(0, 5).replace("-", "") 
    }

    $userName = Read-Host "Nhap ten user "
    if ($userName.Length -eq 0) {
        # Set User Name default value 
        # Nếu không có trong CSDL thì dùng 4 số cuối của MAC hiện tại đặt tên cho User  
        $userName = "User_" + $LocalMacAddress.Substring(0, 5).replace("-", "")
    }
    #Rename computer name and user name 
    Set-ComputerName -pcName $pcName -userName $userName

    #Save to database 
    $Body = @{
        school_name = $schoolName
        pc_name     = $pcName
        user_name   = $userName
        mac_address = $LocalMacAddress
    }

    # Send a POST request including bearer authentication.
    $Params = @{
        Uri     = "http://192.168.1.7:8000/api/computer/create"
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
    Write-Host 'Mac address ' $LocalMacAddress 'exits in database'
    #  Write-Host 'Begining set pc name and user name with data get from database'
    
    Set-ComputerName -pcName $computer.pc_name -userName $computer.user_name
    
    
}

Write-Host 'Finish !!!....'
