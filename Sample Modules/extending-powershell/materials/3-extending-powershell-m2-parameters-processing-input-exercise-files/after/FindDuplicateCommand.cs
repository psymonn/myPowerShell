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
  [Cmdlet(VerbsCommon.Find, "Duplicate")]
  public class FindDuplicateCommand : PSCmdlet
  {
    [Parameter(Position = 1, Mandatory = true)]
    public string Path { get; set; }

    [Parameter(Position = 2, Mandatory = true)]
    public string MD5Pattern { get; set; }

    protected override void ProcessRecord()
    {
      WildcardPattern wildcard = new WildcardPattern(MD5Pattern, WildcardOptions.IgnoreCase);

      ProviderInfo providerInfo = null;
      var folder = GetResolvedProviderPathFromPSPath(Path, out providerInfo).FirstOrDefault();

      foreach (var filePath in Directory.GetFiles(folder))
      {
        using (var md5 = MD5.Create())
        {
          
          using (var stream = File.OpenRead(filePath))
          {
            var md5sum = md5.ComputeHash(stream);
            var calculatedMD5 = BitConverter.ToString(md5sum).Replace("-", "");
            if (wildcard.IsMatch(calculatedMD5))
            {
              WriteObject(new { File = filePath, MD5 = calculatedMD5 });
            }
          }
        }
      }
    }
  }
}
