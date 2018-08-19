# Demo 3-9
# Checkpointing of workflows

Workflow chkpt-wf {

Get-Process

foreach ($x in 1..100)
   {$x; checkpoint-workflow; Start-Sleep -Seconds 2}
}

chkpt-wf -asjob

Get-Job | Receive-Job -Keep
