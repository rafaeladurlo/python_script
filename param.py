# coding: utf-8
import sys

#variaveis 
print("Criando arquivo com parametros:")

build_id = sys.argv[1]
pr_id = sys.argv[2]

commentario = "Build Id: " + build_id + "PR Id: " + pr_id

f = open("param.txt", "a")
f.write(commentario)
f.close()
