@echo off
echo ### Geracao de certificado ###
echo ##############################
set /p days=Digite a validade em dias para o certificado: 
set /p CN=Digite o Common Name (dominio): 
mkdir %CN%
IF EXIST "%CN%\%CN%.crt" (
  echo Arquivo de certificado %CN%\%CN%.crt ja existe & pause & exit
)

echo [req] > %CN%\%CN%.csr.conf
echo default_bits = 2048 >> %CN%\%CN%.csr.conf
echo prompt = no >> %CN%\%CN%.csr.conf
echo default_md = sha256 >> %CN%\%CN%.csr.conf
echo distinguished_name = dn >> %CN%\%CN%.csr.conf
echo [dn] >> %CN%\%CN%.csr.conf
echo C=BR >> %CN%\%CN%.csr.conf
echo ST=PB >> %CN%\%CN%.csr.conf
echo L=JP >> %CN%\%CN%.csr.conf
echo O=%CN% >> %CN%\%CN%.csr.conf
echo OU=%CN% >> %CN%\%CN%.csr.conf
echo emailAddress=admin@%CN% >> %CN%\%CN%.csr.conf
echo CN = %CN% >> %CN%\%CN%.csr.conf

IF NOT EXIST "x509.conf" (
echo authorityKeyIdentifier=keyid,issuer > x509.conf
echo basicConstraints=CA:FALSE >> x509.conf
echo keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment >> x509.conf
echo subjectAltName = @alt_names >> x509.conf
echo [alt_names] >> x509.conf
echo DNS.1 = %CN%>> x509.conf
echo DNS.2 = outro.teste.com>> x509.conf
)

echo ================================
echo Faca os ajustes no arquivo x509.conf para configurar Alt Names.
echo Pressione enter quando estiver pronto para emitir o certificado.
echo Sera necessario usar a senha da chave privada CA Root criada anteriormente.
pause
openssl req -new -sha256 -nodes -out %CN%\%CN%.csr -newkey rsa:2048 -keyout %CN%\%CN%.key -config %CN%\%CN%.csr.conf
openssl x509 -req -in %CN%\%CN%.csr -CA ca_root.crt -CAkey ca_root.key -CAcreateserial -out %CN%\%CN%.crt -days %days% -sha256 -extfile x509.conf
del %CN%\%CN%.csr.conf
del %CN%\%CN%.csr
echo ================================
echo Certificado gerado: %CN%\%CN%.crt, %CN%\%CN%.key
echo Para utilizar internamente, certifique de que o ca_root.crt esteja adicionado como autoridade de certificacao raiz confiavel.
pause
