 [Reflection.Assembly]::LoadFile( `
  'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\System.Web.dll')`
  | out-null  
  $headers = $null
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
#$headers.Add('Authorization',('Basic {0}' -f "WRtaW46Wm5yb3A1NDc2Nzc="))
$headers.Add('Accept','application/json')
$headers.Add('Content-Type','application/json')

$headers.Add("Authorization", "Basic " + 
        [System.Convert]::ToBase64String(
            [System.Text.Encoding]::ASCII.GetBytes("$("admin"):eb4fa00a67267495c9d747d6c7524b88")))

$Body = @{
            "parameter" = @(
                            @{
                                name = "Filename"
                                value = "MyFirstFile"
                            },
                            @{
                                name = "Message"
                                value = "what is it"
                            }
                            )
            } | ConvertTo-Json


write-host "body message: $Body"

$uri = "http://localhost:8080/job/Create%20Text%20File/build?token=testToken"
$uri2 = "http://localhost:8080/api/json?pretty=true"

$url = "$($uri)/crumbIssuer/api/xml"
[xml]$crumbs = Invoke-WebRequest $url -Method GET -Headers $headers

$headers.Add($crumbs.defaultCrumbIssuer.crumbRequestField, $crumbs.defaultCrumbIssuer.crumb)
    $headers.Add("Accept", "application/xml")

$RestSplat = @{
    Headers = $headers
    Method = 'POST'
    uri = $uri2
    Body = @{ json = $Body }
}

Invoke-WebRequest @RestSplat -Verbose


#---------------
#Crumbs:
[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

$Bytes = [System.Text.Encoding]::UTF8.GetBytes($Auth)
$Base64bytes = [System.Convert]::ToBase64String($Bytes)
$Base64bytes = "WRtaW46Wm5yb3A1NDc2Nzc="
$Headers = @{ "Authorization" = "Basic $Base64bytes"}




$CrumbIssuer = "$url/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,`":`",//crumb)"
$Crumb = Invoke-WebRequest -uri $CrumbIssuer -Headers $Header


$Regex = '^Jenkins-Crumb:([A-Z0-9]*)'
$Matches = @([regex]::matches($crumb, $regex, 'IgnoreCase'))
$RegCrumb = $Matches.Groups[1].Value
$Headers.Add("Jenkins-Crumb", "$RegCrumb")

