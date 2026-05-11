setup-dev:
	SQLFLUFF_VERSION=4.1.0 python -m pip install --force-reinstall -r requirements/requirements.txt
	uv run pre-commit install

lint: lint-json run-pre-commit

lint-json:
	cat "to-rdjson.jq" | jq empty > /dev/null 2>&1; echo "$?"

run-pre-commit:
	uv run pre-commit run --all-files

maintain: update-pre-commit

update-pre-commit:
	uv run pre-commit autoupdate

build-docker:
	docker build -t action-sqlfluff:dev .
