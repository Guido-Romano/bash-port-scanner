# Monitoreo de Contraseñas en Linux

Un script en Bash para monitorear cambios en archivos críticos de contraseñas en sistemas Linux, utilizando sumas de verificación SHA-256 para detectar modificaciones.

## Características
- Monitorea los archivos `/etc/passwd`, `/etc/shadow`, `/etc/group` y `/etc/gshadow`.
- Calcula sumas de verificación SHA-256 y las compara con registros anteriores.
- Notifica cuando se detectan cambios en los archivos monitoreados.

## Requisitos
- Sistema operativo basado en Linux.
- Acceso a comandos `sha256sum`, `awk` y `mkdir`.

## Instalación y Uso
### 1. Clonar el repositorio
```bash
git clone https://github.com/Guido-Romano/password_audit
cd password_audit.sh
```

### 2. Configurar permisos y ejecutar el script
```bash
chmod +x password_audit.sh
sudo ./password_audit.sh
```

## Cómo funciona
1. El script crea un directorio para almacenar las sumas de verificación de los archivos monitoreados.
2. Si las sumas de verificación previamente guardadas no coinciden con las actuales, se muestra una alerta.
3. Se puede ejecutar periódicamente mediante un **cron job** para monitoreo constante.

### Ejemplo de configuración con `cron`
```bash
crontab -e
```
Añadir la siguiente línea para verificar cambios cada hora:
```bash
0 * * * * /RUTA/password_audit.sh
```

## Licencia
Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo LICENSE para más detalles.

## Agradecimientos
Inspirado en técnicas de seguridad para monitoreo de archivos críticos en Linux.
