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
  public class SnowReport
  {
    public string Country { get; set; }
    public string Resort { get; set; }
    public bool IsOpen { get; set; }
    public int SnowDepth { get; set; }
    public int ExpectedSnow { get; set; }

    public static SnowReport Create(XElement item)
    {
      SnowReport report = new SnowReport();
      report.Resort = item.Element("title").Value;
      report.Country = item.Element("{http://www.onthesnow.co.uk/ots_rss_namespace/}region_name").Value;
      report.IsOpen = item.Element("{http://www.onthesnow.co.uk/ots_rss_namespace/}open_staus").Value == "Open";
      int depth = 0;
      int.TryParse(item.Element("{http://www.onthesnow.co.uk/ots_rss_namespace/}base_depth").Value, out depth);
      report.SnowDepth = depth;
      depth = 0;
      int.TryParse(item.Element("{http://www.onthesnow.co.uk/ots_rss_namespace/}snowfall_48hr").Value, out depth);
      report.ExpectedSnow = depth;
      return report;
    }
  }
}
