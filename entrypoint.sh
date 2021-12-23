#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN:?}"

echo '::group:: Running sqlfluff 🐶 ...'
# Allow failures now, as reviewdog handles them
set +Eeuo pipefail

# Make sure the version of sqlfluff
sqlfluff --version

lint_results="sqlfluff-lint.json"
# shellcheck disable=SC2086,SC2046
sqlfluff lint \
  --format json \
  $(if [[ "x${SQLFLUFF_CONFIG}" != "x" ]]; then echo "--config ${SQLFLUFF_CONFIG}"; fi) \
  $(if [[ "x${SQLFLUFF_DIALECT}" != "x" ]]; then echo "--dialect ${SQLFLUFF_DIALECT}"; fi) \
  $(if [[ "x${SQLFLUFF_PROCESSES}" != "x" ]]; then echo "--processes ${SQLFLUFF_PROCESSES}"; fi) \
  $(if [[ "x${SQLFLUFF_RULES}" != "x" ]]; then echo "--rules ${SQLFLUFF_RULES}"; fi) \
  $(if [[ "x${SQLFLUFF_EXCLUDE_RULES}" != "x" ]]; then echo "--exclude-rules ${SQLFLUFF_EXCLUDE_RULES}"; fi) \
  $(if [[ "x${SQLFLUFF_TEMPLATER}" != "x" ]]; then echo "--templater ${SQLFLUFF_TEMPLATER}"; fi) \
  $(if [[ "x${SQLFLUFF_DISABLE_NOQA}" != "x" ]]; then echo "--disable-noqa ${SQLFLUFF_DISABLE_NOQA}"; fi) \
  $(if [[ "x${SQLFLUFF_DIALECT}" != "x" ]]; then echo "--dialect ${SQLFLUFF_DIALECT}"; fi) \
  "${SQLFLUFF_PATHS:?}" |
  tee "$lint_results"
sqlfluff_exit_code=$?

echo "::set-output name=sqlfluff-results::$(cat <"$lint_results" | jq -r -c '.')" # Convert to a single line
echo "::set-output name=sqlfluff-exit-code::${sqlfluff_exit_code}"

set -Eeuo pipefail
echo '::endgroup::'

echo '::group:: Running reviewdog 🐶 ...'
# Allow failures now, as reviewdog handles them
set +Eeuo pipefail

lint_results_rdjson="sqlfluff-lint.rdjson"
cat <"$lint_results" |
  jq -r -f "${SCRIPT_DIR}/to-rdjson.jq" |
  tee >"$lint_results_rdjson"

cat <"$lint_results_rdjson" |
  reviewdog -f=rdjson \
    -name="sqlfluff" \
    -reporter="${REVIEWDOG_REPORTER}" \
    -level="${REVIEWDOG_LEVEL}" \
    -fail-on-error="${REVIEWDOG_FAIL_ON_ERROR}" \
    -filter-mode="${REVIEWDOG_FILTER_MODE}"
reviewdog_return_code="${PIPESTATUS[1]}"

echo "::set-output name=sqlfluff-results-rdjson::$(cat <"$lint_results_rdjson" | jq -r -c '.')" # Convert to a single line
echo "::set-output name=reviewdog-return-code::${reviewdog_return_code}"

set -Eeuo pipefail
echo '::endgroup::'

exit $sqlfluff_exit_code
