#!/bin/bash
#Llamada al script ./reporte.sh ip usuario userdb clavedb basededatos campaign

host=$1
user=$2
pw=$3
db=$4
campaign=$5

fechaI=`date -d yesterday +%Y-%m-%d`
fechaF=`date +%Y-%m-%d`

sql1_func(){
	sql1="select count(*) from vicidial_list where list_id='$list' and entry_date >= date_add('$fechaI',interval 5 hour) and 
		entry_date < date_add('$fechaF',interval 5 hour);"
	}
sql2_func(){
	sql2="select count(*) from vicidial_list where list_id='$list' 
		and modify_date >= '$fechaI' and modify_date < '$fechaF' and ( status='SDFP' or status='SDPD' or status='SDPP' or status='SPFP' 
		or status='SPPD' or status='SPPP' );"	
	}
sql3_func(){
	sql3="select count(*) from vicidial_list where list_id='$list' and ( modify_date >= '$fechaI%' and modify_date < '$fechaF' 
		and status IN ( 'AC','AD','CALLBK','DNC','HU','NI','SALE','WSUO','WN','INT','AR' ));"	
	}

sql4="select list_id from vicidial_lists where campaign_id='$campaign' and active='Y';"

campaign_lists=$( mysql --host=$host -u $user -p$pw -D$db -e "$sql4" ) 
#IFS="\n" read -a list <<< $campaign_lists

for i in "${campaign_lists[@]}"; do lists+=($i); done
unset lists[0] 

if [ ${#lists[@]} -gt 1 ]; then
	for i in ${lists[@]}
       	do
		echo "lista $i"
		sql1_func
		sql2_func
		sql3_func
		mysql --host=$host -u $user -p$pw -D$db -e "$sql1" > /tmp/leads_day.log
		mysql --host=$host -u $user -p$pw -D$db -e "$sql2" > /tmp/leads_sales.log
		mysql --host=$host -u $user -p$pw -D$db -e "$sql3" > /tmp/leads_contacts.log

		leads_day=`cat /tmp/leads_day.log | sed -n '2 p'`
		leads_sales=`cat /tmp/leads_sales.log | sed -n '2 p'`
		leads_contacts=`cat /tmp/leads_contacts.log | sed -n '2 p'`
		
		if [ $leads_day -gt 0 ]; then 	
			leads_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_day" | bc )
			contacts_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_contacts" | bc )
		else
			leads_vs_sales="No se agrearon leads"
			contacts_vs_sales="No se agregaron leads"
		fi
		echo "Cantidad de leads ingresados el dia $fechaI = $leads_day"
		echo "Cantidad de Venta en el dia $fechaI = $leads_sales"
		echo "Cantidad de Contactos en el dia $fechaI = $leads_contacts"
		echo "Leads ingresados por dia VS Sales = $leads_vs_sales"
		echo "Leads Contacts VS Sales = $contacts_vs_sales"
	done
else
		list=${lists[1]}
		echo "lista $list"
		sql1_func
		sql2_func
		sql3_func
		mysql --host=$host -u $user -p$pw -D$db -e "$sql1" > /tmp/leads_day.log
		mysql --host=$host -u $user -p$pw -D$db -e "$sql2" > /tmp/leads_sales.log
		mysql --host=$host -u $user -p$pw -D$db -e "$sql3" > /tmp/leads_contacts.log

		leads_day=`cat /tmp/leads_day.log | sed -n '2 p'`
		leads_sales=`cat /tmp/leads_sales.log | sed -n '2 p'`
		leads_contacts=`cat /tmp/leads_contacts.log | sed -n '2 p'`
		
		if [ $leads_day -gt 0 ]; then 	
			leads_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_day" | bc )
			contacts_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_contacts" | bc )
		else
			leads_vs_sales="No se agrearon leads"
			contacts_vs_sales="No se agregaron leads"
		fi
		echo "Cantidad de leads ingresados el dia $fechaI = $leads_day"
		echo "Cantidad de Venta en el dia $fechaI = $leads_sales"
		echo "Cantidad de Contactos en el dia $fechaI = $leads_contacts"
		echo "Leads ingresados por dia VS Sales = $leads_vs_sales"
		echo "Leads Contacts VS Sales = $contacts_vs_sales"
fi

echo "borrando temporales..."
rm /tmp/leads_day.log
rm /tmp/leads_sales.log
rm /tmp/leads_contacts.log
