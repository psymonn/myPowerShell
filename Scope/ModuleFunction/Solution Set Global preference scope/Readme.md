Test1:
gobal is currently set as $ErrorActionPreference = Continue
After got source this here is the result:

PS C:\> New-AwesomeFunction
dot source Get-CallerPreference.ps1
Original: ErrorActionPreference = Continue
Original: 
Set: ErrorActionPreference = SilentlyContinue
Set: Who am I?
you reached Get-CallerPreference module
Init-PreferenceMultiple Function: ErrorActionPreference = SilentlyContinue
PsymonPeferenceVariable: Who am I?
outside loaded get-calledPreference ErrorActionPreference - SilentlyContinue
###############################
not loaded1 get-calledPreference - SilentlyContinue
Set not loaded2 get-calledPreference Set to Stop = SilentlyContinue
you reached Get-CallerPreference module
loaded3 get-calledPreference - SilentlyContinue
###########################3#############
not loadedA get-calledPreference - SilentlyContinue
not loadedB get-calledPreference - SilentlyContinue
you reached Get-CallerPreference module
loaded2C get-calledPreference - SilentlyContinue

Test2:
gobal is currently set as $ErrorActionPreference = Stop
After got source this here is the result:

PS F:\GitHub\Source\ProjectSamples\Plaster New Project\TemplateProject\GoodSample7\GoodSample7>>> New-AwesomeFunction
ErrorActionPreference: Stop
loaded get-calledPreference - Stop
outside loaded get-calledPreference - Stop
###############################
not loaded get-calledPreference - Stop
loaded get-calledPreference - Stop

Note: If you use import-module to your module, the global variables will override all your script variables if after executed Get-CallerPreference module.

[Conclusion]
Usage of Get-CallerPreference.ps1:
(your script as an init caller) If you want to overide all your subsequent scripts use . source
(global as an init caller) If you want to use global setting for every subsequent scripts use import-moudle
