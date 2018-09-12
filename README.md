# Jenkins Pipeline for Platform.sh Projects

An example Jenkins pipeline for Drupal projects hosted on Platform.sh. Runs PHPUnit, Behat, PHP CodeSniffer, ESLint and CSSLint tests.

## Requirements for Jenkins
 * Jenkins Blue Ocean
 * Jenkins SSH Agent Plugin

## Usage

### Step 1: Copy files to your project

Copy the contents of this repository to your project.  The Jenkinsfile and .environment files must be in the repository root. The scripts can be placed anywhere.

For your convenience, you can run the following:

```bash
curl -OLs https://github.com/millerrs/jenkins-pipeline-platformsh/archive/master.zip && unzip -qn master.zip && rm master.zip && rsync -av --exclude=README.md jenkins-pipeline-platformsh-master/ . && rm -rf jenkins-pipeline-platformsh-master
```

### Step 2: Create Jenkins credentials

Create three credentials in your Jenkins instance:
                                                                                
* *Secret text* with your Platform.sh project ID
* *Secret text* with your [Platform.sh API token](https://docs.platform.sh/gettingstarted/cli/api-tokens.html)
* *SSH username with private key* (public key needs to be [added to your Platform.sh account](https://docs.platform.sh/development/ssh.html))

> **Note**: The credential IDs used in the pipeline are platform-project-id, platform-cli-token and jenkins-ssh-platform. These can be changed, however if you want to make minimal changes, consider using these IDs.

### Step 3: Customize pipeline

Check that the paths for `Modules`, `PHPUNIT_CONFIG` and `BEHAT_CONFIG` are correct. If you used different credential IDs or put the scripts in a different location, make sure to update.

The use of Docker images is optional.  If your project already has tools such as PHPUnit and Behat set as Composer dependencies, you might want to execute the tests using vendor binaries instead of containers. If going this route, a common approach is to add a build or install step where you run `composer install`.

### Step 4: Setup pipeline in Jenkins

The final step is to setup the pipeline in Jenkins.  Refer to the [Jenkins docs](https://jenkins.io/doc/book/blueocean/creating-pipelines/) for instructions.
