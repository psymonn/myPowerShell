function Invoke-Jenkins {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$action = "start",
        [Parameter(Mandatory = $true)]$job = "test.pipeline",
        [Parameter(Mandatory = $false)]
        $server = $null,
        $UserName = $null,
        $apikey = $null,
        $jobparams = $null,
        [switch][boolean]$usepipelines = $true
    )

    #ipmo require
    #req newtonsoft.json

    if ($action -eq "attach" -and $attach -eq $null) { $attach = "latest" }

    if ($server -eq $null) {
        $server = $env:JENKINS_URL
        if ($server -eq $null) {
            $msg = "please provide server url either by passing -server or setting evironment variable 'JENKINS_URL', i.e.: `$env:JENKINS_URL='http://myjenkins:8080'"
            write-warning $msg
            return
        }
    }

    if ($UserName -eq $null) {
        #req cache
        $cred = Get-CredentialsCached -container "jenkins" -message "jenkins username and api token for $server"
        $username = $cred.username
        $apikey = $cred.getnetworkcredential().password
    }


    $JenkinsAPIToken = $apikey
    $JENKINS_URL = $server




    # Global Details
    $JOB_URL = "$jenkins_url/job/$job"

    # Workflow Parameters
    #$jobparams.Add("MachineIP", "SomeString1")
    #$jobparams.Add("RequestID", $RequestId)

    # Load Assemblies
    [Reflection.Assembly]::LoadFile( `
  'C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\System.Web.dll')`
  | out-null


    <#
  Retrieve Crumbs (needed for POST Requets)
#>


    write-verbose "obtaining crumbs for user '$UserName'"
    $headers = $null
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Authorization", "Basic " +
        [System.Convert]::ToBase64String(
            [System.Text.Encoding]::ASCII.GetBytes("$($UserName):$JenkinsAPIToken")))

    $url = "$($JENKINS_URL)/crumbIssuer/api/xml"
    [xml]$crumbs = Invoke-WebRequest $url -Method GET  -Headers $headers

    # set the CSRF token in the headers
    #$webclient.Headers.Add($crumbs.defaultCrumbIssuer.crumbRequestField, $crumbs.defaultCrumbIssuer.crumb)

    $reqparm = new-object System.Collections.Specialized.NameValueCollection

    #$crumbs | out-string | write-verbose
    # set the CSRF token in the headers
    $headers.Add($crumbs.defaultCrumbIssuer.crumbRequestField, $crumbs.defaultCrumbIssuer.crumb)
    $headers.Add("Accept", "application/xml")



    <#
  Construct URL for Build Request
