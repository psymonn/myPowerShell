#https://www.powershellgallery.com/packages/Jenkins/1.0.0.140/Content/Jenkins.psm1

# Create Header
             $AuthInfo = "[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f 'admin', 'pass')))"

            $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            #$headers.Add('Authorization',('Basic {0}' -f $AuthInfo))
            $headers.Add('Accept','application/json')
            $headers.Add('Content-Type','application/json')

                        
           # $Body = @{$number = '31'} | ConvertTo-Json
            

             $RestSplat = @{
                    Headers = $headers
                    Method = "post"
                    Uri = "http://localhost:8080/job/Test1/api/json?pretty=true"
                    #Body = $Body
                }



                Invoke-WebRequest @RestSplat -ErrorAction Stop
