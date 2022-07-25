#!/bin/sh    
#author: rdurlo #Nova8

#Variavies utilizadas para todos os projetos que nao precisam ser variaveis de ambiente.
cx_server='https://natura.checkmarx.net'
cliScriptPath=$PWD'/cx-cli/runCxConsole.sh'
resolverScriptPath=$PWD'/resolver'
cxFlowBase="java -jar cx-flow.jar"

#Secrets
cx_user='nova8.adm'
cx_password='|Bc=~}uZQ5qm'
cx_scaUsername='nova8.adm'
cx_scaPassword='|Bc=~}uZQ5qm'
cx_scaAccount='natura'

#env.vars
cx_scaLocationfolder='C:\Users\RafaelaDurlo\Desktop\code\MedicalAppointment'
cx_prj_folder='C:\Users\RafaelaDurlo\Desktop\code\MedicalAppointment'
cx_buildId='12234'
cx_branch='master'
cx_Comment='Build Id: '$cx_buildId' Branch: '$cx_buildId

#cx.vars
cx_project_name="MedicalAppointment"
cx_team='CxServer/Homolog/'
cx_project_path=$cx_team$cx_project_name
cx_preset='High And Medium'
cx_LocationPathExclude='cx-cli,resolver,cxflow'
cx_SASTHigh='1000000'
cx_SASTMedium='1000000'

# Area downloads das ferramentas
DownloadCLI () {
   echo '[INFO] Download Checkmarx CLI'
   url=$(curl -s 'https://checkmarx.com/plugins/' | grep -Eo "https://download.checkmarx.com/[0-9].[0-9].[0-9]_GA/Plugins/CxConsolePlugin-[0-9].[0-9].[0-9]*.zip") 
   mkdir cx-cli
   cd $PWD/cx-cli
   curl $url -o cx-cli.zip
   unzip cx-cli.zip && rm cx-cli.zip
   IncreaseJavaHeap
}

#Usar separado
DownloadCxFlow () {
   echo '[INFO] Download CxFlow'
   version=$(curl -s -I 'https://github.com/checkmarx-ltd/cx-flow/releases/latest' | grep -Eo "(http|https)://[github.com][a-zA-Z0-9./?=_%:-]*" | grep -Eo "[0-9].[0-9].[0-9]*")
   echo 'CxFlow latest release version: '$version
   mkdir cxflow
   cd $PWD/cxflow
   curl -s 'https://github.com/checkmarx-ltd/cx-flow/releases/download/'$version'/cx-flow-'$version'.jar' -o 'cx-flow.jar'
}

DownloadResolver () {
	case $1 in
	   -Win)
		  DownloadResolverWind
		  ;;
	   -Linux)
		  DownloadResolverLinux
		  ;;
	   -LinuxAlpine)
		  DownloadResolverLinuxAlpine
		  ;;
	   -Mac)
		  DownloadResolverMac
		  ;;
	   -MacInstaller)
		  DownloadResolverMacInstaller
		  ;;	  
	   *)
		 echo "[Erro] Para o resolver é necessário informar o S.O"
		 echo "        Ex.: Checkmarx.sh -ScaResolver -Win (Windows)"
		 echo "        Ex.: Checkmarx.sh -ScaResolver -Linux (Linux)"
		 echo "        Ex.: Checkmarx.sh -ScaResolver -LinuxAlpine (Linux alpine)"
		 echo "        Ex.: Checkmarx.sh -ScaResolver -Mac (Mac)"
		 echo "        Ex.: Checkmarx.sh -ScaResolver -MacInstaller (Mac installer)"
		 ;;
	esac
}

DownloadResolverWind () {
   echo '[INFO] Download Sca resolver Windows'
   url=$(curl -s 'https://checkmarx.atlassian.net/wiki/spaces/CD/pages/1976140391/Checkmarx+SCA+Resolver+Download+and+Installation' | grep -Eou "https://sca-downloads.s3.amazonaws.com/cli/[0-9].[0-9].[0-9]*/ScaResolver-win64.zip" |sort -u)
   mkdir resolver
   cd $PWD/resolver
   curl $url -o ScaResolver-win64.zip
   unzip ScaResolver-win64.zip && rm ScaResolver-win64.zip
}

DownloadResolverLinux () {
   echo '[INFO] Download Sca resolver Linux'
   url=$(curl -s 'https://checkmarx.atlassian.net/wiki/spaces/CD/pages/1976140391/Checkmarx+SCA+Resolver+Download+and+Installation' | grep -Eo "https://sca-downloads.s3.amazonaws.com/cli/[0-9].[0-9].[0-9]*/ScaResolver-linux64.tar.gz" |sort -u)
   mkdir resolver
   cd $PWD/resolver
   curl $url -o ScaResolver-linux64.tar.gz
   gunzip -c ScaResolver-linux64.tar.gz | tar xopf - && rm ScaResolver-linux64.tar.gz
}

