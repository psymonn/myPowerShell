
get-eventlog -LogName System -Newest 100 | Group-Object -Property source -NoElement |
Sort-Object -Property count,Name -Descending