#!/bin/bash

# Archivos de contraseñas a monitorear
FILES="/etc/passwd /etc/shadow /etc/group /etc/gshadow"

# Directorio para almacenar las sumas de verificación (checksums)
CHECKSUM_DIR="/var/log/file_integrity"

# Asegurar que el directorio de checksums exista
mkdir -p "$CHECKSUM_DIR"

# Función para calcular y almacenar checksums
generate_checksums() {
    for file in $FILES; do
        if [ -f "$file" ]; then
            checksum=$(sha256sum "$file" | awk '{print $1}')
            echo "$checksum" > "$CHECKSUM_DIR/$(basename $file).sha256"
        fi
    done
}

# Función para verificar cambios
check_changes() {
    for file in $FILES; do
        if [ -f "$file" ]; then
            checksum=$(sha256sum "$file" | awk '{print $1}')
            stored_checksum=$(cat "$CHECKSUM_DIR/$(basename $file).sha256" 2>/dev/null)

            if [ -n "$stored_checksum" ] && [ "$checksum" != "$stored_checksum" ]; then
                echo -e "\e[31mCambio detectado en $file a las $(date).\e[0m"
            fi
        fi
    done
}

# Generar checksums iniciales (si no existen)
for file in $FILES; do
    if [ -f "$file" ] && [ ! -f "$CHECKSUM_DIR/$(basename $file).sha256" ]; then
        checksum=$(sha256sum "$file" | awk '{print $1}')
        echo "$checksum" > "$CHECKSUM_DIR/$(basename $file).sha256"
    fi
done

# Verificar cambios
check_changes
