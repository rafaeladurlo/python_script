# coding: utf-8
import sys

#variaveis 
print("Criando arquivo com parametros:")

build_id = sys.argv[1]

commentario = "Build Id: " + build_id
print("commentario : " + commentario)

f = open("param.txt", "a")
f.write(commentario)
f.close()
