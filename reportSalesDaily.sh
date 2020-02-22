#!/bin/bash
<<'parametros'
Usage Parametros
1-ip
2-pw user db
3-id campaña
4-mails 
5-statuses sales
6-statuses contacts
7-nombre del reporte
8-fecha inicio
9-fecha fin
10-intervalo de horas - OPCIONAL
parametros

FECHAF=`date +%Y-%m-%d`
FECHAI=`date +%Y-%m-%d -d "$FECHAF -1 day"`
MAIL_OD="mgonzalez@telecomnetworks.net"
STATUS_OD_S="'SDFP','SDPD','SDPP','SPFP','SPPD','SPPP'"	
STATUS_OD_C="'AC','AD','CALLBK','DNC','HU','NI','SALE','WSUO','WN','INT','AR'"	

/bin/bash "/var/opt/cron/vicibox/reportSales.sh" "192.168.70.13" "internalreports" "ODIVORCE" "$MAIL_OD" "$STATUS_OD_S" "$STATUS_OD_C" "OnlineDivorce-report-Sales" "$FECHAI" "$FECHAF" "5"
#/bin/bash "/home/mgonzalez/Documents/Telecom/git/reportSales/reportSales.sh" "192.168.70.13" "internalreports" "ODIVORCE" "$MAIL_OD" "$STATUS_OD_S" "$STATUS_OD_C" "OnlineDivorce-report-Sales" "$FECHAI" "$FECHAF" "5"
