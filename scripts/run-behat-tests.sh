#!/usr/bin/env sh

set -e

SSH_URL=$(platform ssh --pipe -p "${PLATFORMSH_PROJECT_ID}" -e "${PLATFORMSH_TEST_SITE}" | head -n 1)

run_behat_tests ()
{

  if [ -f "${BEHAT_CONFIG}" ];
    then
      ssh -T "${SSH_URL}" \
             "behat --config ${BEHAT_CONFIG}"
    else
      echo "Behat config cannot be found at ${BEHAT_CONFIG}."
      exit 1
  fi

}

#-------------------- Run Behat Tests --------------------

run_behat_tests

#-------------------- END: Run Behat Tests ---------------
