import com.checkmarx.flow.dto.ScanRequest
import com.checkmarx.flow.utils.ScanUtils
import groovy.json.JsonSlurper

println("------------- Groovy script execution started --------------------")
println("Checking sast comment")

String mergeTargetBranch = request.mergeTargetBranch();
String mergeNoteUri = request.mergeNoteUri();
String commitHash = request.hash();
String SAST_Comment = "Merge Branch: " + mergeTargetBranch + " Merge URi " + mergeNoteUri + " commit hash: "  + commitHash;

return SAST_Comment;
