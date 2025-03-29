#!/bin/bash

# Validación de entradas
if [ "$#" -ne 3 ]; then
    echo -e "\e[31mUso: $0 <IP> <PuertoInicio> <PuertoFin>\e[0m"
    exit 1
fi

# Variables de entrada
IP=$1
PORT_START=$2
PORT_END=$3

# Validar que los puertos sean números
if ! [[ $PORT_START =~ ^[0-9]+$ && $PORT_END =~ ^[0-9]+$ ]]; then
    echo -e "\e[31mError: Los puertos deben ser números.\e[0m"
    exit 1
fi

# Validar que el rango de puertos sea lógico
if [ "$PORT_START" -gt "$PORT_END" ]; then
    echo -e "\e[31mError: PuertoInicio debe ser menor o igual a PuertoFin.\e[0m"
    exit 1
fi

echo -e "\e[34mEscaneando puertos abiertos en $IP del $PORT_START al $PORT_END...\e[0m"
echo "--------------------------------------------------"

# Escaneo de puertos
RESULTS=""
for PORT in $(seq $PORT_START $PORT_END); do
    # Intentar conectarse al puerto usando netcat con un timeout
    timeout 1 bash -c "echo > /dev/tcp/$IP/$PORT" 2>/dev/null && {
        echo -e "\e[32mPuerto $PORT está abierto.\e[0m"
        RESULTS="$RESULTS$PORT "
    } &
done

# Esperar a que todos los procesos terminen
wait

echo "--------------------------------------------------"
if [ -z "$RESULTS" ]; then
    echo -e "\e