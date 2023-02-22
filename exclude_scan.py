# coding: utf-8
import requests,json,sys

print("  _____ _               _                               ")
print(" / ____| |             | |                              ")
print("| |    | |__   ___  ___| | ___ __ ___   __ _ _ ____  __ ")
print("| |    | '_ \ / _ \/ __| |/ / '_ ` _ \ / _` | '__\ \/ / ")
print("| |____| | | |  __/ (__|   <| | | | | | (_| | |   >  <  ")
print(" \_____|_| |_|\___|\___|_|\_\_| |_| |_|\__,_|_|  /_/\_\ ")
print("                                                        ")

def CheckmarxLogin():
    urlToken = cxServer + "/cxrestapi/auth/identity/connect/token"
    payload = 'username=' + cxUser + '&password=' + cxPwd + '&grant_type=password&scope=access_control_api%20sast_api&client_id=resource_owner_sast_client&client_secret=' + client_secret
    headersToken = {'Content-Type': 'application/x-www-form-urlencoded'}
    responseToken = requests.request("POST", urlToken, headers=headersToken, data = payload)

    if responseToken.status_code == requests.codes['ok']:
        json_data = json.loads(responseToken.text)
        tokenCx = "Bearer " + json_data['access_token']
        return tokenCx
    else:
        print("PayLoad : " + payload)
        print("Erro ao gerar token para o Checkmarx : " + responseToken.text)
        exit(1)

def returnLastId(fname):
    url = cxServer + "/Cxwebinterface/odata/v1/Projects?$filter=Name eq '" + fname + "'"
    headers = {'Authorization': CheckmarxLogin()}
    response = requests.request("GET", url, headers=headers)
    
    if response.status_code == requests.codes['ok']:
        json_data = json.loads(response.text)
        lastScanId = json_data['value'][0]['LastScanId']
        
        if str(lastScanId) == 'None':
            print("Este eh o primeiro scan do projeto")
            exit(0)
        else:
            deleteScanId(str(lastScanId))
    else:
        print(response.status_code)
        print("Falha ao retornar last scan id " + response.text)
        exit(1)

def deleteScanId(fscanId):
    url = cxServer + "/cxrestapi/sast/scans/" + str(fscanId)
    headers = {'Authorization': CheckmarxLogin()}
    response = requests.request("DELETE", url, headers=headers)
    
    if response.status_code == 202:
        print("Scan id " + fscanId + " foi excluido")
        exit(0)
    else:
        print("Falha ao excluir scan " + response.text)
        exit(1)

#variaveis 
cxServer = sys.argv[1]
cxUser = sys.argv[2]
cxPwd = sys.argv[3]
client_secret = sys.argv[4]
project_name = sys.argv[5]
returnLastId(project_name)