DownloadResolverLinuxAlpine () {
   echo '[INFO] Download Sca resolver Linux Alpine'
   url=$(curl -s 'https://checkmarx.atlassian.net/wiki/spaces/CD/pages/1976140391/Checkmarx+SCA+Resolver+Download+and+Installation' | grep -Eo "https://sca-downloads.s3.amazonaws.com/cli/[0-9].[0-9].[0-9]*/ScaResolver-musl64.tar.gz" |sort -u)
   mkdir resolver
   cd $PWD/resolver
   curl $url -o ScaResolver-musl64.tar.gz
   gunzip -c ScaResolver-musl64.tar.gz | tar xopf - && rm ScaResolver-musl64.tar.gz
}

DownloadResolverMac () {
   echo '[INFO] Download Sca resolver Mac'
   url=$(curl -s 'https://checkmarx.atlassian.net/wiki/spaces/CD/pages/1976140391/Checkmarx+SCA+Resolver+Download+and+Installation' | grep -Eo "https://sca-downloads.s3.amazonaws.com/cli/[0-9].[0-9].[0-9]*/ScaResolver-macos64.tar.gz" |sort -u)
   mkdir resolver
   cd $PWD/resolver
   curl $url -o ScaResolver-macos64.tar.gz
   gunzip -c ScaResolver-macos64.tar.gz | tar xopf - && rm ScaResolver-macos64.tar.gz
}

DownloadResolverMacInstaller () {
   echo '[INFO] Download Sca resolver Mac Installer'
   url=$(curl -s 'https://checkmarx.atlassian.net/wiki/spaces/CD/pages/1976140391/Checkmarx+SCA+Resolver+Download+and+Installation' | grep -Eo "https://sca-downloads.s3.amazonaws.com/cli/[0-9].[0-9].[0-9]*/ScaResolver-macos64.pkg" |sort -u)
   mkdir resolver
   cd $PWD/resolver
   curl $url -o ScaResolver-macos64.pkg
   installer -pkg ScaResolver-macos64.pkg -target CurrentUserHomeDirectory
}

# Area funcao ScaResolver
ResolverFuncao () {
	case $1 in
	   -Online)
		  Onlinemode
		  ;;
	   -Offline)
		  Offlinemode
		  Upload
		  ;;
	   -PathExplorer)
		  PathExplorer
		  ;;	  
	   *)
		 echo "[Erro] Informe a funcao do resolver"
		 echo "        Ex.: Checkmarx.sh -ScaResolver -Online (modo online)"
		 echo "        Ex.: Checkmarx.sh -ScaResolver -Offline (modo offline com upload)"
		 echo "        Ex.: Checkmarx.sh -ScaResolver -PathExplorer (Com Path Explorer)"
		 		 ;;
	esac
}

Onlinemode () {
	echo "[INFO] SCA resolver Online Mode"
	$resolverScriptPath/ScaResolver -s "$cx_prj_folder" -n "$cx_project_name" -a "$cx_scaAccount" -u "$cx_user" -p "$cx_password"
}

Offlinemode () {
	echo "[INFO] SCA resolver offline mode"
	$resolverScriptPath/ScaResolver offline -s "$cx_prj_folder" -n "$cx_project_name" -r $PWD'\dependency.json'
}

Upload () {
	echo "[INFO] SCA resolver Online Mode"
	$resolverScriptPath/ScaResolver upload -n "$cx_project_name" -a "$cx_scaAccount" -u "$cx_user" -p "$cx_password" -r $cx_prj_folder'\dependency.json'
}

PathExplorer () {
	echo "[INFO] SCA resolver Online Mode"
	$resolverScriptPath/ScaResolver -s "$cx_prj_folder" -n "$cx_project_name" -a "$cx_scaAccount" -u "$cx_user" -p "$cx_password" --cxuser "$cx_user" --cxpassword "$cx_password" --cxprojectname "$cx_project_name" --cxserver "$cx_server"	
}

