using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace PowerShellCourse
{
  [Cmdlet(VerbsDiagnostic.Test, "Error")]
  public class TestErrorCommand : PSCmdlet
  {
    [Parameter(Position = 1, ValueFromPipeline = true)]
    public FileInfo File { get; set; }

    protected override void ProcessRecord()
    {
      if (File.Length > 20000)
      {
        ErrorRecord error = new ErrorRecord(new Exception("File too big"), "FileTooBig", ErrorCategory.LimitsExceeded, File);
        error.ErrorDetails = new ErrorDetails("Only files smaller than 20KB are supported.");
        WriteError(error);
      }
      else
      {
        WriteObject(File.Name);
      }
    }
  }
}
