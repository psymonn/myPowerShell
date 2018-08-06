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
  [Cmdlet(VerbsCommon.Get, "SnowReportFeed2")]
  [OutputType(typeof(XElement))]
  public class GetSnowReportFeedCommand2 : PSCmdlet
  {
    [Parameter(Position = 1, ValueFromPipeline = true)]
    public string Country { get; set; }

    protected override void ProcessRecord()
    {
      XDocument feed = GetFeed();
      if (feed == null)
      {
        WriteWarning("Feed can't be downloaded");
        return;
      }
      var items = feed.Descendants("item");
      WriteObject(items, true);
    }

    private XDocument GetFeed()
    {
      WriteVerbose("Starting feed download");
      XDocument feed = null;
      string feedUrl = string.Format("http://www.onthesnow.co.uk/" + Country + "/snow-rss.html");
      WriteDebug("feedUrl=" + feedUrl);
      try
      {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(feedUrl);
        using (var response = request.GetResponse())
        {
          using (var stream = response.GetResponseStream())
          {
            using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
            {
              WriteDebug("response received");
              string content = reader.ReadToEnd();
              feed = XDocument.Parse(content);
            }
          }
        }
      }
      catch
      {
      }
      WriteVerbose("Feed download completed");
      return feed;
    }
  }
}
