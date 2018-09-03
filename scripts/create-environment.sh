#!/usr/bin/env sh

set -e

check_for_pull_request ()
{

  # Convert to lowercase to match PSH PR branch name.
  first_characters=$(printf %.3s "${BRANCH_NAME}")
  if [ "${first_characters}" = 'PR-' ];
    then
      BRANCH_NAME=$(echo "${BRANCH_NAME}" | tr '[:upper:]' '[:lower:]')
  fi

}

checkout_repository ()
{

  check_for_pull_request
  mkdir -p "${HOME}/.ssh" && ssh-keyscan -t rsa ssh.us.platform.sh, git.us.platform.sh >> "${HOME}/.ssh/known_hosts"
  git clone --branch "${BRANCH_NAME}" "${PLATFORMSH_PROJECT_ID}@git.us.platform.sh:${PLATFORMSH_PROJECT_ID}.git" /tmp/platform
  cd /tmp/platform || exit

}

create_branch ()
{

  git checkout -b "${PLATFORMSH_TEST_SITE}"

}

push_and_create_environment ()
{

  platform push --activate --parent master

}

#-------------------- Create Environment --------------------------------

checkout_repository
create_branch
push_and_create_environment

#-------------------- END: Create Environment ---------------------------
