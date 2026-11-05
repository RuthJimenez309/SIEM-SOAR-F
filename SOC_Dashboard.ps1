@(
function Show-SOCDashboard {
    $TriagePath = "SIEM_Triage_Actions.log"
    if (-not (Test-Path $TriagePath)) {
        Write-Host "No hay datos de triaje aun." -ForegroundColor Yellow
        return
    }
    $Events = Get-Content $TriagePath | ForEach-Object { $_ | ConvertFrom-Json }
    $Total = $Events.Count
    $Escalated = ($Events | Where-Object { $_.Status -eq "ESCALATED_TO_SOAR_N2" }).Count
    $Monitored = ($Events | Where-Object { $_.Status -eq "TRIAGED_L1_MONITORED" }).Count
    
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "         SOC N1 PERFORMANCE & COMPLIANCE DASHBOARD" -ForegroundColor Cyan
    Write-Host "         MARCO NORMATIVO: ISO 27001 / CIS CONTROLS" -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "Total Incidentes Procesados : $Total" -ForegroundColor White
    Write-Host "Escalados a SOAR N2         : $Escalated" -ForegroundColor Red
    Write-Host "Monitoreados L1 (Estables)  : $Monitored" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "         DESGLOSE POR TIPO DE VECTOR CAPTURADO    " -ForegroundColor Yellow
    Write-Host "==================================================" -ForegroundColor Cyan
    
    $Events | Group-Object Attack | ForEach-Object {
        $Control = switch($_.Name) {
            "Brute_Force_EntraID"      { "CIS 5.1 / ISO A.9.2" }
            "Data_Exfiltration_WAN"    { "CIS 3.10 / ISO A.12.6" }
            "Firewall_Rule_Disabled"   { "CIS 4.4 / ISO A.13.1" }
            "BitLocker_Key_Export"     { "CIS 3.11 / ISO A.10.1" }
            "M365_Privilege_Escalation" { "CIS 5.4 / ISO A.9.4" }
            Default                    { "CIS 17 / ISO A.16.1" }
        }
        Write-Host "-> Vector: $($_.Name.PadRight(26)) Cantidad: $($_.Count.ToString().PadRight(4)) [$Control]" -ForegroundColor Gray
    }
    Write-Host "==================================================" -ForegroundColor Cyan
}
Show-SOCDashboard
)
