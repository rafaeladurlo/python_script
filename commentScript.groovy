@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.7' )
import groovyx.net.http.HTTPBuilder

def repoUrl = request.getRepoUrl()
def branch = request.getBranch()
def commitId = request.getHash()

String scanComment = "ScanRequest(namespace=" + request.getNamespace() + ", application=" + request.getApplication() + ", org=" + request.getOrg() + ", team=" + request.getTeam() + ", project=" + request.getProject() + ", cxFields=" + request.getCxFields() + ", site=" + request.getSite() + ", repoUrl=" + request.getRepoUrl() + ", repoName=" + request.getRepoName() + ", branch=" + request.getBranch() + ", mergeTargetBranch=" + request.getMergeTargetBranch() + ", mergeNoteUri=" + request.getMergeNoteUri() + ", repoProjectId=" + request.getRepoProjectId() + ", refs=" + request.getRefs() + ", email=" + request.getEmail() + ", incremental=" + request.isIncremental() + ", scanPreset=" + request.getScanPreset() + ", excludeFiles=" + request.getExcludeFiles() + ", excludeFolders=" + request.getExcludeFolders() + ", repoType=" + request.getRepoType() + ", product=" + request.getProduct() + ", bugTracker=" + request.getBugTracker() + ", type=" + request.getType() + ", activeBranches=" + request.getActiveBranches() + ", filter=" + request.getFilter()+ ", scanResubmit=" + request.getScanResubmit() + ")";

println "INFO : Scanning code from $scanComment"

return scanComment