#>
    $jobnumber = $null
    $requestId = $null


    if ($action -eq "start") {
        $tries = 2
        for($t = $tries; $t -gt 0; $t--) {
            if ($jobparams -ne $null) {
                $url = "$($JOB_URL)/buildWithParameters?"

                $count = 0
                foreach ($h in $jobparams.GetEnumerator()) {
                    $h
                    $count = $count + 1
                    $url = $url + "$($h.Name)=$([System.Web.HttpUtility]::UrlEncode($h.Value))"
                    if( $h.name -eq 'requestID' ) {
                        $requestId = $h.Value
                    }
                    if (!($count -eq $jobparams.Count)) {
                        $url = $url + "&"
                    }
                }
            }
            else {
                $url = "$($JOB_URL)/build"
            }

            $result = $null

            try {
                $jobsubmit = Invoke-WebRequest $url -Method POST -Headers $headers -ContentType "application/json" -Body "" -ErrorAction stop
                break
            } catch {
                if ($t -le 1) { throw }
                if ($_.Exception.Message.Contains("Nothing is submitted") -or $_.Exception.Message.Contains("400")) {
                    write-warning "does this job have parameters? trying with -jobparams @{}"
                    $jobparams = @{}
                }
                else {
                    throw
                }
            }
        }
        #hack to get output
        $linearray = $null
        $linearray = ($jobsubmit.RawContent).Split()

        foreach ($line in $linearray) {
            if ($line -match "http://") {
                write-verbose "queue address = $($line)"
                $queueaddress = "$($line)api/xml"
            }
        }

        if ($queueaddress -match "item/([0-9]+)/") {
            $queueId = $Matches[1]
        }


        $output = $null
        $url = "$($JOB_URL)/api/xml?tree=url,inQueue,queueItem[*]&xpath=//*&wrapper=jobs"

        # wait until queue job is free before continue
        do {
            $output = Invoke-WebRequest $url -Method GET  -Headers $headers
            [xml]$jobdetails = $output.Content
            if ($jobdetails.jobs.queueItem -eq $null) { break }
            if ($jobdetails.jobs.queueItem.id -ne $queueId) { break }
            write-host "[$(get-date -format 'HH:mm:ss')] still waiting in the queue: $($jobdetails.jobs.queueItem.why)"
            Start-Sleep -Seconds 1
        }
        while ($true)


        write-host "job '$job' started!"
        #wait until job is in the queue

        #Search for the job with unique ID
        #$url  = "$($JOB_URL)/api/xml?tree=builds[actions[parameters[name,value]],number]&xpath=//build[action[parameter[name=`"RequestID`"][value=`"$($RequestId)`"]]]/number&wrapper=job_names"
        $url = "$($JOB_URL)/api/xml?xpath=//build[queueId=$queueId]&wrapper=builds&tree=builds[actions,number,queueId]"
        #$url  = "$($JOB_URL)/api/json"

        $tries = 20

        do {
            $output = Invoke-WebRequest $url -Method GET  -Headers $headers
            if (($output.Content -match "<builds>")) {
                [xml]$jobdetails = $output.Content
                $jobnumber = $jobdetails.builds.build.number
                write-verbose "job number is: $jobnumber"
            }
            else {
                write-host "[$(get-date -format 'HH:mm:ss')] still waiting for build to appear in API"
                $tries--
                if ($tries -le 0) {
                    throw "build with queueId $queueId not found: $url"
                }
                start-sleep 1
            }
        }
        while ($jobnumber -eq $null -and $tries -gt 0)

        if ($jobnumber -eq $null) {
            throw "Build with queue id $queueId not found in API!"
        }
    }

    if ($action -eq "attach") {
        if ($action -eq "attach" -and ($attach -eq "latest")) {
            $url = "$($JOB_URL)/api/xml?xpath=//build[building='true'][1]&wrapper=builds&tree=builds[actions,number,queueId,building]"
            $output = Invoke-WebRequest $url -Method GET  -Headers $headers
            [xml]$jobdetails = $output.Content
            if ($jobdetails.builds.build) {
                $jobnumber = $jobdetails.builds.build.number
            }
            else {
                $url = "$($JOB_URL)/api/xml?xpath=//build[1]&wrapper=builds&tree=builds[actions,number,queueId,building]"
                $output = Invoke-WebRequest $url -Method GET  -Headers $headers
                [xml]$jobdetails = $output.Content
                $jobnumber = $jobdetails.builds.build.number
            }
        }
        elseif ($attach -ne $true) {
            $jobnumber = $attach
        }
        write-host  "attaching to job $($attach): $jobnumber"
    }

    write-host "=========== Console output ============="

    $logpos = 0
    $dotwritten = $false
    $logformat = "Html" #or Text, case sensitive

    if ($logformat -eq "html") {
        $null = [System.Reflection.Assembly]::LoadWithPartialName("System.web")
    }

    while ($true) {
        $status = ""
        $url = "$($JOB_URL)/$($jobnumber)/api/xml?xpath=//*&wrapper=run"
        $output = Invoke-WebRequest $url -Method GET  -Headers $headers
        [xml]$jobdetails = $output.Content

        if ($usepipelines) {
            $url = "$($JOB_URL)/$jobnumber/wfapi/"
            $output = Invoke-WebRequest $url -Method GET  -Headers $headers
            $wfstatus = ConvertFrom-JsonNewtonsoft $output.content
            $stage = $wfstatus.stages | ? { $_.status -eq "IN_PROGRESS" }
        }




        if ($logpos -eq 0 -and $jobdetails.run.building -eq "false") {
            Write-Verbose "getting log length..."
            $url = "$($JOB_URL)/$($jobnumber)/consoleText"
            $url = "$($JOB_URL)/$($jobnumber)/logText/progressiveText"
            $output = Invoke-WebRequest $url -Method HEAD -Headers $headers

            $loglength = $output.headers.'X-Text-Size'
            $logpos = [Math]::Max(0, $loglength - 1000000)
        }

        $url = "$($JOB_URL)/$($jobnumber)/logText/progressive$($logformat)?start=$logpos"
        $output = Invoke-WebRequest $url -Method GET  -Headers $headers

        if ($output.Content.Length -gt 0) {
            if ($dotwritten) { write-host; $dotwritten = $false }
            if ($logformat -eq "html") {
                $log = $output.content -replace "<.*?>" -split "`r`n"
                $log = $log | ? { ![string]::IsNullOrEmpty($_) } | % {  [system.web.httputility]::htmldecode($_) }
            }
            else {
                $log = $output.content
            }
            if ($stage -ne $null) {
                $log = $log | % { "[$($stage.name)] $_" }
            }
            $log | write-host

        }
        else {
            write-host "." -NoNewline
            $dotwritten = $true
        }
        $logpos = $output.Headers.'X-Text-Size'
        if ($output.Headers.'X-More-Data' -ne "true" -and ($jobdetails.run.building -eq "false" -or !$jobdetails.run.building)) {
            break
        }
        Start-Sleep 1
    }

    write-host ""
    write-host "=========== END Console output ============="
    write-host ""

