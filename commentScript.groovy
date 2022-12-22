@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7' )

import groovyx.net.http.HTTPBuilder

def myVar = build.getEnvironment(listener).get('${CIRCLE_BRANCH}')
String comment = myVar.toString(); 

String scanComment = "Repo: $comment"

println "INFO : Scanning code from $scanComment"

return scanComment
