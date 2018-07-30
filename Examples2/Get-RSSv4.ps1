#requires -version 4.0

Function Get-RSSFeed {

Param (
[Parameter(Position=0,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
[ValidateNotNullOrEmpty()]
[ValidatePattern("^http(s)?:\/\/")]
[Alias('url')]
[string[]]$Path="http://jdhitsolutions.com/blog/feed"
)

Begin {
    Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"  
} #begin

Process {
    foreach ($item in $path) {
        $data = Invoke-RestMethod -Uri $item
        foreach ($entry in $data) {
            #link might be different names
            if ($entry.origLink) {
              $link = $entry.origLink
            }
            elseif ($entry.link) {
              $link = $entry.link
            }
            else {
              $link = "unknown"
            }
            #clean up description
            #hash table of HTML codes
            #http://www.ascii.cl/htmlcodes.htm
            $decode=@{
                '<(.|\n)+?>'= ""
                '&#8217;' = "'"
                '&#8220;' = '"'
                '&#8221;' = '"'
                '&#187;' = "..."
                '&#8211;' = "--"
                '&#8230;' = "..."
                'â€“' = "@"
                '&#160;' = " "
                }
        
            #description could be an XML element or a simple string
            if ($entry.description -is [System.Xml.XmlElement]) {
                $description = $entry.description.innertext
            }
            else {
                $description = $entry.description
            }        
            
            foreach ($key in $decode.keys) {
                [regex]$rgx=$key
                $description = $rgx.Replace($description,$decode.Item($key)).Trim()
               }
            
            #create a custom object
            [pscustomobject][ordered]@{
                Title = $entry.title
                Author = $entry.creator.innertext
                Description = $description
                Published = $entry.pubDate -as [datetime]
                Category = $entry.category.'#cdata-section'
                Link = $Link

            } #hash

        } #foreach entry
    } #foreach item

} #process

End {
    Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
} #end

} #end Get-RSS

<#
$a = Get-RSSFeed https://www.petri.com/feed
$b = Get-RSSFeed http://www.planetpowershell.com/feed
$c = get-rssfeed
#>