# Area funcao CxCLI
CxCliFuncao () {
	case $1 in
	   -ascode)
		  CxCliFuncaoScanType $2
		  CxCliFuncaoIncremental $3
		  CheckmarxScanConfigAsCode $retTypeScan $retIncremental
		  ;;
	   -ascodeSca)
		  CxCliFuncaoScanType $2
		  CxCliFuncaoIncremental $3
		  CheckmarxScanConfigAsCodeSCA $retTypeScan $retIncremental
		  ;;   
	   -scan)
		  CxCliFuncaoScanType $2
		  CxCliFuncaoIncremental $3
		  CheckmarxScan $retTypeScan $retIncremental
		  ;;
	   -scanSca)
		  CxCliFuncaoScanType $2
		  CxCliFuncaoIncremental $3
		  CheckmarxScanSCA $retTypeScan $retIncremental
		  ;;
	   -sca)
		  CxCliFuncaoCxCLIPathExpoitable $2 $3
		  ;;
	   *)
		 echo "[Erro] Informe qual eh a configuracao do scan"
		 echo "       Ex.: Checkmarx.sh -CxCLI -ascode (para scan com configascode sem SCA)"
		 echo "       Ex.: Checkmarx.sh -CxCLI -ascodeSca (para scan com configascode com SCA)"
		 echo ""
		 echo "       Ex.: Checkmarx.sh -CxCLI -scan (para scan sem SCA)"
		 echo "       Ex.: Checkmarx.sh -CxCLI -scanSca (para scan com SCA)"
		 echo ""
		 echo "       Ex.: Checkmarx.sh -CxCLI -sca (para scan somente de sca)"
		 exit 1
		 ;;
	esac
}

CxCliFuncaoScanType () {
	case $1 in
	   -async)
		  retTypeScan="AsyncScan"
		  ;;
	   -sync)
		  retTypeScan="Scan"
		  ;;   
	   *)
		 echo "[Erro] Informe se o scan sera sincrono/assincrono ou sera scan apenas do sca"
		 echo "       Ex.: Checkmarx.sh -CxCLI -async (para assincrono)"
		 echo "       Ex.: Checkmarx.sh -CxCLI -sync (para sincrono)"
		 exit 1
		 ;;
	esac
}

CxCliFuncaoIncremental () {
	case $1 in
	   -i)
		  retIncremental="-Incremental"
		  ;;
	   -f)
		  retIncremental=""
		  ;;   
	   *)
		 echo "[Erro] Informe se o scan sera Incremenal ou Full"
		 echo "       Ex.: Checkmarx.sh -CxCLI -async -i (para assincrono e incremental)"
		 echo "       Ex.: Checkmarx.sh -CxCLI -sync -i (para sincrono e incremental)"
		 echo "       Ex.: Checkmarx.sh -CxCLI -async -f (para sincrono e full)"
		 echo "       Ex.: Checkmarx.sh -CxCLI -sync -f (para assincrono e full)"
		 exit 1
		 ;;
	esac
}

CxCliFuncaoPolicyViolationSca () {
	case $1 in
	   -policy)
		  policy="-CheckPolicy"
		  ;;
	   -nopolicy)
		  policy=""
		  ;;   
	   *)
		 echo "[Erro] Informe se o scan tera verificacao de politica"
		 echo "       Ex.: Checkmarx.sh -CxCLI -sca -policy"
		 echo "       Ex.: Checkmarx.sh -CxCLI -sca -nopolicy"
		 exit 1
		 ;;
	esac
}

CxCliFuncaoCxCLIPathExpoitable () {
	case $1 in
	   -resolver)
			echo "[ATENCAO!] Disponível apenas para Java, JavaScript e python"
			CheckDir $PWD/resolver
			if [ $diretorio == "true" ]
			then
				CxCliFuncaoPolicyViolationSca $2
				ScaScanResolver $policy
			else
				echo "[ATENCAO] Antes de utilizar essa funcao execute (Checkmarx.sh -ScaResolver) para download do sca resolver"
				exit 1
			fi	
		  ;;
	   -noresolver)
			CxCliFuncaoPolicyViolationSca $2
			ScaScanOnly $policy
		  ;;   
	   *)
		 echo "[Erro] Informe se o scan fara expoitable path"
		 echo "       Ex.: Checkmarx.sh -CxCLI -sca -resolver"
		 echo "       Ex.: Checkmarx.sh -CxCLI -sca -noresolver"
		 exit 1
		 ;;
	esac
}

CheckmarxScanConfigAsCode () {
	cd $PWD/cx-cli
	echo "[INFO] CxSAST Scan ConfigAsCode"
	source "$cliScriptPath" $1 -v -cxServer "$cx_server" -cxuser "$cx_user" -cxpassword "$cx_password" -locationtype "folder" -LocationPath "$cx_prj_folder" -Comment "$cx_Comment" -configascode $2
}

CheckmarxScanConfigAsCodeSCA () {
	cd $PWD/cx-cli
	echo "[INFO] CxSAST/SCA Scan ConfigAsCode"
	source "$cliScriptPath" $1 -v -CxServer "$cx_server" -cxuser "$cx_user" -cxpassword "$cx_password" -locationtype "folder" -LocationPath "$cx_prj_folder" -Comment "$cx_Comment" -enableSca -scaLocationfolder "$cx_scaLocationfolder" -scaUsername "$cx_scaUsername" -scaPassword "$cx_scaPassword" -scaAccount "$cx_scaAccount" -configascode $2
}

