import com.checkmarx.flow.dto.ScanRequest
import com.checkmarx.flow.utils.ScanUtils
import groovy.json.JsonSlurper

println("------------- Groovy script execution started --------------------")
println("Checking sast comment")

static void main(String[] args) {
    comments(args[1], args[2]);
} 

def comments(fbuildnum, fprnum) { 
   String SAST_Comment = "Build: " + fbuildnum + " PR Id: " + fprnum;
   println(SAST_Comment)
   return SAST_Comment;
}
