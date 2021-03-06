# gotcha #1: ~

# in powershell, ~ has a special meaning when used in a path string:
get-item ~

# at first glance ~ seems to point to the user's home directory

cd ~/documents

<#    
    in fact, if you're familiar at all with Linux, this perspective is reinforced
    because on Linux, ~ always resolves to your own personal folder

    on Linux it doesn't matter where you are, ~ always points to the same place:
        
    demo: cd ~ on linux
    
    on Linux ~ is an anchor.
#>

<# 
    unfortunately in PowerShell, ~ doesn't always point to the same place.
    
    on PowerShell ~ is more of a broken link.
    
    the meaning of ~ varies depending on where I am in the shell
#>

# for example, I can move to the registry Current User drive and ~ has no meaning
cd hkcu:
ls
ls ~

<#
ERROR:
    Get-ChildItem : Cannot retrieve the dynamic parameters for the cmdlet. Home location for
this provider is not set. To set the home location, call "(get-psprovider 'Registry').Hom
e = 'path'".
At line:1 char:3
+ ls <<<<  ~
    + CategoryInfo          : InvalidArgument: (:) [Get-ChildItem], ParameterBindingExce
   ption
    + FullyQualifiedErrorId : GetDynamicParametersException,Microsoft.PowerShell.Command
   s.GetChildItemCommand
#>

<#
    this error gives a clue as to the problem: ~ translates to the home location for the 
    CURRENT PROVIDER, not for the CURRENT USER

    which makes ~ pretty fragile, considering that the only provider to have a home value 
    by default is the file sytem provider:
#>
get-psprovider | select-object Name,Home

<#    
    look at the error again...
    the error message tells us another tidbit: these home locations can be
    modified by the user!
#>

# for instance I can set the home location for the registry provider:
(get-psprovider registry).home = "hkcu:\software"

# after which point ~ will have meaning for registry drives:
ls ~

<#
    so in this light ~ is pretty fragile:
    1) it's definition varies and depends on your current location
    2) the user can change it's definition at whim

    consider what could happen if you use ~ in a script:
#>

# dir | copy-item -dest ~/documents/things
# or worse...
# remove-item ~ -recurse -include *.exe

<#
    okay, so if you can't use ~, how DO you reference the user's home location?
    
    you have a few options:
#>

cls

# first, there's the $home built-in variable:
$home

# home never changes, it always points to the user's home path
# more specifically, it points to %homedrive%%homepath%
$env:homedrive + $env:homepath

# another option, you can use the GetFolderPath static method of the Environment class:

# you can get the My Documents folder
[environment]::getFolderPath( 'mydocuments' );

# or any number of other special path locations
[environment]::getFolderPath( 'history' );

# you can get a list of these special folder names by listing the specialfolder enumeration:
[enum]::getnames([system.environment+specialfolder])




