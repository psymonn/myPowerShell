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
  [Cmdlet(VerbsCommon.Get, "Hash2")]
  public class GetHash2Command : PSCmdlet
  {
    [Parameter(ValueFromPipelineByPropertyName = true)]
    public string FullName { get; set; }

    [Parameter(Position = 1)]
    public string Path { get; set; }

    [Parameter]
    public OperationType HashType { get; set; }

    protected override void ProcessRecord()
    {
      if (String.IsNullOrEmpty(FullName))
      {
        ProviderInfo providerInfo = null;
        FullName = GetResolvedProviderPathFromPSPath(Path, out providerInfo).FirstOrDefault();
      }

      if (!File.Exists(FullName))
      {
        return;
      }

      byte[] sum;

      switch (HashType)
      {
        default:
        case OperationType.MD5:
          using (var md5 = MD5.Create())
          {
            using (var stream = File.OpenRead(FullName))
            {
              sum = md5.ComputeHash(stream);
            }
          }
          break;
        case OperationType.SHA1:
          using (var sha1 = SHA1.Create())
          {
            using (var stream = File.OpenRead(FullName))
            {
              sum = sha1.ComputeHash(stream);
            }
          }
          break;
      }

      WriteObject(new { Path = FullName, HashType = HashType.ToString(), Sum = BitConverter.ToString(sum).Replace("-", "") });
    }
  }
}
