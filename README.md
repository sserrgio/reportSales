# Report Sales
Reporte que muestra estadisticas de ventas con respecto a los leads o contactos ingresados por dia.

##Parametros
1. IP / Host donde esta la basde de datos
2. Password del usuario de la base de datos
3. ID de la Campaña
4. Mails donde se enviara el reporte
5. Status de Venta
6. Status de Contactos
7. Nombre del reporte
8. Fecha inicio
9. Fecha fin

Opcional
10. Intervalo de horas en entry_date 

##Modo de uso
1. Setear parametros en reportSalesDaily.sh
Ejemplo:
`/bin/bash "/home/mgonzalez/Documents/reportSales/reportSales.sh" "192.168.1.245" "asd123" "Sales" "$MAIL" "StatusS" "StatusC" "$NAME" "$FECHAI" "$FECHAF"`
2. Ejecutar el script en el cron.
`30	5	*	*	*	/bin/bash /path/reportSalesDaily.sh >> /dev/null`