CheckmarxScan () {
	cd $PWD/cx-cli
	source "$cliScriptPath" $1 -v -cxServer "$cx_server" -cxuser "$cx_user" -cxpassword "$cx_password" -locationtype "folder" -LocationPath "$cx_prj_folder" -Comment "$cx_Comment" -ProjectName "$cx_project_path" -preset "$cx_preset" -LocationPathExclude "$cx_LocationPathExclude" -SASTHigh "$cx_SASTHigh" -SASTMedium "$cx_SASTMedium" $2 -ReportXML $PWD/report.xml
}

CheckmarxScanSCA () {
	cd $PWD/cx-cli
	echo "[INFO] CxSAST/SCA Scan"
	source "$cliScriptPath" $1 -v -CxServer "$cx_server" -cxuser "$cx_user" -cxpassword "$cx_password" -locationtype "folder" -LocationPath "$cx_prj_folder" -Comment "$cx_Comment" -enableSca -scaUsername "$cx_scaUsername" -scaPassword "$cx_scaPassword" -scaAccount "$cx_scaAccount" -ProjectName "$cx_project_path" -preset "$cx_preset" -LocationPathExclude "$cx_LocationPathExclude" -SASTHigh "$cx_SASTHigh" -SASTMedium "$cx_SASTMedium" $2
}

ScaScanOnly () {
	cd $PWD/cx-cli
	echo "[INFO] SCA Scan"
	source "$cliScriptPath" ScaScan -v -ProjectName "$cx_project_path" -ScaLocationPath "$cx_scaLocationfolder" -scaUsername "$cx_scaUsername" -scaPassword "$cx_scaPassword" -scaAccount "$cx_scaAccount" $1
}

ScaScanResolver () {
	cd $PWD/cx-cli
	echo "[INFO] SCA Scan com Path Expoitable"
	source "$cliScriptPath" ScaScan -v -ProjectName "$cx_project_path" -ScaLocationPath "$cx_scaLocationfolder" -scaUsername "$cx_scaUsername" -scaPassword "$cx_scaPassword" -scaAccount "$cx_scaAccount" $1 -enablescaresolver -pathtoresolver "$resolverScriptPath" -scaresolveraddparameters "-s ""$cx_prj_folder"" -n ""$cx_project_name"" -r $cx_prj_folder"
}

# Area comandos do CxFlow

# Area de utilitarios
IncreaseJavaHeap () {
	echo "Ajustando memoria do heap..."
	sed -i 's/1024/2048/g' $PWD/runCxConsole.cmd
	sed -i 's/1024/2048/g' $PWD/runCxConsole.sh
	echo "Heap ajustado"
}

# Area de menus

CheckDir () {
	FILE=$1
	if [[ -d "$FILE" ]]; then
		diretorio="true"
	else
		diretorio="false"
	fi
}

SetTool () {
	case $1 in
	   -CxCLI)
		  CheckDir $PWD/cx-cli

		  if [ $diretorio == "true" ]
		  then
			CxCliFuncao $2 $3 $4
		  else
			DownloadCLI
			CxCliFuncao $2 $3 $4
		  fi
		  ;;
	   -CxFlow)
		  CheckDir $PWD/cxflow
		  
		  if [ $diretorio == "true" ]
		  then
			"em construção"
		  else
			DownloadCxFlow
		  fi
		  ;;
	   -ScaResolver)
		  echo "[ATENCAO] O Checkmarx SCA Resolver requer que os utilitários de resolução de dependência sejam instalados e que o projeto esteja buildável. Para obter uma lista de requisitos, consulte Suporte a gerenciadores de pacotes no SCA Resolver=https://checkmarx.com/resource/documents/en/34965-19198-installing-supported-package-managers-for-resolver.html"
		  CheckDir $PWD/resolver
		  
		  if [ $diretorio == "true" ]
		  then
			ResolverFuncao $2 $3
		  else
			DownloadResolver $2
			ResolverFuncao $2 $3
		  fi
		  ;;   
	   *)
		 echo "[Erro] Primeiro, informe qual ferramenta irá utilizar  "
		 echo "       Ex.: Checkmarx.sh -CxCLI   			          "
		 echo "       Ex.: Checkmarx.sh -CxFlow    			          "
		 echo "       Ex.: Checkmarx.sh -ScaResolver                  "
		 exit 1
		 ;;
	esac
}

# Inicio
#
# Para o SCA resolver
# $1 = ScaResolver
# $2 = O.S
# $3 = funcao
#
# Para o CxCLI
# $1 = CxCLI
# $2 = funcao
# $3 = async/sync
# $4 = incremental/full
# $5 = securityagate??

SetTool $1 $2 $3 $4