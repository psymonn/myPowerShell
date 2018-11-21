[System.Reflection.Assembly]::LoadWithPartialName("System.Management.Automation.TypeAccelerators")
$TAType = [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")
$TAType::Add('accelerators',$TAType)
[accelerators]::Get
[accelerators]::Get['xml']
[System.Diagnostics.Process] |gm -static
[System.Diagnostics.Process]::GetProcesses()
[System.Diagnostics.Process]::GetProcesses("notepad.exe")
[System.Diagnostics.Process]::GetProcessById("11412")
[System.Diagnostics.Process]::GetProcessesByName("jenkins")

------------------------------------------------------------
Access the property this way won't give you much info:
------------------------------------------------------------
PS C:\Users\TI> [System.Diagnostics.Process].FullName
System.Diagnostics.Process

-----------------------------------------------------------------------------------
This is a better way, access by method e.g GetProcessesByName first then property:
-----------------------------------------------------------------------------------
$a = [System.Diagnostics.Process]::GetProcessesByName("jenkins")
$a.ProcessName

([System.Diagnostics.Process]::GetProcessesByName("jenkins")).ProcessName

$ao = new-object ([System.Diagnostics.Process]::GetCurrentProcess())
$ao |gm
$ao.StartInfo

-----------------
This property works because it's a static property:
PS C:\Users\TI> [system.datetime] |gm -static


   TypeName: System.DateTime

Name            MemberType Definition
----            ---------- ----------
Compare         Method     static int Compare(datetime t1, datetime t2)
DaysInMonth     Method     static int DaysInMonth(int year, int month)
Equals          Method     static bool Equals(datetime t1, datetime t2), static bool Equals(System.Object objA, System.Object objB)
FromBinary      Method     static datetime FromBinary(long dateData)
FromFileTime    Method     static datetime FromFileTime(long fileTime)
FromFileTimeUtc Method     static datetime FromFileTimeUtc(long fileTime)
FromOADate      Method     static datetime FromOADate(double d)
IsLeapYear      Method     static bool IsLeapYear(int year)
new             Method     datetime new(long ticks), datetime new(long ticks, System.DateTimeKind kind), datetime new(int year, int month, int day), datetime new(int year, int month, int day, System.Globaliz...
Parse           Method     static datetime Parse(string s), static datetime Parse(string s, System.IFormatProvider provider), static datetime Parse(string s, System.IFormatProvider provider, System.Globaliza...
ParseExact      Method     static datetime ParseExact(string s, string format, System.IFormatProvider provider), static datetime ParseExact(string s, string format, System.IFormatProvider provider, System.Gl...
ReferenceEquals Method     static bool ReferenceEquals(System.Object objA, System.Object objB)
SpecifyKind     Method     static datetime SpecifyKind(datetime value, System.DateTimeKind kind)
TryParse        Method     static bool TryParse(string s, [ref] datetime result), static bool TryParse(string s, System.IFormatProvider provider, System.Globalization.DateTimeStyles styles, [ref] datetime re...
TryParseExact   Method     static bool TryParseExact(string s, string format, System.IFormatProvider provider, System.Globalization.DateTimeStyles style, [ref] datetime result), static bool TryParseExact(str...
MaxValue        Property   static datetime MaxValue {get;}
MinValue        Property   static datetime MinValue {get;}
Now             Property   datetime Now {get;}
Today           Property   datetime Today {get;}
UtcNow          Property   datetime UtcNow {get;}


PS C:\Users\TI> [system.datetime]::Today

Sunday, 18 November 2018 12:00:00 AM
------------
([system.datetime]::now) | gm
([system.datetime]::now).GetType()

-------------------------
$webClient = [System.Net.WebClient]::new is not eqal to -> $webClient2 = New-Object System.Net.WebClient  (this one is better0

$lazyList = New-Object System.Collections.ArrayList
$lazyList.Add("a")
$lazyList.Add("c")
$lazyList.Add("b")
$lazyList #returns a c b

$lazyList.Sort()
$lazyList #returns a b c

$lazyList.Reverse()
$lazyList #returns c b a

$lazyList.Remove("a")
$lazyList #returns c b

--------
$xmlContent = [xml] $content

--------



 




