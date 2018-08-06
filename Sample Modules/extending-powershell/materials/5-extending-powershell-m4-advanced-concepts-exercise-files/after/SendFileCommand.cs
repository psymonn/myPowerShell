using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Collections.ObjectModel;
using System.Data;

namespace PowerShellCourse
{
  [Cmdlet(VerbsCommunications.Send, "File", SupportsShouldProcess = true)]
  public class SendFileCommand : PSCmdlet
  {
    private ProgressRecord record;

    [Parameter(Position = 1, ValueFromPipeline = true)]
    public FileSystemInfo File { get; set; }

    [Parameter]
    public SwitchParameter Log { get; set; }

    [Parameter]
    public SwitchParameter PassThru { get; set; }

    [Parameter]
    public SwitchParameter Force { get; set; }

    private bool yesToAll;
    private bool noToAll;

    protected override void ProcessRecord()
    {
      if ((File.Attributes & FileAttributes.Directory) == FileAttributes.Directory)
      {
        return;
      }

      FileInfo fileInternal = new FileInfo(Path.Combine(SessionState.Path.CurrentFileSystemLocation.Path, File.Name));

      if (ShouldProcess(fileInternal.FullName, "File upload"))
      {
        // do something
        if (Force.IsPresent || ShouldContinue("Uploading file \"" + fileInternal.FullName + "\" to \"Somewhere\"", "Confirm", ref yesToAll, ref noToAll))
        {
          string bar = GetProgressBar(0);
          record = new ProgressRecord(1, "Sending " + fileInternal.Name, bar);

          int segments = (int)fileInternal.Length / 10000 + 1;
          double tick = (100d / (double)segments);

          DateTime start = DateTime.Now;

          for (int i = 0; i < segments; i++)
          {
            // get file segment
            // upload it somewhere
            bar = GetProgressBar((int)((i + 1) * tick));
            record.StatusDescription = bar;
            WriteProgress(record);
          }

          if (Log.IsPresent)
          {
            Collection<SendFileLogItem> logItems = SessionState.PSVariable.GetValue("log", new Collection<SendFileLogItem>()) as Collection<SendFileLogItem>;
            logItems.Add(new SendFileLogItem() { File = fileInternal, Segments = segments, Time = DateTime.Now - start });
            SessionState.PSVariable.Set("log", logItems);
          }
        }
      }

      if (PassThru.IsPresent)
      {
        WriteObject(File);
      }
    }

    private string GetProgressBar(int progress)
    {
      int barWidth = Host.UI.RawUI.WindowSize.Width - 15;
      string filledPart = new string('o', (int)((double)barWidth / 100d * progress));
      string emptyPart = new string(' ', barWidth - filledPart.Length);
      return String.Format("[{0}{1}] {2}%", filledPart, emptyPart, progress);
    }

    public class SendFileLogItem
    {
      public FileInfo File { get; set; }
      public int Segments { get; set; }
      public TimeSpan Time { get; set; }
    }
  }
}
