How to reference .NET assemblies using PowerShell:

namespace MyMathLib
{
    public class Methods
    {
        public Methods()
        {
        }

        public static int Sum(int a, int b)
        {
            return a + b;
        }

        public int Product(int a, int b)
        {
            return a * b;
        }
    }
}


Compile and run in PowerShell:

> [Reflection.Assembly]::LoadFile("c:\temp\MyMathLib.dll")
> [MyMathLib.Methods]::Sum(10, 2)

> $mathInstance = new-object MyMathLib.Methods
> $mathInstance.Product(10, 2)


With PowerShell 2.0, you can use the built in Cmdlet Add-Type:

C:\PS>$source = @"
    public class BasicTest
    {
        public static int Add(int a, int b)
        {
            return (a + b);
        }

        public int Multiply(int a, int b)
        {
            return (a * b);
        }
    }
    "@

    C:\PS> Add-Type -TypeDefinition $source

    C:\PS> [BasicTest]::Add(4, 3)

    C:\PS> $basicTestObject = New-Object BasicTest 
    C:\PS> $basicTestObject.Multiply(5, 2)
	
---------------------
Get-AThing | Filter-TheThing | Write-ToAFile C:\path\to\file\name.ext

[System.IO.File]::WriteAllText('C:\path\to\file\name.ext', [System.Linq.Enumerable]::Select([Thing]::EnumerateThings(),{param([thing]$in) $in -eq $someCriteria}))
	