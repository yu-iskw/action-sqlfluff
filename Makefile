setup-dev:
	SQLFLUFF_VERSION=1.2.0 pip install --force-reinstall -r requirements/requirements.txt
	pre-commit install

lint: lint-shell lint-json lint-docker

lint-shell:
	shellcheck entrypoint.sh

lint-json:
	cat "to-rdjson.jq" | jq empty > /dev/null 2>&1; echo "$?"

lint-docker:
	hadolint Dockerfile
