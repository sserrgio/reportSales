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
IP="192.168.1.250"
PW="secret"
NAME="Example-report-Sales"
CID="EXAMPLE"
MAIL="example@example.com"
STATUS_S="'SU','SDFP','SDPD','SDPP','SPFP','SPPD','SPPP'"	
STATUS_C="'AC','AD','CALLBK','DNC','HU','NI','SALE','WSUO','WN','INT','AR'"
INTERVAL="5"

/bin/bash "/path/reportSales.sh" "$IP" "$PW" "$CID" "$MAIL" "$STATUS_S" "$STATUS_C" "$NAME" "$FECHAI" "$FECHAF" "$INTERVAL"
#/bin/bash "/home/mgonzalez/Documents/reportSales/reportSales.sh" "$IP" "$PW" "$CID" "$MAIL" "$STATUS_S" "$STATUS_C" "$NAME" "$FECHAI" "$FECHAF" "$INTERVAL"
