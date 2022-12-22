@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7' )

import groovyx.net.http.HTTPBuilder

String scanComment = "Commit ID: " + $CX_BUIL_ID.toString()

println "INFO : Scanning code from $scanComment"

return scanComment
