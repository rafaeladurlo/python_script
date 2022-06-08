@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7' )

import groovyx.net.http.HTTPBuilder

def branch = request.getBranch()
def commitId = request.getHash()
String scanComment = "Branch: $branch | Commit ID: $commitId"
println "INFO : Scanning code from $scanComment"

return scanComment
