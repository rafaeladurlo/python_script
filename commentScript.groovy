import com.checkmarx.flow.dto.ScanRequest
import com.checkmarx.flow.utils.ScanUtils
import groovy.json.JsonSlurper

println("------------- Groovy script execution started --------------------")
println("Checking sast comment")

String branch = request.getBranch();
String SAST_Comment = "Merge Branch: " + branch;

return SAST_Comment;
