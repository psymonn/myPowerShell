class Person {
    [string]$CN
    [string]$Description
    [string]$DisplayName

    [void]Describe([string]$Description){
        $this.Description = $Description
    }
}

class User : Person{
    [string]$Name
    [int]$Mailbox
    
    [void]AddUser([string]$Name,[int]$Mailbox) {
        $This.Name = $Name
        $This.Mailbox = $Mailbox
        $Date = Get-Date
        $This.Describe("User created on $($Date)")
        }
    }

class Computer : User{
    [string]$OperatingSystem
    
    [void]AddUser([string]$Name,[int]$OperatingSystem){
        $This.Name = $Name
        $This.OperatingSystem = $OperatingSystem
        $date = get-date
        $This.Describe("Computer created on $($Date)")
        }
    }


