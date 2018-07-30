Configuration ChicagoCore {

Node CHI-CORE01 {
    WindowsFeature Backup {
     Name = "Windows-Server-Backup"
     Ensure = "Present"
    }
    File Work {
     Type = "Directory"
     Ensure = "Present"
     DestinationPath = "C:\Work"
    } 
    Service RemoteRegistry {
      Name = "RemoteRegistry"
      StartupType = "Automatic"
      State = "Running"
    }
} #node

} #configuration