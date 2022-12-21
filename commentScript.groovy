import com.checkmarx.flow.dto.ScanRequest
import com.checkmarx.flow.utils.ScanUtils
import groovy.json.JsonSlurper

println("------------- Groovy script execution started --------------------")
println("Checking sast comment")

String SAST_Comment = "Build: " + ${CIRCLE_BUILD_NUM} + " PR Id: " + ${CIRCLE_PR_NUMBER};
println(SAST_Comment)

return SAST_Comment;
