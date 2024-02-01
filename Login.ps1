#Login infomation  
$Body = @{
    email = 'tnhalk@maytinhdian.com'
    password     = Read-Host -Promt 'Nhap password'
}

# Send a POST request for authentication.
$Params = @{
    Uri     = "http://192.168.1.55:8000/api/login"
    Method  = "POST"  
    Body    = $body
    Headers = @{
        "Accept" = 'application/json'
    }


}
$json = Invoke-RestMethod @Params

foreach ($object in $json.PSObject.Properties) {
    Write-Host "Object name: $($object.Name)"
    $objectproperties = Get-Member -InputObject $object.Value -MemberType NoteProperty
    foreach($property in $objectproperties) {
        if($property.Name -eq 'token'){
            Write-Host "Property value: $($object.Value.($property.Name))"
        }
   
    }
}
