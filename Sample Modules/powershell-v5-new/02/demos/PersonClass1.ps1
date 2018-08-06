class Person {
    [string]$CN
    [string]$Description
    [datetime]$WhenCreated

    [void]Describe([string]$Description){
        $this.Description = $Description
    }

    person([string]$CN) {
        $this.cn = $CN
    }

    person([string]$CN,[string]$Description,[datetime]$whenCreated) {
        $this.CN = $CN
        $This.Description = $Description
        $This.WhenCreated = $whenCreated
    }
}
