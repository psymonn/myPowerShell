#region Script Settings
#<ScriptSettings xmlns="http://tempuri.org/ScriptSettings.xsd">
#  <ScriptPackager>
#    <process>powershell.exe</process>
#    <arguments />
#    <extractdir>%TEMP%</extractdir>
#    <files />
#    <usedefaulticon>false</usedefaulticon>
#    <icon>C:\Users\jadkin\Pictures\icon.ico</icon>
#    <showinsystray>false</showinsystray>
#    <altcreds>false</altcreds>
#    <efs>true</efs>
#    <ntfs>true</ntfs>
#    <local>false</local>
#    <abortonfail>true</abortonfail>
#    <product />
#    <version>1.0.0.1</version>
#    <versionstring />
#    <comments />
#    <company />
#    <includeinterpreter>false</includeinterpreter>
#    <forcecomregistration>false</forcecomregistration>
#    <consolemode>false</consolemode>
#    <EnableChangelog>false</EnableChangelog>
#    <AutoBackup>false</AutoBackup>
#    <snapinforce>false</snapinforce>
#    <snapinshowprogress>false</snapinshowprogress>
#    <snapinautoadd>2</snapinautoadd>
#    <snapinpermanentpath />
#    <cpumode>1</cpumode>
#    <hidepsconsole>true</hidepsconsole>
#  </ScriptPackager>
#</ScriptSettings>
#endregion

#region  Script  Settings
#<ScriptSettings xmlns="http://tempuri.org/ScriptSettings.xsd">
#  <ScriptPackager>
#    <process>powershell.exe</process>
#    <arguments />
#    <extractdir>%TEMP%</extractdir>
#    <files />
#    <usedefaulticon>true</usedefaulticon>
#    <showinsystray>false</showinsystray>
#    <altcreds>false</altcreds>
#    <efs>true</efs>
#    <ntfs>true</ntfs>
#    <local>false</local>
#    <abortonfail>true</abortonfail>
#    <product />
#    <version>1.0.0.1</version>
#    <versionstring />
#    <comments />
#    <company />
#    <includeinterpreter>false</includeinterpreter>
#    <forcecomregistration>false</forcecomregistration>
#    <consolemode>false</consolemode>
#    <EnableChangelog>false</EnableChangelog>
#    <AutoBackup>false</AutoBackup>
#    <snapinforce>false</snapinforce>
#    <snapinshowprogress>false</snapinshowprogress>
#    <snapinautoadd>2</snapinautoadd>
#    <snapinpermanentpath />
#    <cpumode>1</cpumode>
#    <hidepsconsole>false</hidepsconsole>
#  </ScriptPackager>
#</ScriptSettings>
#endregion

Add-Type -AssemblyName PresentationFramework 

function Get-SysTab($computer)
{
	$sys = Get-CimInstance -ComputerName $Computer win32_operatingsystem | Select-Object Caption, installdate, Servicepackmajorversion
	$os.content = $sys.caption
	$Inst.content = $sys.installdate
	$sp.content = $sys.Servicepackmajorversion
}

function Get-EventTab($computer)
{
	$ev = Get-EventLog application -ComputerName $computer -newest 100 | select TimeGenerated, EntryType, Source, InstanceID | sort-property Time
	return $ev
}

function Get-ProcTab($computer)
{
	$proc = Get-Process -ComputerName $computer | select ID, Name, CPU | sort-Property CPU -Descending
	return $proc
}

[xml]$form = Get-Content 'C:\Users\jadkin\Documents\AdminScriptEditor\app.xaml'
$NR = (New-Object System.Xml.XmlNodeReader $Form)
$Win = [Windows.Markup.XamlReader]::Load($NR) 

$computer = $win.FindName("ComputerName")
$start = $win.FindName("Start")
$os = $win.FindName("OS")
$Inst = $win.FindName("InstallDate")
$sp = $win.FindName("ServicePack")
$edg = $win.FindName("EVdataGrid")
$pdg = $win.FindName("ProcdataGrid")

$arrev = New-Object System.Collections.ArrayList
$arrproc = New-Object System.Collections.ArrayList

$start.add_click( {
		$comp = $computer.Text
		Get-Systab $comp
		$events = Get-EventTab $comp
		$arrev.addrange($events)
		$edg.ItemsSource = @($arrev)
		$Procs = Get-ProcTab $comp
		$arrproc.addrange($Procs)
		$pdg.ItemsSource = @($arrproc)
} )

$Win.ShowDialog() 