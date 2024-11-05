# Proyecto de Configuración de Servidor Web y FTP en Debian

Este proyecto detalla la configuración de un servidor web Nginx y un servidor FTP seguro (FTPS) en una máquina virtual Debian. A continuación se describen los pasos para la instalación, configuración y comprobación de ambos servicios.

## Tabla de Contenido

1. [Instalación del Servidor Web Nginx](#instalación-del-servidor-web-nginx)
2. [Creación de la Carpeta del Sitio Web](#creación-de-la-carpeta-del-sitio-web)
3. [Configuración del Servidor Web NGINX](#configuración-del-servidor-web-nginx)
   - [Comprobaciones](#comprobaciones)
4. [Configuración de FTPS en Debian](#configuración-de-ftps-en-debian)
5. [Tarea](#tarea)
6. [Cuestiones Finales](#cuestiones-finales)

## 1. Instalación del Servidor Web Nginx

Para instalar el servidor Nginx en Debian, actualizamos los repositorios e instalamos el paquete:

```bash
sudo apt update
sudo apt install nginx
```

Luego, comprobamos que Nginx se ha instalado y está funcionando correctamente:

```bash
systemctl status nginx
```

## 2. Creación de la Carpeta del Sitio Web

Creamos la carpeta para nuestro sitio web en `/var/www/` y definimos los permisos correspondientes.

```bash
sudo mkdir -p /var/www/nombre_web/html
```

Luego clonamos un repositorio de ejemplo en esta carpeta:

```bash
cd /var/www/nombre_web/html
git clone https://github.com/cloudacademy/static-website-example .
```

Asignamos los permisos adecuados:

```bash
sudo chown -R www-data:www-data /var/www/nombre_web/html
sudo chmod -R 755 /var/www/nombre_web
```

## 3. Configuración del Servidor Web NGINX

Creamos un bloque de servidor en el archivo de configuración en `/etc/nginx/sites-available`:

```bash
sudo nano /etc/nginx/sites-available/nombre_web
```

Contenido de ejemplo para el archivo de configuración:

```
server {
    listen 80;
    listen [::]:80;
    root /var/www/nombre_web/html;
    index index.html index.htm index.nginx-debian.html;
    server_name nombre_web;
    location / {
        try_files $uri $uri/ =404;
    }
}
```

### Enlace simbólico y reinicio del servidor

```bash
sudo ln -s /etc/nginx/sites-available/nombre_web /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

### Comprobaciones

- **Archivo /etc/hosts**: Añadimos la IP y el nombre del dominio.
- **Registros de Nginx**: Consultamos los logs en `/var/log/nginx/access.log` y `/var/log/nginx/error.log`.

## 4. Configuración de FTPS en Debian

Instalación y configuración de `vsftpd` para un servidor FTPS seguro.

1. Instalamos el servidor:
   ```bash
   sudo apt-get install vsftpd
   ```
2. Configuramos el certificado SSL para FTPS:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt
   ```
3. Editamos la configuración en `/etc/vsftpd.conf` para habilitar FTPS:

   ```bash
   sudo nano /etc/vsftpd.conf
   ```

   Reemplazamos o añadimos las siguientes líneas:

   ```
   rsa_cert_file=/etc/ssl/certs/vsftpd.crt
   rsa_private_key_file=/etc/ssl/private/vsftpd.key
   ssl_enable=YES
   allow_anon_ssl=NO
   force_local_data_ssl=YES
   force_local_logins_ssl=YES
   ssl_tlsv1=YES
   ssl_sslv2=NO
   ssl_sslv3=NO
   require_ssl_reuse=NO
   ssl_ciphers=HIGH
   local_root=/home/nombre_usuario/ftp
   ```

4. Reiniciamos el servicio:
   ```bash
   sudo systemctl restart vsftpd
   ```

## 5. Tarea

Configura un segundo dominio y transfiere los archivos mediante FTPS. Recuerda dar permisos adecuados y repetir el proceso de configuración en Nginx para el segundo sitio.
![Dominio Nuevo](./Capturas/prueba2web.png)

## 6. Cuestiones Finales

1. **¿Qué pasa si no hago el enlace simbólico?**

   - El sitio no será accesible ya que Nginx no cargará la configuración del sitio.

2. **¿Qué ocurre si no doy permisos adecuados a la carpeta de mi sitio web?**
   - Se pueden presentar errores de acceso no autorizado al intentar cargar el sitio.

## Conclusión

Este proyecto demuestra la instalación y configuración de un servidor Nginx y FTPS en Debian, además de la gestión de múltiples dominios en el mismo servidor.
