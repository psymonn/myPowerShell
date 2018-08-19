Add-Type -AssemblyName PresentationFramework 

Function Get-SysTab($computer){
$sys = Get-CimInstance win32_operatingsystem | select-object Caption, installdate, Servicepackmajorversion
$os.content = $sys.caption
$Inst.content =$sys.installdate
$sp.content = $sys.Servicepackmajorversion
}

Function Get-EventTab($computer){
$ev = get-eventlog application -ComputerName $computer -newest 100 | select TimeGenerated, EntryType, Source, InstanceID | sort -property Time
Return $ev
}

Function Get-ProcTab($computer){
$proc = Get-Process -ComputerName $computer| select ID,Name,CPU | Sort -Property Name
Return $proc
}

[xml]$form = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="System Check" Height="396.022" Width="536.587">
    <Grid>
        <TabControl Name="tabControl" HorizontalAlignment="Left" Height="345" Margin="10,10,0,0" VerticalAlignment="Top" Width="509">
            <TabItem Header="General">
                <Grid Background="#FFE5E5E5">
                    <Image Name="image" HorizontalAlignment="Left" Height="213" Margin="10,10,0,0" VerticalAlignment="Top" Width="483" Source="C:\Users\jadkin\Pictures\pluralsight-logo.png" Stretch="UniformToFill"/>
                    <Label Name="label" Content="Enter Computer Name and click start to run the program" HorizontalAlignment="Left" Height="26" Margin="30,226,0,0" VerticalAlignment="Top" Width="451"/>
                    <Label Name="label1" Content="Computer Name:" HorizontalAlignment="Left" Height="33" Margin="30,263,0,0" VerticalAlignment="Top" Width="109"/>
                    <TextBox Name="ComputerName" HorizontalAlignment="Left" Height="32" Margin="147,264,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="224"/>
                    <Button Name="Start" Content="Start" HorizontalAlignment="Left" Height="31" Margin="380,265,0,0" VerticalAlignment="Top" Width="101"/>
                </Grid>
            </TabItem>
            <TabItem Header="System">
                <Grid Background="#FFE5E5E5">
                    <Label Name="label2" Content="Operating System:" HorizontalAlignment="Left" Height="28" Margin="10,10,0,0" VerticalAlignment="Top" Width="118"/>
                    <Label Name="label3" Content="Installation Date:" HorizontalAlignment="Left" Height="27" Margin="10,51,0,0" VerticalAlignment="Top" Width="116"/>
                    <Label Name="label4" Content="Service Pack:" HorizontalAlignment="Left" Height="25" Margin="10,94,0,0" VerticalAlignment="Top" Width="118"/>
                    <Label Name="OS" Content="" HorizontalAlignment="Left" Height="28" Margin="131,10,0,0" VerticalAlignment="Top" Width="289"/>
                    <Label Name="InstallDate" Content="" HorizontalAlignment="Left" Height="27" Margin="131,51,0,0" VerticalAlignment="Top" Width="289"/>
                    <Label Name="ServicePack" Content="" HorizontalAlignment="Left" Height="25" Margin="133,94,0,0" VerticalAlignment="Top" Width="287"/>
                </Grid>
            </TabItem>
            <TabItem Header="Event">
                <Grid Background="#FFE5E5E5">
                    <Label Name="label5" Content="Current Events" HorizontalAlignment="Left" Height="28" Margin="10,10,0,0" VerticalAlignment="Top" Width="261" FontWeight="Bold"/>
                    <DataGrid Name="EVdataGrid" HorizontalAlignment="Left" Height="262" Margin="10,45,0,0" VerticalAlignment="Top" Width="482"/>
                </Grid>
            </TabItem>
            <TabItem Header="Processes">
                <Grid Background="#FFE5E5E5">
                    <Label Name="label6" Content="Current Processes" HorizontalAlignment="Left" Height="26" Margin="10,10,0,0" VerticalAlignment="Top" Width="135" FontWeight="Bold"/>
                    <DataGrid Name="ProcdataGrid" HorizontalAlignment="Left" Height="262" Margin="10,45,0,0" VerticalAlignment="Top" Width="478"/>
                </Grid>
            </TabItem>
        </TabControl>

    </Grid>
</Window>

"@
$NR=(New-Object System.Xml.XmlNodeReader $Form)
$Win=[Windows.Markup.XamlReader]::Load( $NR ) 

$computer = $win.FindName("ComputerName")
$start = $win.FindName("Start")
$os = $win.FindName("OS")
$Inst = $win.FindName("InstallDate")
$sp = $win.FindName("ServicePack")
$edg = $win.FindName("EVdataGrid")
$pdg = $win.FindName("ProcdataGrid")

$arrev = New-Object System.Collections.ArrayList
$arrproc = New-Object System.Collections.ArrayList

$start.add_click({
$comp = $computer.Text
Get-Systab $comp
$events= Get-EventTab $comp
$arrev.addrange($events)
$edg.ItemsSource=@($arrev)
$Procs = Get-ProcTab $comp
$arrproc.addrange($Procs)
$pdg.ItemsSource=@($arrproc)
})

#$arr.addrange($ev)
#$dg.ItemsSource =@($arr)
$Win.ShowDialog() 