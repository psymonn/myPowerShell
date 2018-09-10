#run as 32bit version of powershell, allow local script execution
if ($env:Processor_Architecture -ne "x86")
{
    write-warning 'Relaunching as x86 PowerShell'
    &"$env:windir\syswow64\windowspowershell\v1.0\powershell.exe" -noprofile -executionpolicy bypass -file $myinvocation.Mycommand.path -Remedy_Environment $Remedy_Environment
    exit
}

#http://powershell.cz/2013/04/04/hide-and-show-console-window-from-gui/
Add-Type -Name Window -Namespace Console -MemberDefinition '[DllImport("Kernel32.dll")]public static extern IntPtr GetConsoleWindow(); [DllImport("user32.dll")]public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'
function Show-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 5) #5 show
}

function Hide-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0) #0 hide
}

#==============#
#   ERROR LOG  #
#==============#
set-psdebug -strict
Import-Module $PSScriptRoot\Utilities\Logging.psm1 -force
Set-Variable APP_VERSION -option Constant -scope "Global" -value '0.03'
$DebugPreference = 'Continue'
$LogFilePreference = "$PSScriptRoot\\" + (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Name + "_runlog.txt"
write-host "log: $LogFilePreference"

#==============#
#      GUI     #
#==============#
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')

[xml]$xaml_window_structure = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="ClearOutlook" Height="330" Width="555" WindowStartupLocation="CenterScreen" ResizeMode="NoResize" Background="#474747">
    <Grid Margin="10,0,0,0">
        <Label
            Name="Title"
            HorizontalAlignment="Center"
            VerticalAlignment="Top"
            Height="33"
            Content="ClearOutlook"
            Width="515"
            Margin="-10,0,0,0"
            Foreground="White"
            Background="#0072C6"
            FontSize="16"
        />

        <Label
            Name="lblComputerName"
            Content="Computer name"
            HorizontalAlignment="Left"
            Margin="0,47,0,0"
            VerticalAlignment="Top"
            Height="30"
            Width="170"
            Background="#0072C6"
            Foreground="White"
        />
        <TextBox
            Name="txtComputerName"
            HorizontalAlignment="Left"
            Height="30"
            Margin="175,47,0,0"
            TextWrapping="Wrap"
            Text=""
            VerticalAlignment="Top"
            Width="343"
            IsEnabled="true"
        />

        <!-- "horizontal line" -->
        <Label
            Name = "lblLine"
            Content=""
            HorizontalAlignment="Center"
            Margin="0,85,0,0"
            VerticalAlignment="Top"
            Height="1"
            Width="485"
            Background="#999999"
        />

        <Label
            Name= "lblResponse"
            Content="Response"
            HorizontalAlignment="Left"
            Margin="0,93,0,0"
            VerticalAlignment="Top"
            Height="30"
            Width="515"
            Background="#0072C6"
            Foreground="White"
        />


        <TextBox
            Name="txtResponseBody"
            HorizontalAlignment="Left"
            Height="100"
            Margin="0,130,0,0"
            TextWrapping="Wrap"
            AcceptsReturn="True"
            Text=""
            VerticalAlignment="Top"
            Width="513"
            IsEnabled="true"
        />

        <Button Name="btnBloom"
            Content="Bloom"
            HorizontalAlignment="Left"
            Margin="110,240,0,0"
            VerticalAlignment="Top"
            Width="125"
            Height="34"
            BorderThickness="2"
        />

        <Button Name="btnExit"
            Content="Exit"
            HorizontalAlignment="Left"
            Margin="290,240,0,0"
            VerticalAlignment="Top"
            Width="125"
            Height="34"
            BorderThickness="2"
        />

    </Grid>
</Window>
'@
#Read XAML

$reader=(New-Object System.Xml.XmlNodeReader $xaml_window_structure)
try
{
    $Form=[Windows.Markup.XamlReader]::Load($reader)
}
catch
{
    Write-DebugLog $_.Exception.Message
    Write-DebugLog "Unable to load Windows.Markup.XamlReader."
    Write-Host $_.Exception.Message
    Write-Host "Unable to load Windows.Markup.XamlReader."; exit
}

#==============#
#   FORM OBJ   #
#==============#
$xaml_window_structure.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}
$Form.Topmost = $False

