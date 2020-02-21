#!/bin/bash
#Llamada al script ./reporte.sh ip clavedb campaign

host=$1
pw=$2
campaign=$3
statusSales=$4
statusContacts=$5

echo "#######################################################";
echo "############# Report Sales by Campaign ################";
echo "############# Creado por Mauro Gonzalez ###############";
echo "############ Fecha Creacion: 20/02/2020 ###############";
echo "#### https://github.com/mauro25987/reportSales.git ####";
echo "#######################################################";
echo "Campaign: $campaign";
echo "Host: $host";

fechaI=`date -d yesterday +%Y-%m-%d`
fechaF=`date +%Y-%m-%d`

#necesitmaos ajustar la fecha de entry_date por que actualmente los leads que se ingresan por la api quedan con GMT-0 y el resto de los datos del server estan en GMT-5
#por ahora solo aplicaria a onlinedivorce
sql1_func(){
	sql1="select count(*) from vicidial_list where list_id='$list' and entry_date >= date_add('$fechaI',interval 5 hour) and 
		entry_date < date_add('$fechaF',interval 5 hour);"
	}
sql2_func(){
	sql2="select count(*) from vicidial_list where list_id='$list' 
		and modify_date >= '$fechaI' and modify_date < '$fechaF' and status in ( 'SDFP','SDPD','SDPP','SPFP','SPPD','SPPP' );"	
	}
sql3_func(){
	sql3="select count(*) from vicidial_list where list_id='$list' and ( modify_date >= '$fechaI%' and modify_date < '$fechaF' 
		and status in ( 'AC','AD','CALLBK','DNC','HU','NI','SALE','WSUO','WN','INT','AR' ));"	
	}

sql4="select list_id from vicidial_lists where campaign_id='$campaign' and active='Y';"

campaign_lists=$( mysql --host=$host -u internalreports -p$pw -Dasterisk -e "$sql4" ) 
#IFS="\n" read -a list <<< $campaign_lists

for i in "${campaign_lists[@]}"; do lists+=($i); done
unset lists[0] 

leads_day=0
leads_sales=0
leads_contacts=0

#if [ ${#lists[@]} -gt 1 ]; then
	for i in ${lists[@]}
       	do
		echo "lista $i"
		list=$i
		sql1_func
		sql2_func
		sql3_func
		mysql --host=$host -u internalreports -p$pw -Dasterisk -e "$sql1" > /tmp/leads_day.log
		mysql --host=$host -u internalreports -p$pw -Dasterisk -e "$sql2" > /tmp/leads_sales.log
		mysql --host=$host -u internalreports -p$pw -Dasterisk -e "$sql3" > /tmp/leads_contacts.log
		
		day=`cat /tmp/leads_day.log | sed -n '2 p'`
		sales=`cat /tmp/leads_sales.log | sed -n '2 p'`
		contacts=`cat /tmp/leads_contacts.log | sed -n '2 p'`

		let leads_day=$leads_day+$day
		let leads_sales=$leads_sales+$sales
		let leads_contacts=$leads_contacts+$contacts
	done

<<'multi'
else
		list=${lists[1]}
		echo "lista $list"
		sql1_func
		sql2_func
		sql3_func
		mysql --host=$host -u internalreports -p$pw -Dasterisk -e "$sql1" > /tmp/leads_day.log
		mysql --host=$host -u internalreports -p$pw -Dasterisk -e "$sql2" > /tmp/leads_sales.log
		mysql --host=$host -u internalreports -p$pw -Dasterisk -e "$sql3" > /tmp/leads_contacts.log

		leads_day=`cat /tmp/leads_day.log | sed -n '2 p'`
		leads_sales=`cat /tmp/leads_sales.log | sed -n '2 p'`
		leads_contacts=`cat /tmp/leads_contacts.log | sed -n '2 p'`
fi
multi

if [ $leads_day -gt 0 ]; then 	
	leads_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_day" | bc )
	contacts_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_contacts" | bc )
else
	leads_vs_sales="No se agrearon leads"
	contacts_vs_sales="No se agregaron leads"
fi

echo "Report Date: $fechaI -- $fechaF"
echo "Leads received = $leads_day"
echo "Sales = $leads_sales"
echo "Contacts $fechaI = $leads_contacts"
echo "Leads vs Sales(%) = $leads_vs_sales"
echo "Contacts vs Sales(%) = $contacts_vs_sales"

echo "borrando temporales..."
rm /tmp/leads_day.log
rm /tmp/leads_sales.log
rm /tmp/leads_contacts.log
