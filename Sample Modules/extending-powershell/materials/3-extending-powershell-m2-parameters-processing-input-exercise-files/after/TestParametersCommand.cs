using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace PowerShellCourse
{
  [Cmdlet(VerbsDiagnostic.Test, "Parameters")]
  public class TestParametersCommand : PSCmdlet
  {
    [Parameter(ValueFromPipelineByPropertyName = true)]
    public string FullName { get; set; }

    [Parameter(Position = 1, ValueFromPipeline = true)]
    public FileInfo File { get; set; }

    [Parameter(ValueFromPipeline = true)]
    public DirectoryInfo Folder { get; set; }

    protected override void ProcessRecord()
    {
      WriteObject(new { Folder = Folder, File = File, FullPath = FullName });
    }
  }
}