$Title.Content="ClearOutlook - v$APP_VERSION"


#==============#
#   INIT VAR   #
#==============#
$txtComputerName.Text = ''


#==============#
#    EVENTS    #
#==============#

#close event
$Form.add_Closing({
Show-Console
})

#exit
$btnExit.Add_Click({$form.Close()})

#execute main function
$btnBloom.Add_Click({
    Do-Bloom
})

#==============#
#   FUNCTION   #
#==============#
function Do-Bloom(){

    if ($txtComputerName.text.length -eq 0)
    {
        [System.Windows.Forms.MessageBox]::Show("No computer name provided")
    }
    else {
        $computername = $txtComputerName.text

        if ($computername.ToLower().StartsWith("w")) {
            #obtain current user's username
            $error.clear()
            $domainUsersName = gwmi win32_computersystem -ComputerName $computername | select -expandproperty username -first 1
            if ($error) {
                Write-DebugLog $error
                $txtResponseBody.text = $error
            } else {
                $usersNameArr = $domainUsersName -split "\\"
                $usersName = $usersNameArr[1]

                #check free disk space
                $targetDiskTable = gwmi Win32_LogicalDisk -comp $computername -Filter "DeviceID='C:'" | select-object freespace | format-table -hidetableheaders
                $targetDisk = out-string -inputobject $targetDiskTable

                #check low disk space
                if ([long]$targetDisk.trim() -le 500000000) {    
                    Write-debuglog "Low disk space - $targetDisk"
                    $txtResponseBody.text = "Low disk space " + [long]$targetDisk.trim()
                } else {
                    #kill Outlook Notes processes
                    #(Get-WmiObject Win32_Process -ComputerName $computername | ?{ $_.ProcessName -match "nlnotes" }).Terminate()
                    (Get-WmiObject Win32_Process -Filter "ExecutablePath LIKE '%outlook%'" -ComputerName $computername).terminate()

                    $targetpath = "\\$computername\C$\Users\$usersName\AppData\Local\Microsoft"

                    if (Test-Path "$targetpath\Outlook Backups") {
                    } else {
                        New-Item -ItemType Directory -Force -Path "$targetpath\Outlook Backups"
                    }

                    #(Get-WmiObject -Computer 'WDAUD6210GG1' -Class Win32_OperatingSystem).caption - to check OS
                    $rawTimeDate = get-date -format o
                    $timeDate = $rawTimeDate.substring(0,19) -replace ':'
                    Write-DebugLog $targetpath
                    Write-DebugLog $timeDate

                    if (Test-Path "$targetpath\Outlook") {
                        $error.clear()
                        Move-Item -Path "$targetpath\Outlook" -Destination "$targetpath\Outlook Backups\$timeDate" -force
                        if ($error) {
                            Write-DebugLog $error
                            $txtResponseBody.text = $error
                        } else {
                            Write-DebugLog "Completed"
                            $txtResponseBody.text = "Outlook has been closed on " + $computername + "`nData folder has been moved to " + "C:\Users\$usersName\AppData\Local\Outlook Backups\$timeDate"
                        }
                    } else {
                        $error.clear()
                        Move-Item -Path "$targetpath\Outlook" -Destination "$targetpath\Outlook Backups\$timeDate" -force
                        if ($error) {
                            Write-DebugLog $error
                            $txtResponseBody.text = $error
                        } else {
                            Write-DebugLog "Completed"
                            $txtResponseBody.text = "Outlook has been closed on " + $computername + "`nData folder has been moved to " + "C:\Users\$usersName\AppData\Local\Outlook Backups\$timeDate"
                        }
                    }

                    
                }
                #restart Outlook Notes
                #Invoke-Command -ComputerName WDAUD6210GG1 -ScriptBlock { Start-Process calc.exe }
                #may not be possible
            }
        } else {
            #insert Citrix support
        }
    }
}


#==============#
#     MISC     #
#==============#

#Dev console
    $a = new-object -comobject wscript.shell
    $intAnswer = $a.popup("Do you want to hide the console?", 0,"Hide Console",4)
    If ($intAnswer -eq 6) {
        Hide-Console
    }

# Show the form
$Form.ShowDialog() | out-null