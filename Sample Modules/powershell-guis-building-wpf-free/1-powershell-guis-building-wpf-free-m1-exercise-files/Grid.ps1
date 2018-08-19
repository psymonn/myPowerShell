Add-Type -AssemblyName PresentationFramework
[xml]$Form  = @"
  <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  Title="My First Form" Height="480"  Width="640">
  <Grid Name="MCGrid" Width="400" Background="LightBlue" ShowGridLines="True">
          <Grid.ColumnDefinitions>  
            <ColumnDefinition />  
            <ColumnDefinition Width="45"/>  
            <ColumnDefinition />  
        </Grid.ColumnDefinitions>   
        <Grid.RowDefinitions>  
            <RowDefinition />  
            <RowDefinition Height="45" />  
            <RowDefinition />  
        </Grid.RowDefinitions>   
    <Button Name="MyButton" Width="120" Height="85" Content = 'Hello' Grid.Column="0" Grid.Row="0"/>
    <Button Name="Button2" Width="120" Height="85" Content = 'Hello2' Grid.Column="2" Grid.Row="2"/>
   </Grid>
  </Window>
"@

$NR=(New-Object System.Xml.XmlNodeReader $Form)
$Win=[Windows.Markup.XamlReader]::Load( $NR )

$Win.showdialog()