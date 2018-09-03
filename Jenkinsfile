pipeline {
  agent none
  parameters {
    string(
      name: 'Modules',
      defaultValue: 'web/modules/custom',
      description: 'The location of modules to test.'
    )
  }
  stages {
    stage('Run Unit Tests') {
      environment {
        PHPUNIT_CONFIG = 'web/core'
      }
      agent {
        docker {
          image 'millerrs/phpunit-drupal8:php7-6.5'
        }
      }
      steps {
        sh """
          composer install --no-progress --profile --prefer-dist
          phpunit -c ${PHPUNIT_CONFIG} ${params.Modules}
        """
      }
    }
    stage('Run Behat Tests on Platform.sh') {
      environment {
        BEHAT_CONFIG = 'tests/behat/behat.yml'
        PLATFORMSH_CLI_TOKEN = credentials("platform-cli-token")
        PLATFORMSH_PROJECT_ID = credentials("platform-project-id")
        TEST_ENVIRONMENT = "jenkins-tests-${env.BUILD_ID}"
      }
      agent {
        docker {
          image 'millerrs/platformsh-cli'
        }
      }
      steps {
        sshagent(['jenkins-ssh-platform']) {
          sh './scripts/create-environment.sh'
          sh './scripts/run-behat-tests.sh'
        }
      }
      post {
        always {
          sshagent(['jenkins-ssh-platform']) {
            sh './scripts/cleanup.sh'
          }
        }
      }
    }
    stage('Check Code Quality') {
      parallel {
        stage('PHP CodeSniffer') {
          agent {
            docker {
              image 'millerrs/phpcs-drupal'
            }
          }
          steps {
            sh "phpcs --standard=Drupal,DrupalPractice ${params.Modules}"
          }
        }
        stage('ESLint') {
          agent {
            docker {
              image 'millerrs/eslint-drupal8'
            }
          }
          steps {
            sh """
              curl --silent --show-error -o web/.eslintrc.json http://cgit.drupalcode.org/drupal/plain/core/.eslintrc.json
              eslint ${params.Modules}
            """
          }
        }
        stage('CSSLint') {
          agent {
            docker {
              image 'millerrs/csslint'
            }
          }
          steps {
            sh "csslint ${params.Modules}"
          }
        }
      }
    }
  }
}