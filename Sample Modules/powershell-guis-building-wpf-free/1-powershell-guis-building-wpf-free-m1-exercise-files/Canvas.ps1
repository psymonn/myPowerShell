Add-Type -AssemblyName PresentationFramework
[xml]$Form  = @"
  <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  Title="My First Form" Height="480"  Width="640">
  <Canvas>
    <Button Name="MyButton" Width="120" Height="85" Content = 'Hello'/>
    <Button Name="Button2" Width="120" Height="85" Content = 'Hello2'/>
   </Canvas>
  </Window>
"@

$NR=(New-Object System.Xml.XmlNodeReader $Form)
$Win=[Windows.Markup.XamlReader]::Load( $NR )

$Win.showdialog()