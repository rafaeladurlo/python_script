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
    scope = "access_control_api%20sast_api"
    clientId = "resource_owner_sast_client"
    payload = 'username=' + cxUser +'&password=' + cxPwd + '&grant_type=password&scope=' + scope + '&client_id=' + clientId +'&client_secret=014DF517-39D1-4453-B7B3-9930C563627C'
    headersToken = {'Content-Type': 'application/x-www-form-urlencoded'}
    responseToken = requests.request("POST", urlToken, headers=headersToken, data = payload)

    if responseToken.status_code == requests.codes['ok']:
        json_data = json.loads(responseToken.text)
        tokenCx = "Bearer " + json_data['access_token']
        return tokenCx
    else:
        print("Erro ao gerar token para o Checkmarx : " + responseToken.text)
        exit(1)

def ObterIdProjeto(fproject):
    urlProjects = cxServer + "/cxrestapi/projects"
    headersProjects = {'Authorization': CheckmarxLogin()}
    responseProjects = requests.request("GET", urlProjects, headers=headersProjects)
    
    if responseProjects.status_code == requests.codes['ok']:
        json_data_project = json.loads(responseProjects.text)
        
        for i in json_data_project:
            if fproject == i['name']:
                prjId = i['id']
                return ["true",prjId]
        
        return ["false","n/a"]

def DeletarProjeto(fid):
    urlDelete = cxServer + "/cxrestapi/help/projects/" + str(fid)
    headersPrjDelete = {'Content-Type': 'application/json;v=1.0','Authorization': CheckmarxLogin()}
    payloadDelete = json.dumps({"deleteRunningScans": "true"})
    responsePrjdelete = requests.request("DELETE", urlDelete, headers=headersPrjDelete,data=payloadDelete)

    if responsePrjdelete.status_code == 202:
        print("Projeto foi deletado")
        exit(0)
    else:
        print("Falha ao deletar projeto" + responsePrjdelete.text)
        print(responsePrjdelete.status_code)
        exit(1)

def Main():
    prIdprj = ObterIdProjeto(project_branh_name)
    
    if prIdprj[0] == "true":
        DeletarProjeto(prIdprj[1])
    else:
        print("O projeto nao existe" + project_branh_name)
        exit(0)

#variaveis 
print("Recebendo args:")
print(sys.argv[1])
print(sys.argv[2])
print(sys.argv[3])
print(sys.argv[4])
print(sys.argv[5])

cxServer = sys.argv[1] #${{secrets.CHECKMARX_URL}}
cxUser = sys.argv[2] #${{secrets.CXUSER}}
cxPwd = sys.argv[3] # ${{secrets.CXPWD}}
git_project_name = sys.argv[4] #${{ github.event.repository.name }}
git_pr_number = sys.argv[5] # ${{github.event.pull_request.number}}
project_branh_name = git_project_name + "-PR-" + git_pr_number

Main()
