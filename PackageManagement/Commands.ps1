FileSystem Hosting:
Get-PSRepository
Register-PSRepository -Name "PsymonCorp" -SourceLocation "F:\Shared Folder\Repo" -InstallationPolicy Trusted

Get-PSRepository
Find-Module -Repository "PsymonCorp"
Find-Module -name "PSHitchhiker" -Repository "PsymonCorp" | Install-Module -Name "PSHitchhiker" -Scope "CurrentUser"
Install-Module -Name "PSHitchhiker" -Repository "PsymonCorp"
Install-Module -Name "PSHitchhiker" -Repository "PsymonCorp" -Scope CurrentUser

Import-Module PSHitchhiker
get-module
Uninstall-Module -Name "PSHitchhiker"
------
How to create a NuGet feed PowerShell repository:
Local NuGet Server Feed Hosting:
Install-PackageProvider Nuget -Force (C:\Program Files\PackageManagement\ProviderAssemblies\nuget\2.8.5.208\Microsoft.PackageManagement.NuGetProvider.dll)
Unregister-PSRepository LocalNuGetFeed
Get-PSRepository
Register-PSRepository -Name "LocalNuGetFeed" -SourceLocation "http://localhost:8087/nuget" -InstallationPolicy Trusted
Find-Module -name "PSHitchhiker" -Repository "LocalNuGetFeed" | Install-Module -Name "PSHitchhiker" -Scope "CurrentUser"
Find-Module -Repository "LocalNuGetFeed"
Find-Module -Repository "LocalNuGetFeed" -IncludeDependencies

#(C:\Data\App\LocalNuGetFeed\Packages\PSHitchhiker.1.0.25.nupkg)
Install-Module -Name "PSHitchhiker" -Repository "LocalNuGetFeed" -Scope CurrentUser
Install-Module PSHitchhiker -Repository LocalNuGetFeed

Import-Module PSHitchhiker
get-module
Uninstall-Module -Name "PSHitchhiker"
Set-PSRepository -Name LocalNuGetFeed -InstallationPolicy Trusted
If you ever need to get the PowerShell Gallery back, just run the following command:
Register-PSRepository -Default
Publish-Module -Name TestModule -Repository LocalNuGetFeed -NuGetApiKey 'secretKey'
Get-PSRepository -Name PSRepo | Select *

Nuget Command:
nuget.exe push {package file} {apikey} -Source http://localhost:8087/nuget
nuget.exe install PSHitchhiker -Source http://localhost:8087/nuget -OutputDirectory F:\Shared Folder\Repo
nuget delete PSHitchhiker 1.0 -Source http://package.contoso.com/source -apikey blablakey

find-package -name PSHitchhiker -allversion -Source http://localhost:8087/nuget
Install-Package -name PSHitchhiker -Source http://localhost:8087/nuget
Get-Package -name PSHitchhiker

------
Register-PSRepository -Name LocalNuGetFeed -SourceLocation http://localhost:8087/nuget -PublishLocation http://localhost:8087/nuget -InstallationPolicy Trusted
Unregister-PSRepository LocalNuGetFeed

Publish-Module -Repository LocalNuGetFeed -Name 'C:\PublishInternalModule\downloads\Pester\4.4.0\Pester.psd1' -NuGetApiKey "SECRETKEY" -Verbose

Find-PackageProvider -Source 'https://www.powershellgallery.com/api/v2/'
find-packageprovider
get-packageprovider
get-packageprovider -ListAvailable
get-packagesource
Get-PackageSource -verbose

find-package jQuery -Verbose
find-package jQuery -Source Nuget.org -Verbose
find-package jQuery -ProviderName Nuget -Verbose
find-package jQuery -ProviderName nuget -Verbose | save-Package -path c:\foo

get-installedModule -name PSHitchhiker -allversion
get-installedModule
Uninstall-Module -name PSHitchhiker -version 1.0.25
Uninstall-Module -name PSHitchhiker -RequiredVersion 1.0.25

update-module
save-module

