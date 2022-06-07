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

def ProjetoExiste(fproject):
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

def CriarBranchPR(fid,fbranchName):
    urlBranch = cxServer + "/cxrestapi/projects/" + str(fid) + "/branch"
    headersBranch = {'Content-Type': 'application/json','Authorization': CheckmarxLogin()}
    payload = json.dumps({"name": fbranchName})
    responseBranch = requests.request("POST", urlBranch, headers=headersBranch,data=payload)

    if responseBranch.status_code == 201:
        json_data_project = json.loads(responseBranch.text)
        print("Branch de projeto criada " + fbranchName)
        branchId = json_data_project['id']
        return branchId
    else:
        print("Falha ao criar branch" + responseBranch.text)
        print(responseBranch.status_code)
        exit(1)

def Main():
    prExiste = ProjetoExiste(project_branh_name)
    
    if prExiste[0] == "false":
        pjExiste = ProjetoExiste(git_project_name)
        
        if pjExiste[0] == "false":
            print("O projeto principal nao existe no Checkmarx. Segue para scan e criacao do projeto " + project_branh_name)
        else:
            CriarBranchPR(pjExiste[1],project_branh_name)
            print("Branch criada e seguindo para scan " + project_branh_name)
    else:
        print("Projeto já existe. Segue para scan" + project_branh_name)

#variaveis 
print("Recebendo args:")
print(sys.argv[0])
print(sys.argv[1])
print(sys.argv[2])
#print(sys.argv[3])
#print(sys.argv[4])

#cxServer = sys.argv[0] #${{secrets.CHECKMARX_URL}}
#cxUser = sys.argv[1] #${{secrets.CXUSER}}
#cxPwd = sys.argv[2] # ${{secrets.CXPWD}}
#git_project_name = sys.argv[3] #${{ github.event.repository.name }}
#git_pr_number = sys.argv[4] # ${{github.event.pull_request.number}}
#project_branh_name = git_project_name + ".PR." + git_pr_number
#Main()
