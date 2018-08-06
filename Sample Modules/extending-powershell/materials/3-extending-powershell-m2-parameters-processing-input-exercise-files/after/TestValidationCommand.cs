using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace PowerShellCourse
{
  [Cmdlet(VerbsDiagnostic.Test, "Validation")]
  public class TestValidationCommand : PSCmdlet
  {
    [Parameter(Position = 1, ValueFromPipeline = true)]
    [ValidateFileLength2(MaxLength = 20000)]
    public string Path { get; set; }

    public static TestValidationCommand Current { get; set; }

    public TestValidationCommand()
    {
      Current = this;
    }

    protected override void ProcessRecord()
    {
    }
  }

  public class ValidateFileLength : ValidateArgumentsAttribute
  {
    public int MaxLength { get; set; }

    protected override void Validate(object arguments, EngineIntrinsics engineIntrinsics)
    {
      FileInfo file = new FileInfo((string)arguments);
      if (file.Exists)
      {
        if (file.Length > MaxLength)
        {
          throw new ValidationMetadataException("File is too long");
        }
      }
    }
  }


  public class ValidateFileLength2 : ValidateArgumentsAttribute
  {
    public int MaxLength { get; set; }

    protected override void Validate(object arguments, EngineIntrinsics engineIntrinsics)
    {
      ProviderInfo providerInfo = null;
      var path = TestValidationCommand.Current.GetResolvedProviderPathFromPSPath((string)arguments, out providerInfo).FirstOrDefault();
      FileInfo file = new FileInfo(path);
      if (file.Exists)
      {
        if (file.Length > MaxLength)
        {
          throw new ValidationMetadataException("File is too long");
        }
      }
    }
  }
}
