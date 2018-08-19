 Add-Type -AssemblyName PresentationFramework
[xml]$Form  = @"
  <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  Title="My First Form" Height="480"  Width="640">
  <Button Name="MyButton" Width="120" Height="85" Content = 'Hello' />
  </Window>
"@

$NR=(New-Object System.Xml.XmlNodeReader $Form)
$Win=[Windows.Markup.XamlReader]::Load( $NR )

$Win.showdialog()