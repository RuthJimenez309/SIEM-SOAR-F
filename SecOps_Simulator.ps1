@(
function Out-SecOpsAttackSimulator {
    [CmdletBinding()]
    param(
        [int]$EventCount = 50,
        [int]$IntervalMS = 100
    )
    $Attacks = @("Brute_Force_EntraID", "Data_Exfiltration_WAN", "Firewall_Rule_Disabled", "BitLocker_Key_Export", "M365_Privilege_Escalation", "Web_XSS_Injection")
    $Targets = @("192.168.1.50", "10.0.0.12", "usr_admin01", "usr_exec04", "WIN-EDR-PROD09")
    
    for ($i = 0; $i -lt $EventCount; $i++) {
        $Attack = $Attacks[(Get-Random -Maximum $Attacks.Count)]
        $Target = $Targets[(Get-Random -Maximum $Targets.Count)]
        $Severity = if ($Attack -match "Exfiltration|Escalation") { "CRITICAL" } else { "HIGH" }
        
        $Payload = @{
            Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff")
            EventID   = (Get-Random -Minimum 1000 -Maximum 9999)
            Attack    = $Attack
            Target    = $Target
            Severity  = $Severity
            Source    = "Simulated_Stress_Engine"
        }
        $Payload | ConvertTo-Json -Compress | Out-File -FilePath "SIEM_Stream.log" -Append -Encoding utf8
        Start-Sleep -Milliseconds $IntervalMS
    }
}
Out-SecOpsAttackSimulator -EventCount 100 -IntervalMS 50
)
