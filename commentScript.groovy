@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7' )

import groovyx.net.http.HTTPBuilder

File file1 = new File("param.txt");
def String scanComment = file1.readLines();

println "INFO : Scanning code from $scanComment"

return scanComment
