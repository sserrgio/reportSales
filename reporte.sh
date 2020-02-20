#!/bin/sh

campania=$1;

fecha=`date -d yesterday +%Y-%m-%d`


sql="select count(*) from vicidial_list where list_id='1999' and entry_date like '$fecha%';"

sql2="select count(*) from vicidial_list where list_id='1999' 
	and modify_date like '$fecha%' and ( status='SDFP' or status='SDPD' or status='SDPP' or status='SPFP' 
	or status='SPPD' or status='SPPP' );"	

sql2="select count(*) from vicidial_list where list_id='1999' 
	and modify_date like '$fecha%' and ( status='' or status='' or status='' or status='' 
	or status='SPPD' or status='SPPP' );"	


mysql --host=192.168.70.13 -u internalreports -pinternalreports -Dasterisk -e "$sql" > /tmp/leads_day.log;
mysql --host=192.168.70.13 -u internalreports -pinternalreports -Dasterisk -e "$sql2" > /tmp/leads_sales.log;


leads_day=`cat /tmp/leads_day.log | sed -n '2 p';`
leads_sales=`cat /tmp/leads_sales.log | sed -n '2 p';`
echo "Cantidad de leads ingresados el dia $fecha = $leads_day";
echo "Cantidad de Venta en el dia $fecha = $leads_sales";

echo "borrando temporales...";
rm /tmp/leads_day.log;
rm /tmp/leads_sales.log;

