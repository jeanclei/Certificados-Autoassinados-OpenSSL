@echo off

IF EXIST "ca_root.crt" (
  echo Arquivo ca_root.crt ja existe & pause & exit
) 


echo ### Gerando certificado autoassinado CA Root ###
echo ################################################
set /p dias_ca=Digite a validade em dias para o certificado CA Root: 
echo ===============================
echo # Agora, voce precisa escolher uma senha para a chave privada que sera criada, no minimo 4 caracteres:


echo [req] > ca_root.conf
echo default_bits = 2048 >> ca_root.conf
echo prompt = no >> ca_root.conf
echo default_md = sha256 >> ca_root.conf
echo distinguished_name = dn >> ca_root.conf
echo [dn] >> ca_root.conf
echo C=BR >> ca_root.conf
echo ST=PB >> ca_root.conf
echo L=JP >> ca_root.conf
echo O=root-autoassinado >> ca_root.conf
echo OU=root-autoassinado >> ca_root.conf
echo emailAddress=admin@root-autoassinado.org >> ca_root.conf
echo CN = root-autoassinado >> ca_root.conf

openssl genrsa -des3 -out ca_root.key 2048
echo ===============================
echo # Chave privada gerada. Agora digite a senha para assinar o certificado:
openssl req -x509 -new -nodes -key ca_root.key -sha256 -days %dias_ca% -out ca_root.crt -config ca_root.conf
del ca_root.conf
echo ===============================
echo Certificado gerado, verifique o arquivo ca_root.crt
echo ===============================
pause