#    $requestID3 = $h | Where-Object { $_.Key -in ('requestID') }

    write-host " result: build: #$jobnumber Status: $($jobdetails.run.result) duration: $($jobdetails.run.duration) requestId: $requestId job: $job"


    $result = @{results = @{build = $jobnumber; Status = $($jobdetails.run.result); duration = $($jobdetails.run.duration); requestId = $requestId; job = $job }} | ConvertTo-Json
    $json = new-object -TypeName psobject $result
    Write-Output $json
    #Write-Output $json | tee-object  -filepath c:\scripts\pipelineTest3.txt -append

}

#invoke-jenkins -action start -job PSHitchHiker%20Pineline -server "http://localhost:8080" -jobparams @{requestID = 'REQ7691'}
#invoke-jenkins -action attach -job PSHitchHiker%20Pineline -server "http://localhost:8080" -jobparams @{requestID = 'REQ8003'} -UserName admin -apikey eb4fa00a67267495c9d747d6c7524b88
$request = invoke-jenkins -action start -job PSHitchHiker%20Pineline -server "http://localhost:8080" -jobparams @{requestID = 'REQ8007'} -UserName admin -apikey eb4fa00a67267495c9d747d6c7524b88 -Verbose
#invoke-jenkins -action start -job eMailNotifications%20Pipeline -server "http://localhost:8080" -UserName admin -apikey eb4fa00a67267495c9d747d6c7524b88
#invoke-jenkins -action start -job env%20variables -server "http://localhost:8080" -UserName admin -apikey eb4fa00a67267495c9d747d6c7524b88
#invoke-jenkins -action start -job WebSite -server "http://localhost:8080" -UserName admin -apikey eb4fa00a67267495c9d747d6c7524b88
#currently -usepipelines false won't work just remove it
#e.g invoke-jenkins -action start -job env%20variables -server "http://localhost:8080" -usepipelines false -UserName admin -apikey eb4fa00a67267495c9d747d6c7524b88
