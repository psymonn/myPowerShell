#demonstrate string fun

$s = "powershell rocks!"
$s | Get-Member
$s.Length
$s.ToUpper()
#there is also a toLower() method
#doesn't change $s
$s

$s | get-member substring
$s.Substring.OverloadDefinitions
$s.Substring(5)
$s.Substring(1,4)
#this is case-sensitive
$s.IndexOf("s")
$s.LastIndexOf("s")

cls
#this is case-sensitive
$s.Replace("e","3")
#make multiple changes at once
$name = $s.Replace("p","P").Replace("s","S")
$name

cls
$t = 'a,b,c,d,e,f,g'
$t
$t -is [array]
$split = $t.Split(",")
$split 
$split -is [array]
cls

#make a password
$alpha = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
$num = 0..9
$char = '!,),@,(,*,/,$,&,^,%,[,],>,<'
$arr = @()
$arr+= $alpha.split(',') | Get-Random -count 5
#make the first and last elements upper case
$arr[0] = $arr[0].toupper()
$arr[-1] = $arr[-1].toupper()
#$num is already an array
$arr += $num | Get-Random -count 2
#get 3 random characters
$arr += $char.split(',') | Get-Random -count 3
#randomize the array and join as a string 
($arr | Get-Random -Count $arr.count) -join ""

cls