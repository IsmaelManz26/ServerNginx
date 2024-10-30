#!/bin/bash

#Instrucciones archivo hosts 
#Cambio el archivo hosts en la ruta : C:\Windows\System32\drivers\etc
#agrego la ip de la maquina virtual y el nombre del dominio 192.168.56.10 ismael

# 1. Actualizar repositorios, instalar Nginx, instalar git para traer el repositorio
apt update
apt install -y nginx git

# Verificar que Nginx esté funcionando
sudo systemctl status nginx

# 2. Crear la carpeta del sitio web
sudo mkdir -p /var/www/ismael/html

# Clonar el repositorio de ejemplo en la carpeta del sitio web
git clone https://github.com/cloudacademy/static-website-example /var/www/ismael/html

# Asignar permisos adecuados
sudo chown -R www-data:www-data /var/www/ismael/html
sudo chmod -R 755 /var/www/ismael

# 3. Configurar Nginx para servir el sitio web
# Crear archivo de configuración del sitio en sites-available
sudo bash -c 'cat > /etc/nginx/sites-available/ismael <<EOF
server {
    listen 80;
    listen [::]:80;
    root /var/www/ismael/html;
    index index.html index.htm index.nginx-debian.html;
    server_name ismael;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF'

# Crear enlace simbólico en sites-enabled
sudo ln -s /etc/nginx/sites-available/ismael /etc/nginx/sites-enabled/

# Reiniciar Nginx para aplicar los cambios
sudo systemctl restart nginx

#Ej 4 Instalar vsftpd para el servidor FTP
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y vsftpd

#creamos la carpeta donde se alojaran los archivos
mkdir /home/vagrant/ftp
#Permisos carpeta
sudo chown vagrant:vagrant /home/vagrant/ftp
sudo chmod 755 /home/vagrant/ftp
# Verificar si el certificado ya existe
if [ ! -f /etc/ssl/certs/vsftpd.crt ]; then
    # Crear el certificado SSL
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt -subj "/C=ES/ST=Granada/L=Granada/O=IESZaidinVergeles/CN=192.168.56.10"
fi


