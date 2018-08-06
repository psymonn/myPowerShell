//  Say-Hello Cmdlet – stored as Say-Hello.cs
using System.Management.Automation;
[Cmdlet("Say", "Hello")]
public class HelloWorldCmdlet : PSCmdlet
{
  [Parameter]
  public string P1; string helloworld = "Hello World";
  protected override void ProcessRecord() 
  {
    if (P1 != null) 
       {
         WriteObject("You said: " + P1);
         WriteObject(helloworld);
       }
    else WriteObject(helloworld);
   }
} 
