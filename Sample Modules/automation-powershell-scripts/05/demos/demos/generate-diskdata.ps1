#this is my script to create some sample disk history data
#for my demonstrations

$CSV = "diskhistory.csv"

1..30 | Foreach-Object {
 
    $sec = Get-Random -Minimum 640 -Maximum 2560
    $date = ((Get-Date).AddDays( - ($_) * 3)).AddSeconds( - $sec)

    $servers = @(
        [pscustomobject]@{
            Computername = 'SERVER01'
            DeviceID     = 'C:'
            Size         = 500GB
            Freespace    = (Get-Random -Minimum 75GB -Maximum 400GB)
        } ,
        [pscustomobject]@{
            Computername = 'SERVER02'
            DeviceID     = 'C:'
            Size         = 237GB
            Freespace    = (Get-Random -Minimum 50GB -Maximum 100gb)
        },
        [pscustomobject]@{
            Computername = 'SERVER02'
            DeviceID     = 'D:'
            Size         = 476GB
            Freespace    = (Get-Random -Minimum 300GB -Maximum 400gb)
        },
        [pscustomobject]@{
            Computername = 'SERVER03'
            DeviceID     = 'C:'
            Size         = 450GB
            Freespace    = (Get-Random -Minimum 300GB -Maximum 350GB)
        },
        [pscustomobject]@{
            Computername = 'SERVER04'
            DeviceID     = 'C:'
            Size         = 450GB
            Freespace    = (Get-Random -Minimum 100GB -Maximum 150GB)
        },
        [pscustomobject]@{
            Computername = 'DOM1'
            DeviceID     = 'C:'
            Size         = 128GB
            Freespace    = (Get-Random -Minimum 90GB -Maximum 100GB)
        },
        [pscustomobject]@{
            Computername = 'SRV1'
            DeviceID     = 'C:'
            Size         = 128GB
            Freespace    = (Get-Random -Minimum 20GB -Maximum 50GB)
        },
        [pscustomobject]@{
            Computername = 'SRV2'
            DeviceID     = 'C:'
            Size         = 128GB
            Freespace    = (Get-Random -Minimum 40GB -Maximum 75GB)
        }        
    )
    #get all properties plus calculate the percentage and get a date
    $servers | Select-Object -Property *, @{Name = "PctFree"; Expression = {($_.Freespace / $_.size) * 100}},
    @{Name = "Date"; Expression = {$date}} 
} | Export-Csv -Path $csv -NoTypeInformation #-Append


