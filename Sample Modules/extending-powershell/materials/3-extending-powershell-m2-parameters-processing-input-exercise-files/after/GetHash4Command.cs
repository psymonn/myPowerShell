using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace PowerShellCourse
{
  [Cmdlet(VerbsCommon.Get, "Hash4")]
  public class GetHash4Command : PSCmdlet, IDynamicParameters
  {
    [Parameter(Position = 1, ValueFromPipeline = true)]
    public string Path { get; set; }

    [Parameter]
    public OperationType HashType { get; set; }

    protected override void ProcessRecord()
    {
      byte[] sum;

      switch (HashType)
      {
        default:
        case OperationType.MD5:
          using (var md5 = MD5.Create())
          {
            using (var stream = File.OpenRead(Path))
            {
              sum = md5.ComputeHash(stream);
            }
          }
          break;
        case OperationType.SHA1:
          using (var sha1 = SHA1.Create())
          {
            using (var stream = File.OpenRead(Path))
            {
              sum = sha1.ComputeHash(stream);
            }
          }
          break;
      }

      if (dynamicParameters != null && dynamicParameters.RawHash.IsPresent)
      {
        WriteObject(new { Path = Path, HashType = HashType, Sum = sum });
      }
      else
      {
        WriteObject(new { Path = Path, HashType = HashType, Sum = BitConverter.ToString(sum).Replace("-", "") });
      }
    }

    GetHash4CommandDynamicParameters dynamicParameters;

    public object GetDynamicParameters()
    {
      if (HashType == OperationType.SHA1)
      {
        dynamicParameters = new GetHash4CommandDynamicParameters();
        return dynamicParameters;
      }
      return null;
    }
  }

  public class GetHash4CommandDynamicParameters
  {
    [Parameter]
    public SwitchParameter RawHash { get; set; }
  }
}
