
$Body = @{
    school_name = "THPT Di An"
    pc_name = "TestPS"
    user_name = "User123"
    mac_address= "00-11-de-bc-11-44"
}

# Send a POST request including bearer authentication.
$Params = @{
    Uri = "http://127.0.0.1:8000/api/computer/create"
    Method ="POST"  
    Body = $body
   #Form = $Body
    Headers = @{
       "Accept"='application/json'
    }
    

}
Invoke-RestMethod @Params