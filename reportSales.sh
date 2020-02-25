#!/bin/bash
host=$1
pw=$2
campaign=$3
mails=$4
statusSales=$5
statusContacts=$6
name=$7
fechaI=$8
fechaF=$9
interval=${10}

echo "#######################################################"
echo "############# Report Sales by Campaign ################"
echo "############# Creado por Mauro Gonzalez ###############"
echo "############ Fecha Creacion: 20/02/2020 ###############"
echo "#### https://github.com/mauro25987/reportSales.git ####"
echo "#######################################################"
echo "Campaign: $campaign"
echo "Host: $host"

#necesitmaos ajustar la fecha de entry_date por que actualmente los leads que se ingresan por la api quedan con GMT-0 y el resto de los datos del server estan en GMT-5

sql1_func(){
	if [ -z $interval ]; then
		sql1="select count(*) from vicidial_list where list_id='$list' and entry_date >= '$fechaI' 
			and entry_date < '$fechaF';"
	else

		sql1="select count(*) from vicidial_list where list_id='$list' and entry_date >= date_add('$fechaI',interval $interval hour) and 
			entry_date < date_add('$fechaF',interval $interval hour);"
	fi
	}

sql2_func(){
	sql2="select count(*) from vicidial_list where list_id='$list' 
		and modify_date >= '$fechaI' and modify_date < '$fechaF' and status in ( $statusSales );"	
	}

sql3_func(){
	sql3="select count(*) from vicidial_list where list_id='$list' and ( modify_date >= '$fechaI%' and modify_date < '$fechaF' 
		and status in ( $statusContacts ));"	
	}

sql4="select list_id from vicidial_lists where campaign_id='$campaign' and active='Y';"
sql5="select campaign_name from vicidial_campaigns where campaign_id='$campaign';"

campaign_lists=$( mysql --host=$host -u internalreports -p$pw -Dasterisk -Ns -e "$sql4" ) 
for i in "${campaign_lists[@]}"; do lists+=($i); done

leads_day=0
leads_sales=0
leads_contacts=0

for i in ${lists[@]}; do
	echo "lista $i"
	list=$i
	
	sql1_func
	sql2_func
	sql3_func
	
	day=$(mysql --host=$host -u internalreports -p$pw -Dasterisk -Ns -e "$sql1")
	sales=$(mysql --host=$host -u internalreports -p$pw -Dasterisk -Ns -e "$sql2")
	contacts=$(mysql --host=$host -u internalreports -p$pw -Dasterisk -Ns -e "$sql3")

	let leads_day=$leads_day+$day
	let leads_sales=$leads_sales+$sales
	let leads_contacts=$leads_contacts+$contacts
done

campaign_name=$(mysql --host=$host -u internalreports -p$pw -Dasterisk -Ns -e "$sql5")

if [ $leads_day -gt 0 ]; then
	leads_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_day" | bc | sed 's/^\./0./' )
else
	leads_vs_sales="Not leads today"
fi

if [ $leads_contacts -gt 0 ]; then
	contacts_vs_sales=$( echo "scale=2; $leads_sales*100/$leads_contacts" | bc | sed 's/^\./0./' )
else
	contacts_vs_sales="Not contacts today"
fi

echo "<html><head></head><body>
<img src="https://i.imgur.com/RwcasoT.png" alt="logo TN"><br/>
<b>Proyect:</b> $campaign_name<br/>
<b>Report Date:</b> $fechaI -- $fechaF<br/>
<b>Leads received =</b> $leads_day<br/>
<b>Sales =</b> $leads_sales<br/>
<b>Contacts $fechaI =</b> $leads_contacts<br/>
<b>Leads vs Sales(%) =</b> $leads_vs_sales<br/>
<b>Contacts vs Sales(%) =</b> $contacts_vs_sales<br/><br/><br/>
This is an automatic report, please don't reply this email.
</body></html>" > /tmp/$name.html  

mutt -e "set content_type=text/html" "$mails" -F "/var/opt/cron/vicibox/muttreporting" -s "$name $fechaI" < /tmp/$name.html

echo "borrando temporales..."
rm /tmp/$name.html
