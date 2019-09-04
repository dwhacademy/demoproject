this.pipelineJob("DWH Academy/Demo project/deployment") {
	concurrentBuild(false)
	definition {
		cpsScm {
			scm {
				git {
					remote {
						url("https://github.com/dwhacademy/demoproject.git")
						refspec("+refs/heads/\${BRANCH_NAME}:refs/remotes/origin/\${BRANCH_NAME}")
					}
					branch("\${BRANCH_NAME}")
					extensions {
						wipeOutWorkspace()
						cloneOption {
							honorRefspec(true)
							shallow(true)
							depth(1)
							noTags(false)
							reference('')
							timeout(20)
						}
					}
				}
			}
			scriptPath('automation/deployment_management/packaging/deployment.groovy')
		}
	}
	configure {
		it / definition / lightweight(false)
	}
	parameters {
		choiceParam("TARGET_ENVIRONMENT", ["DEV", "SBX01", "SBX02", "SBX03", "SBX04", "SBX05", "TST", "PRD"])
		stringParam("BRANCH_NAME", "develop", "branch name, i.e. develop")
	}
}

