# Demo 3-9a
# Checkpointing of workflows

#  See what is there
Get-Job

#  See results
Get-Job | Receive-Job -Keep

#  Resume job
Get-job | Resume-Job

# Suspend the job
Get-Job |Suspend-Job