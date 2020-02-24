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
IP="192.168.70.13"
PW="internalreports"
NAME_OD="OnlineDivorce-report-Sales"
CID_OD="ODIVORCE"
MAIL_OD="mgonzalez@telecomnetworks.net"
STATUS_OD_S="'SU','SDFP','SDPD','SDPP','SPFP','SPPD','SPPP'"	
STATUS_OD_C="'AC','AD','CALLBK','DNC','HU','NI','SALE','WSUO','WN','INT','AR'"
INTERVAL_OD="5"

/bin/bash "/var/opt/cron/vicibox/reportSales.sh" "$IP" "$PW" "$CID_OD" "$MAIL_OD" "$STATUS_OD_S" "$STATUS_OD_C" "$NAME_OD" "$FECHAI" "$FECHAF" "$INTERVAL_OD"
#/bin/bash "/home/mgonzalez/Documents/Telecom/git/reportSales/reportSales.sh" "$IP" "$PW" "$CID_OD" "$MAIL_OD" "$STATUS_OD_S" "$STATUS_OD_C" "$NAME_OD" "$FECHAI" "$FECHAF" "$INTERVAL_OD"

