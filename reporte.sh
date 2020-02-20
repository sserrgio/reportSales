#!/bin/bash
#Llamada al script ./reporte.sh ip usuario userdb clavedb basededatos

host=$1
user=$2
pw=$3
db=$4

fecha=`date -d yesterday +%Y-%m-%d`

sql="select count(*) from vicidial_list where list_id='1999' and entry_date like '$fecha%';"

sql2="select count(*) from vicidial_list where list_id='1999' 
	and modify_date like '$fecha%' and ( status='SDFP' or status='SDPD' or status='SDPP' or status='SPFP' 
	or status='SPPD' or status='SPPP' );"	

sql3="select count(*) from vicidial_list where list_id='1999' 
	and modify_date like '$fecha%' and ( status='AC' or status='AD' or status='CALLBK' or status='DNC' 
	or status='HU' or status='NI' or status='SALE' or status='WSUO' or status='WN' );"	

mysql --host=$host -u $user -p$pw -D$db -e "$sql" > /tmp/leads_day.log
mysql --host=$host -u $user -p$pw -D$db -e "$sql2" > /tmp/leads_sales.log
mysql --host=$host -u $user -p$pw -D$db -e "$sql3" > /tmp/leads_contacts.log


leads_day=`cat /tmp/leads_day.log | sed -n '2 p'`
leads_sales=`cat /tmp/leads_sales.log | sed -n '2 p'`
leads_contacts=`cat /tmp/leads_contacts.log | sed -n '2 p'`

let leads_vs_sales2=$leads_sales*100/$leads_day
leads_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_day" | bc )
contacts_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_contacts" | bc )


echo "Cantidad de leads ingresados el dia $fecha = $leads_day"
echo "Cantidad de Venta en el dia $fecha = $leads_sales"
echo "Cantidad de Contactos en el dia $fecha = $leads_contacts"
echo "Leads ingresados por dia VS Sales = $leads_vs_sales"
echo "Leads Contacts VS Sales = $contacts_vs_sales"

echo "borrando temporales..."
rm /tmp/leads_day.log
rm /tmp/leads_sales.log
rm /tmp/leads_contacts.log
