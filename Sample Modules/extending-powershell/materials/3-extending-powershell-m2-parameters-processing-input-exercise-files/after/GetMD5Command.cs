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
  [Cmdlet(VerbsCommon.Get, "MD5")]
  public class GetMD5Command : PSCmdlet
  {
    [Parameter(Position = 1)]
    [Alias("p")]
    public string Path { get; set; }
    
    #region Switch
    [Parameter]
    public SwitchParameter RawHash { get; set; }
    #endregion

    protected override void ProcessRecord()
    {
      #region Standard
      //using (var md5 = MD5.Create())
      //{
      //  using (var stream = File.OpenRead(Path))
      //  {
      //    var md5sum = md5.ComputeHash(stream);
      //    WriteObject(BitConverter.ToString(md5sum).Replace("-", ""));
      //  }
      //}
      #endregion

      #region Resolve path
      //ProviderInfo providerInfo = null;
      //var files = GetResolvedProviderPathFromPSPath(Path, out providerInfo);

      //using (var md5 = MD5.Create())
      //{
      //  using (var stream = File.OpenRead(files[0]))
      //  {
      //    var md5sum = md5.ComputeHash(stream);
      //    WriteObject(BitConverter.ToString(md5sum).Replace("-", ""));
      //  }
      //}
      #endregion

      #region Switch
      ProviderInfo providerInfo = null;
      var files = GetResolvedProviderPathFromPSPath(Path, out providerInfo);

      using (var md5 = MD5.Create())
      {
        using (var stream = File.OpenRead(files[0]))
        {
          var md5sum = md5.ComputeHash(stream);
          if (RawHash.IsPresent)
          {
            WriteObject(md5sum);
          }
          else
          {
            WriteObject(BitConverter.ToString(md5sum).Replace("-", ""));
          }
        }
      }
      #endregion
    }
  }
}
