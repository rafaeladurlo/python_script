@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7' )

import groovyx.net.http.HTTPBuilder

def myVar = build.getEnvironment(listener).get('${CIRCLE_BRANCH}')

String scanComment = "Repo: $myVar"

return scanComment
