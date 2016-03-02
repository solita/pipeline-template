APP_ARTIFACTS = ['target/hello.jar', 'start', 'stop']

job('build') {
    scm {
        git {
            remote {
                url('https://github.com/noidi/hello-java.git')
            }
            branch('master')
            clean()
        }
    }
    triggers {
        scm('*/15 * * * *')
    }
    steps {
        shell('mvn package')
        shell('mvn verify')
    }
    publishers {
        archiveJunit('target/failsafe-reports/*.xml')
        archiveArtifacts {
            APP_ARTIFACTS.collect { pattern(it) }
            onlyIfSuccessful()
        }
        downstream('deploy', 'SUCCESS')
    }
}

job('deploy') {
    steps {
        copyArtifacts('build') {
            buildSelector() {
                upstreamBuild(fallback=true)
            }
            includePatterns(*APP_ARTIFACTS)
            flatten()
        }
    }
}
