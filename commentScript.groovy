import com.checkmarx.flow.dto.ScanRequest
import com.checkmarx.flow.utils.ScanUtils
import groovy.json.JsonSlurper

println("------------- Groovy script execution started --------------------")
println("Checking sast comment")

String mergeTargetBranch = request.getMergeTargetBranch();
String commitHash = request.gethash();
String SAST_Comment = "Merge Branch: " + mergeTargetBranch + " commit hash: "  + commitHash;

return SAST_Comment;
