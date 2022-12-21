import com.checkmarx.flow.dto.ScanRequest
import com.checkmarx.flow.utils.ScanUtils
import groovy.json.JsonSlurper

println("------------- Groovy script execution started --------------------")
println("Checking sast comment")

String SAST_Comment = "Build: " + args[1] + " PR Id: " + args[2];
println(SAST_Comment)

return SAST_Comment;
