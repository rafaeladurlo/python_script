@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7' )

import groovyx.net.http.HTTPBuilder

println args[0]
println args[1]
def buildId = "GitLab"
def branch = "GitLabBranch"
String scanComment = "Branch: $branch | Build ID: $buildId"
println "INFO : Scanning code from $scanComment"

return scanComment
