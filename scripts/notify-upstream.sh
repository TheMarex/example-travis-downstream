#!/bin/bash

set -eu
set -o pipefail

BUILD_STATUS=${BUILD_STATUS:-$1}
TRAVIS_BUILD_NUMBER=${TRAVIS_BUILD_NUMBER:-0}
TRAVIS_COMMIT=${TRAVIS_COMMIT:-$(git log --format=%H --no-merges -n 1 | tr -d '\n')}
UPSTREAM_BRANCH=${UPSTREAM_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
GITHUB_MSG="
{
    \"state\": \"${BUILD_STATUS}\",
    \"target_url\": \"https://travis-ci.org/${DOWNSTREAM_REPO}/builds\",
    \"description\": \"Downstream build finished\",
    \"context\": \"continuous-integration/downstream/${DOWNSTREAM_REPO}/${TRAVIS_BUILD_NUMBER}\"
} "

post_status() {
    echo "Status [${TRAVIS_BUILD_NUMBER}]: ${BUILD_STATUS} for ${TRIGGER_COMMIT} in ${DOWNSTREAM_REPO}"
    curl -s -X POST \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -d "${GITHUB_MSG}" \
      "https://api.github.com/repos/${UPSTREAM_REPO}/statuses/${TRIGGER_COMMIT}"
}

post_status
