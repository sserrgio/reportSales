# Report Sales
Reporte que muestra estadisticas de ventas con respecto a los leads o contactos ingresados por dia.

## Parametros
1. $IP - IP / Host donde esta la basde de datos
2. $PW - Password del usuario de la base de datos
3. $CID - ID de la Campaña
4. $MAIL - Mails donde se enviara el reporte
5. $STATUS_S - Status de Venta
6. $STATUS_C - Status de Contactos
7. $NAME - Nombre del reporte
8. $FECHAI - Fecha inicio
9. $FECHAF - Fecha fin

Opcional
10. $INTERVAL - Intervalo de horas en entry_date 

## Modo de uso
1. Setear parametros en reportSalesDaily.sh
Ejemplo:

`/bin/bash "/path/reportSales.sh" "$IP" "$PW" "$CID" "$MAIL" "$STATUS_S" "$STATUS_C" "$NAME" "$FECHAI" "$FECHAF" "$INTERVAL"`

2. Ejecutar el script en el cron.

`30	5	*	*	*	/bin/bash /path/reportSalesDaily.sh >> /dev/null`
