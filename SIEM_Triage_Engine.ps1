@(
function Start-SIEMTriageEngine {
    $LogPath = "SIEM_Stream.log"
    $TriagePath = "SIEM_Triage_Actions.log"
    if (-not (Test-Path $LogPath)) { New-Item -ItemType File $LogPath -Force | Out-Null }
    
    Get-Content $LogPath -Tail 0 -Wait | ForEach-Object {
        $RawEvent = $_
        try {
            $SecurityEvent = $RawEvent | ConvertFrom-Json
            $Action = if ($SecurityEvent.Severity -eq "CRITICAL") { "ESCALATED_TO_SOAR_N2" } else { "TRIAGED_L1_MONITORED" }
            
            $TriageEntry = @{
                Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff")
                OriginalID = $SecurityEvent.EventID
                Attack = $SecurityEvent.Attack
                Target = $SecurityEvent.Target
                Status = $Action
                Framework = if ($SecurityEvent.Attack -eq "Web_XSS_Injection") { "NIST_Application_Security_CIS_Control_16" } else { "NIST_SP_800-61_CIS_Control_17" }
            }
            $TriageEntry | ConvertTo-Json -Compress | Out-File -FilePath $TriagePath -Append -Encoding utf8
        } catch {}
    }
}
Start-SIEMTriageEngine
)
