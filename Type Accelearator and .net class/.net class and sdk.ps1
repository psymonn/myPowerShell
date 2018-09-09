https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.language?view=powershellsdk-1.1.0
https://docs.microsoft.com/en-us/dotnet/api/system.text.regularexpressions.regex.replace?view=netframework-4.7.2
https://docs.microsoft.com/en-us/powershell/scripting/getting-started/fundamental/sample-scripts-for-administration?view=powershell-5.0

$class="system.net.webclient" ; $o=new-object $class ; $o |get-member -MemberType method
[system.net.webclient]|get-member  -MemberType method
[system.net.webclient]|get-member  -MemberType ALL



[System.Environment]::OSVersion.VersionString
$Context.Description -split "$([System.Environment]::NewLine)" | ForEach {
($([System.Environment]::NewLine),"\n","`n"),  [System.StringSplitOptions]::RemoveEmptyEntries)
$positionMessage = $info.PositionMessage -split '\r?\n' -match '\S' -join [System.Environment]::NewLine
return $statements -join "$([System.Environment]::NewLine)"

"Content" = [System.Convert]::ToBase64String($bytes);

"Greg" | Should -Match ([regex]::Escape(".reg")) # Test will fail
$Name = [regex]::Replace(
$err.Exception.Message -replace [regex]::Escape($currentPath),'path' | Verify-Equal "Expected path 'path' to not exist, because reason, but it did exist."
$escapedTestPath = [regex]::Escape($testPath)
$expandedName = [regex]::Replace($name, '<([^>]+)>', {
$isMatch = [regex]::IsMatch($_.Exception.Message, $retryTriggerErrorPattern)
$nonMatches = $pathsToTest -notmatch "^$([regex]::Escape($parentPath))"
$pattern = "^$([regex]::Escape($parent))\\?"
$result = $string -ireplace [regex]::Escape($substring), ""
$thisScriptRegex = [regex]::Escape($MyInvocation.MyCommand.Path)
'TestDrive:\file.txt' | Should -FileContentMatch ([regex]::Escape('I.am.a.file')) # Test will fail
Tip: Use [regex]::Escape("pattern") to match the exact text.

[String]::IsNullOrWhitespace is not available in .NET version used with PowerShell 2
$catalogItemsUri = [String]::Format($catalogItemsUri, $RsItem)
$dataSourcesUri = [String]::Format($dataSourcesUri, $RsItemType + "s", $RsItem)
$filterOnId = -not [string]::IsNullOrEmpty($ErrorId -replace "\s")
$filterOnMessage = -not [string]::IsNullOrEmpty($ExpectedMessage -replace "\s")
$foldersUri = [String]::Format($foldersUri, $RsFolder)
$global = [string]::Equals($scope, "global", [StringComparison]::CurrentCultureIgnoreCase)
$succeeded = [String]::IsNullOrEmpty($expandedValue)
$uri = [String]::Format($catalogItemsByPathApi, $itemPath)
Assert (![string]::IsNullOrEmpty($psake.build_script_dir)) '$psake.build_script_dir was null or empty'
Checks values for null or empty (strings). The static [String]::IsNullOrEmpty() method is used to do the comparison.
If (-not [String]::IsNullOrEmpty($ASTParameters) -and $AcceptMissedHelpParameters -notcontains $Function ) {
If ([String]::IsNullOrEmpty($ReportStrings)) {
Where-Object { -not [String]::IsNullOrEmpty($_) } |
[String]::IsNullOrEmpty((Remove-Comments $test.ToString()) -replace "\s"))
if ( -not ([String]::IsNullOrEmpty($Folder))) {
if ([string]::IsNullOrEmpty($path))
return [string]::Empty
{ [string]::IsNullOrEmpty($_) } {

$folderNullOrEmpty = [System.String]::IsNullOrEmpty($RsFolder)
$itemNullOrEmpty = [System.String]::IsNullOrEmpty($RsItem)
if ([System.String]::IsNullOrEmpty($RsItem))


$AST = [System.Management.Automation.Language.Parser]::ParseInput((Get-Content function:$Function), [ref]$null, [ref]$null)
$ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref] $tokens, [ref] $errors)

$CWD = [Environment]::CurrentDirectory
$modulePaths = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine') -split ';'
$traceLines = $ErrorRecord.ScriptStackTrace.Split([Environment]::NewLine, [System.StringSplitOptions]::RemoveEmptyEntries)
[Environment]::CurrentDirectory = & $SafeCommands["Get-Location"] -PSProvider FileSystem
[Environment]::SetEnvironmentVariable('PSModulePath', $newModulePath, 'Machine')

$ComputerName = ([Microsoft.ReportingServicesTools.ConnectionHost]::ComputerName),
$Credential = ([Microsoft.ReportingServicesTools.ConnectionHost]::Credential),
$Instance = ([Microsoft.ReportingServicesTools.ConnectionHost]::Instance)
$ReportPortalUri = ([Microsoft.ReportingServicesTools.ConnectionHost]::ReportPortalUri),
$ReportServerInstance = ([Microsoft.ReportingServicesTools.ConnectionHost]::Instance),
$ReportServerUri = ([Microsoft.ReportingServicesTools.ConnectionHost]::ReportServerUri),
$ReportServerVersion = ([Microsoft.ReportingServicesTools.ConnectionHost]::Version),
$Server = [Microsoft.ReportingServicesTools.ConnectionHost]::ComputerName
$Version = [Microsoft.ReportingServicesTools.ConnectionHost]::Version
$proxy = New-RsWebServiceProxy -ReportServerUri ([Microsoft.ReportingServicesTools.ConnectionHost]::ReportServerUri) -Credential ([Microsoft.ReportingServicesTools.ConnectionHost]::Credential) -ErrorAction Stop

[Microsoft.ReportingServicesTools.ConnectionHost]::ComputerName = $ComputerName
[Microsoft.ReportingServicesTools.ConnectionHost]::Credential = $Credential
[Microsoft.ReportingServicesTools.ConnectionHost]::Instance = $ReportServerInstance
[Microsoft.ReportingServicesTools.ConnectionHost]::Proxy = $proxy
[Microsoft.ReportingServicesTools.ConnectionHost]::ReportServerUri = $ReportServerUri
[Microsoft.ReportingServicesTools.ConnectionHost]::Version = $ReportServerVersion
elseif ([Microsoft.ReportingServicesTools.ConnectionHost]::ComputerName)
if ([Microsoft.ReportingServicesTools.ConnectionHost]::Proxy)
return "$([Microsoft.ReportingServicesTools.ConnectionHost]::ReportServerUri) : $Target"
return ([Microsoft.ReportingServicesTools.ConnectionHost]::Proxy)
return [Microsoft.ReportingServicesTools.ConnectionHost]::ReportServerUri

throw (New-Object System.Exception("Failed to establish proxy connection to $([Microsoft.ReportingServicesTools.ConnectionHost]::ReportServerUri) : $($_.Exception.Message)", $_.Exception))

$Path = & $SafeCommands['Join-Path'] -Path $tempPath -ChildPath ([Guid]::NewGuid())
$guid = [Guid]::NewGuid().Guid
BootstrapFunctionName   = 'PesterMock_' + [Guid]::NewGuid().Guid

<_RestoreSettingsPerFramework Include="$([System.Guid]::NewGuid())">
[string]$tempid = [System.Guid]::NewGuid()

$Show = [Pester.OutputTypes]::None
$quiet = $pester.Show -eq [Pester.OutputTypes]::None
$setting = [Pester.OutputTypes]::Passed
[Pester.OutputTypes]::Fails | Should -Be $expected

$XmlWriter.WriteAttributeString('current-uiculture', ([System.Threading.Thread]::CurrentThread.CurrentUiCulture).Name)
$oldCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
[System.Threading.Thread]::CurrentThread.CurrentCulture = $oldCulture

$XmlWriter.WriteAttributeString('xsi','noNamespaceSchemaLocation', [Xml.Schema.XmlSchema]::InstanceNamespace , 'nunit_schema_2.5.xsd')


$ast.DefiningKeyword.BodyMode -eq [System.Management.Automation.Language.DynamicKeywordBodyMode]::Hashtable)

$bytes = [System.IO.File]::ReadAllBytes($EntirePath)
$lines = [System.IO.File]::ReadAllLines($file.FullName)
[System.IO.File]::WriteAllBytes($destinationFilePath, $response.Content)
[System.IO.File]::WriteAllText($destinationFilePath, (ConvertTo-Json $itemContent))


$closeIndex = [Pester.ClosingBraceFinder]::GetClosingBraceIndex($Tokens, $GroupStartTokenIndex)

$cmd = [scriptblock]::Create($scriptBlockString)
$mockScript = [scriptblock]::Create($code)
$scriptBlock = [scriptblock]::Create($setupOrTeardownCodeText)
$scriptBlock = [scriptblock]::Create('"Mocked"')

$cmdletBinding = [Management.Automation.ProxyCommand]::GetCmdletBindingAttribute($metadata)
$paramBlock = [Management.Automation.ProxyCommand]::GetParamBlock($metadata)

$cmdletBinding = [System.Management.Automation.ProxyCommand]::GetCmdletBindingAttribute($Metadata)
$paramBlockSafeForDynamicParams = [System.Management.Automation.ProxyCommand]::GetParamBlock($metadataSafeForDynamicParams)

$command = $ExecutionContext.InvokeCommand.GetCommand($CmdletName, [System.Management.Automation.CommandTypes]::Cmdlet, $paramsArg)
while ($null -ne $command -and $command.CommandType -eq [System.Management.Automation.CommandTypes]::Alias)


$content = [System.Text.Encoding]::Unicode.GetString($bytes)

$datasource.CredentialRetrieval = [Enum]::Parse($credentialRetrievalEnumType, $CredentialRetrieval)

$dynParam = [System.Management.Automation.RuntimeDefinedParameter]::new($param.Name, $param.ParameterType, $param.Attributes)

$errorCategory = [Management.Automation.ErrorCategory]::InvalidResult

return $Path -replace "^$([regex]::Escape("$RelativeTo$([System.IO.Path]::DirectorySeparatorChar)"))?"
$extension = [System.IO.Path]::GetExtension($unresolvedPath)
[String]$testFile = "$TestDrive{0}Results{0}Tests.xml" -f [System.IO.Path]::DirectorySeparatorChar


$isNumberedScope = [int]::TryParse($DesiredScope, [ref] $target)
if ($coverEnd -le 0) { $coverEnd = [int]::MaxValue }

$mySession.Headers['X-XSRF-TOKEN'] = [System.Web.HttpUtility]::UrlDecode($xsrfToken)

$paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

$ps = [Powershell]::Create()

$ps.runspace = [runspacefactory]::CreateRunspace()

$psISE.Options.ErrorForegroundColor = [System.Windows.Media.Colors]::Chartreuse

$ptrSize = [System.IntPtr]::Size

$script:Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

$time = [math]::Floor($Seconds * 1000)
$time = [math]::Round($Seconds, 2)
[long]$endTime =  [math]::Floor((new-timespan -start $nineteenseventy -end $now).TotalSeconds * 1000)
[long]$startTime = [math]::Floor($endTime - $PesterState.Time.TotalSeconds*1000)
[string][math]::round(([TimeSpan]$TimeSpan).totalseconds,4)
return [Math]::Max(0, $this.TestGroupStack.Count - 2)



$tokens = [System.Management.Automation.PSParser]::Tokenize($CodeText, [ref] $parseErrors)

$tokens[$CommandIndex + 1].Type -ne [System.Management.Automation.PSTokenType]::GroupStart -or
elseif ($type -eq [System.Management.Automation.PSTokenType]::GroupStart)
if ($type -eq [System.Management.Automation.PSTokenType]::Command -and


$xmlFile = [IO.File]::Create($Path)
IO.File]::WriteAllLines("$pwd\$file", "")

$xmlWriter = [Xml.XmlWriter]::Create($xmlFile, $settings)

-not [object]::ReferenceEquals($Value, $($Value))
if (-not [object]::ReferenceEquals($Expected, $Actual)) {
if ([object]::ReferenceEquals($Expected, $Actual)) {


@{ Value = [System.DayOfWeek]::Monday},
DateTime] $start = [DateTime]::Today,
Duration = [System.TimeSpan]::Zero

ErrorAction = [System.Management.Automation.ActionPreference]::Stop

New-Item "Function::Command '‘’‚‛" -Value { 'orig' }
[Array]::Reverse($testGroups)
[Microsoft.Windows.PowerShell.ScriptAnalyzer.Settings]::GetSettingPresets() | `
[System.IO.Compression.ZipFile]::CreateFromDirectory($pwd, $zipFilePath)
[System.Runtime.Serialization.Formatterservices]::GetUninitializedObject($Type)
[string[]] $highlightDate = [DateTime]::Today.ToString()
if ([uint32]::TryParse($_, [ref] $null) -or
if($sessionInfo.Session.State -ne [System.Management.Automation.Runspaces.RunspaceState]::Opened)
local:script:private:variable::*qInput dictionary should have OrdinalIgnoreCase 
$ActualValue.ToString().IndexOf($ExpectedValue, [System.StringComparison]::InvariantCultureIgnoreCase) -ge 0
[convert]::ToBase64String($bytes)
self::%ancestor-or-self::[]@{0}='{1}' and /./documentlineInfo//namespace::*xdt//xdt:*}The expected namespace {0} 
{ [System.Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($args[0]) }

$SafeCommands['New-Object'] 'Collections.Generic.Dictionary[string,object]'([StringComparer]::InvariantCultureIgnoreCase)
