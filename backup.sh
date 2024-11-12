#!/bin/bash

local="ondeDesejaSalvarBackup"
database="seuDatabase"
data=$(date +"%d%m%Y_%H%M")
finalFile="$database$data.sql"
scpUser="seuUsuarioRemoto"
scpServer="seuHost"
scpPath="seuCaminho"
scpPwd="suaSenha"
scpCmd="$finalFile  $scpUser@$scpPath"

# dump do mysql
mysqldump -u "$user" -p"$pwd" "$database" > "$finalFile"

# verifica se deu certo
if [ $? -eq 0 ]; then
    echo "Backup realizado com sucesso em $finalFile"
    
    #manda para host remoto
    sshpass -p "$scpPwd" scp "$finalFile" "$scpUser@$scpServer":"scpPath"
    
    # Verifica se o SCP foi bem-sucedido
    if [ $? -eq 0 ]; then
       echo "Backup enviado com sucesso!"
    else
       echo "Erro ao enviar backup!"
    fi
    
    #só apaga se conseguir fazer o backup
    DIA="15"
    if [ $(find "$local"*.sql -mtime +$DIA) ];then
	echo "ENCONTRADO ARQUIVOS COM MAIS DE $DIA DIAS. APAGANDO, AGUARDE!"
        find "$local"*.sql -mtime +"$DIA" -exec rm {} \;
    else 
     echo "Não encontrado arquivos com mais de $DIA dias!" 
    fi
	    
else
    echo "Erro ao gerar o backup do banco de dados."
fi


