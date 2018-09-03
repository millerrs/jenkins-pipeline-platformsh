#!/usr/bin/env sh

cd /tmp/platform \
	&& platform environment:delete --project "${PLATFORMSH_PROJECT_ID}" --delete-branch --yes "${TEST_ENVIRONMENT}"