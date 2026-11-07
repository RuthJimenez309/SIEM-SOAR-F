# SIEM-SOAR Continuous Monitoring & Triage Engine

Sistema automatizado de simulación, triaje y auditoría de cumplimiento en base a marcos normativos internacionales.

## Inventario del Sistema 
* **SecOps_Simulator.ps1**: Motor de estrés y simulación de ataques a endpoints e identidad.
* **SIEM_Triage_Engine.ps1**: Analizador asíncrono y clasificador de criticidad bajo NIST SP 800-61.
* **SOC_Dashboard.ps1**: Consola interactiva de visualización de mátricas de rendimiento y cobertura CIS/ISO 27001.
* **exclusions.json**: Directivas de filtrado para falsos positivos y ruido en el SOC.

- Módulo de Ataques Ampliado: Incorporación de simulación de vectores de inyección web (Cross-Site Scripting - XSS) mapeados bajo el control normativo CIS Control 16.
