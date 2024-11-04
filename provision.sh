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

# Agregamos el usuario ismael
sudo adduser ismael
# Establecemos la contraseña del usuario ismael
echo "ismael:ismael" | sudo chpasswd

#creamos la carpeta donde se alojaran los archivos
sudo mkdir /home/ismael/ftp
#Permisos carpeta
sudo chown vagrant:vagrant /home/ismael/ftp
sudo chmod 755 /home/ismael/ftp
# Verificar si el certificado ya existe
if [ ! -f /etc/ssl/certs/vsftpd.crt ]; then
     # Crear el certificado SSL
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt -subj "/C=ES/ST=Granada/L=Granada/O=IESZaidinVergeles/CN=192.168.56.10"
fi

cp /vagrant/vsftpd.conf /etc/vsftpd.conf

# Agrego el usuario ismael al grupo www-data
sudo usermod -aG www-data ismael

#creo la carpeta nueva para el sitio web nuevo
sudo mkdir -p  /var/www/ismaelpersonal
# damos permisos a esa carpeta
sudo chown -R www-data:www-data /var/www/ismaelpersonal
sudo chmod -R 775 /var/www/ismaelpersonal

# Reiniciar el servicio vsftpd
sudo systemctl restart vsftpd
sudo systemctl status vsftpd

# Clonar el repositorio en la carpeta
sudo git clone https://github.com/IsmaelManz26/MxIsmaelManzano.git /var/www/ismaelpersonal

# Copiar el archivo de sites avaliable del nuevo dominio
cp /vagrant/ismaelpersonal /etc/nginx/sites-available/ismaelpersonal

# Creamos el enlace simbolico
sudo ln -s /etc/nginx/sites-available/ismaelpersonal /etc/nginx/sites-enabled/
# Reinicar y recargar nginx
sudo systemctl restart nginx
sudo systemctl reload nginx