setup-dev:
	SQLFLUFF_VERSION=3.0.7 python -m pip install --force-reinstall -r requirements/requirements.txt
	pre-commit install

lint: lint-json run-pre-commit

lint-json:
	cat "to-rdjson.jq" | jq empty > /dev/null 2>&1; echo "$?"

run-pre-commit:
	pre-commit run --all-files

maintain: update-pre-commit

update-pre-commit:
	pre-commit autoupdate
