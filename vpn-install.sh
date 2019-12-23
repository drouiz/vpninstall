#############################################################################################
#           INSTALACION
#############################################################################################

#apt update
#apt install openvpn
#wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.3/EasyRSA-3.0.3.zip
#apt install -y unzip
#unzip EasyRSA-3.0.3.zip
#EL ARCHIVO VARS EL MIO
#ENTRAMOS DENTRO LA CARPETA DE EASY

#############################################################################################
#           GENERACION DE CERTIFICADOS SERVIDOR
#############################################################################################

server_name=drouiz

./EasyRSA-3.0.3/easyrsa init-pki #crea los certificados en pki
./EasyRSA-3.0.3/easyrsa build-ca nopass #entidad certificadora, quitar el nopass para poner password
./EasyRSA-3.0.3/easyrsa gen-req server-openvpn-$server_name nopass #certificado de servidor
./EasyRSA-3.0.3/easyrsa sign-req server server-openvpn-$server_name #firma del certificado
#./EasyRSA-3.0.3/easyrsa gen-dh

#ORGANIZANDO LOS ARCHIVOS

mkdir cas
mkdir cas/server
cp pki/ca.crt cas/server
cp pki/issued/server-openvpn-$server_name.crt cas/server
cp pki/reqs/server-openvpn-$server_name.req cas/server
cp pki/private/server-openvpn-$server_name.key cas/server
cp pki/dh.pem cas/server
openvpn --genkey --secret ta.key

#############################################################################################
#           GENERACION DE CERTIFICADOS CLIENTES
#############################################################################################

client_name=latpBoream

# CERTIFICADOS DE CLIENTES, SE PUEDEN PONER CONTRASEÑAS DEBEMOSC REAR UNO POR CERTIFICADO
# TODO CREAR VARIABLE PARA GENERAR CERTIFICADOS DE CLIENTES


./EasyRSA-3.0.3/easyrsa gen-req client-openvpn-$client_name  nopass #CREAR CERTIFICADO CLIENTE
./EasyRSA-3.0.3/easyrsa sign-req client client-openvpn-$client_name  #FIRMAR CERTIFICADO DE CLIENTE


# ARCHIVOS DE CLIENTE
mkdir cas/client
mkdir cas/client/$client_name
cp pki/ca.crt cas/client/$client_name
cp pki/issued/client-openvpn-$client_name.crt cas/client/$client_name
cp pki/reqs/client-openvpn-$client_name.req cas/client/$client_name
cp pki/private/client-openvpn-$client_name.key cas/client/$client_name
cp cas/server/dh.pem cas/client/$client_name

# Crear los parámetros Diffie-Hellmann
#./EasyRSA-3.0.3/easyrsa gen-dh

#https://www.redeszone.net/redes/openvpn/