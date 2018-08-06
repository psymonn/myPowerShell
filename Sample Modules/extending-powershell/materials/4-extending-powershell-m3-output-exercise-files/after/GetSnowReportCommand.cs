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
  [Cmdlet(VerbsCommon.Get, "SnowReport")]
  public class GetSnowReportCommand : PSCmdlet
  {
    [Parameter(Position = 1, ValueFromPipeline = true)]
    public string Country { get; set; }

    protected override void ProcessRecord()
    {
      XDocument feed = GetFeed();
      if (feed == null)
      {
        return;
      }
      var items = feed.Descendants("item");
      foreach (var item in items)
      {
        var report = SnowReport.Create(item);
        WriteObject(report);
      }
    }

    private XDocument GetFeed()
    {
      XDocument feed = null;
      HttpWebRequest request = (HttpWebRequest)WebRequest.Create(string.Format("http://www.onthesnow.co.uk/" + Country + "/snow-rss.html"));
      using (var response = request.GetResponse())
      {
        using (var stream = response.GetResponseStream())
        {
          using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
          {
            string content = reader.ReadToEnd();
            feed = XDocument.Parse(content);
          }
        }
      }
      return feed;
    }
  }
}