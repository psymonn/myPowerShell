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
  [Cmdlet(VerbsCommon.Get, "Hash")]
  public class GetHashCommand : PSCmdlet
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

      WriteObject(new { Path = Path, HashType = HashType, Sum = BitConverter.ToString(sum).Replace("-", "") });
    }
  }

  public enum OperationType
  {
    MD5,
    SHA1
  }
}
