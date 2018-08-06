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
  [Cmdlet(VerbsCommon.Get, "Hash3", DefaultParameterSetName = "calculate")]
  public class GetHash3Command : PSCmdlet
  {
    [Parameter(ValueFromPipelineByPropertyName = true, ParameterSetName = "calculate")]
    public string FullName { get; set; }

    [Parameter(Position = 1)]
    public string Path { get; set; }

    [Parameter(Position = 2, Mandatory = true, ParameterSetName = "compare")]
    public string TargetPath { get; set; }

    [Parameter]
    public OperationType HashType { get; set; }

    protected override void ProcessRecord()
    {
      ProviderInfo providerInfo = null;
      if (String.IsNullOrEmpty(FullName))
      {
        FullName = GetResolvedProviderPathFromPSPath(Path, out providerInfo).FirstOrDefault();
      }

      if (!File.Exists(FullName))
      {
        return;
      }
      if (ParameterSetName == "calculate")
      {
        var sum = GetSum(FullName);
        WriteObject(new { Path = FullName, HashType = HashType.ToString(), Sum = BitConverter.ToString(sum).Replace("-", "") });
      }
      if (ParameterSetName == "compare")
      {
        string targetFullName = GetResolvedProviderPathFromPSPath(TargetPath, out providerInfo).FirstOrDefault();
        if (!File.Exists(targetFullName))
        {
          return;
        }
        var sum = GetSum(FullName);
        var targetSum = GetSum(targetFullName);
        var result = BitConverter.ToString(sum).Replace("-", "").Equals(BitConverter.ToString(targetSum).Replace("-", ""));
        WriteObject(result);
      }
    }

    private byte[] GetSum(string filePath)
    {
      byte[] sum = null;
      switch (HashType)
      {
        default:
        case OperationType.MD5:
          using (var md5 = MD5.Create())
          {
            using (var stream = File.OpenRead(filePath))
            {
              sum = md5.ComputeHash(stream);
            }
          }
          break;
        case OperationType.SHA1:
          using (var sha1 = SHA1.Create())
          {
            using (var stream = File.OpenRead(filePath))
            {
              sum = sha1.ComputeHash(stream);
            }
          }
          break;
      }
      return sum;
    }
  }
}
