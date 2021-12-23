# action-sqlfluff

<!-- TODO: replace reviewdog/yu-iskw/action-sqlfluff with your repo name -->
[![Test](https://github.com/yu-iskw/action-sqlfluff/workflows/Test/badge.svg)](https://github.com/yu-iskw/action-sqlfluff/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/yu-iskw/action-sqlfluff/workflows/reviewdog/badge.svg)](https://github.com/yu-iskw/action-sqlfluff/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/yu-iskw/action-sqlfluff/workflows/depup/badge.svg)](https://github.com/yu-iskw/action-sqlfluff/actions?query=workflow%3Adepup)
[![release](https://github.com/yu-iskw/action-sqlfluff/workflows/release/badge.svg)](https://github.com/yu-iskw/action-sqlfluff/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/yu-iskw/action-sqlfluff?logo=github&sort=semver)](https://github.com/yu-iskw/action-sqlfluff/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

![github-pr-review demo](./docs/images/github-pr-review-demo.png)

This is a github action to lint SQL with [sqlfluff](https://github.com/sqlfluff/sqlfluff).
The action automatically leaves comments about SQL violation using [reviewdog](https://github.com/reviewdog/reviewdog)

## Requirements
We have to set up a python environment in our workflow, because `action-sqlfluff` is a composite action.
In order not to interfere our python environment, it would be nicer to set up python separattely.
I made sure the action works on python 3.8, 3.9 and 3.10.

## Input

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  working-directory:
    description: 'Working directory relative to the root directory.'
    default: '.'
  ### Flags for reviewdog ###
  level:
    description: 'Report level for reviewdog [info,warning,error]'
    default: 'error'
  reporter:
    description: 'Reporter of reviewdog command [github-check,github-pr-review].'
    default: 'github-check'
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is file.
    default: 'file'
  fail_on_error:
    description: |
      Exit code for reviewdog when errors are found [true,false]
      Default is `false`.
    default: 'false'
  reviewdog_flags:
    description: 'Additional reviewdog flags'
    default: ''
  ### Flags for sqlfluff ###
  sqlfluff_version:
    description: 'sqlfluff version. Use the latest version if not set.'
    required: false
    default: ''
  paths:
    description: |
      PATH is the path to a sql file or directory to lint based on the working directory.
      This can be either a file ('path/to/file.sql'), a path ('directory/of/sql/files'), a single ('-') character to indicate reading from *stdin* or a dot/blank ('.'/' ') which will be interpreted like passing the current working directory as a path argument.
    required: true
  encoding:
    description: 'Specifiy encoding to use when reading and writing files. Defaults to autodetect.'
    required: false
    default: ''
  config:
    description: |
      Include additional config file.
      By default the config is generated from the standard configuration files described in the documentation.
      This argument allows you to specify an additional configuration file that overrides the standard configuration files.
      N.B. cfg format is required.
    required: false
    default: ''
  exclude-rules:
    description: |
      Exclude specific rules.
      For example specifying –exclude-rules L001 will remove rule L001 (Unnecessary trailing whitespace) from the set of considered rules.
      This could either be the allowlist, or the general set if there is no specific allowlist.
      Multiple rules can be specified with commas e.g. –exclude-rules L001,L002 will exclude violations of rule L001 and rule L002.
    required: false
    default: ''
  rules:
    description: |
      Narrow the search to only specific rules.
      For example specifying –rules L001 will only search for rule L001 (Unnecessary trailing whitespace).
      Multiple rules can be specified with commas e.g. –rules L001,L002 will specify only looking for violations of rule L001 and rule L002.
    required: false
    default: ''
  templater:
    description: 'The templater to use'
    required: false
    default: ''
  disable-noqa:
    description: 'Set this flag to ignore inline noqa comments.'
    required: false
    default: ''
  dialect:
    description: 'The dialect of SQL to lint'
    required: false
    default: ''
  #  annotation-level:
  #    description: |
  #      When format is set to github-annotation, default annotation level.
  #      Options
  #      notice | warning | failure
  #    required: false
  #    default: ''
  #  nofail:
  #    description: |
  #      If set, the exit code will always be zero, regardless of violations found.
  #      This is potentially useful during rollout.
  #    required: false
  #    default: ''
  #  disregard-sqlfluffignores:
  #    description: 'Perform the operation regardless of .sqlfluffignore configurations'
  #    required: false
  #    default: ''
  processes:
    description: 'The number of parallel processes to run.'
    required: false
    default: "2"
```

## Outputs
```yaml
outputs:
  sqlfluff-results:
    description: 'The JSON object string of sqlfluff results'
    value: ${{ steps.sqlfluff-with-reviewdog-in-composite.outputs.sqlfluff-results }}
  sqlfluff-exit-code:
    description: 'The exit code of sqlfluff'
    value: ${{ steps.sqlfluff-with-reviewdog-in-composite.outputs.sqlfluff-exit-code }}
  sqlfluff-results-rdjson:
    description: 'The JSON object string of sqlfluff results'
    value: ${{ steps.sqlfluff-with-reviewdog-in-composite.outputs.sqlfluff-results-rdjson }}
  reviewdog-return-code:
    description: 'The exit code of reviewdog'
    value: ${{ steps.sqlfluff-with-reviewdog-in-composite.outputs.reviewdog-return-code }}
```

## Usage

```yaml
name: sqlfluff with reviewdog
on:
  pull_request:
jobs:
  test-check:
    name: runner / sqlfluff (github-check)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: 3.9
      - uses: yu-iskw/action-sqlfluff@v1
        id: lint-sql
        with:
          github_token: ${{ secrets.github_token }}
          working-directory: "${{ github.workspace }}/testdata/test_failed_dbt"
          reporter: github-check
          config: "${{ github.workspace }}/testdata/test_failed_dbt/.sqlfluff"
          templater: jinja
          paths: 'models/'
```

## Development

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)
You can bump version on merging Pull Requests with specific labels (bump:major,bump:minor,bump:patch).
Pushing tag manually by yourself also work.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when released v1.2.3.
ref: https://help.github.com/en/articles/about-actions#versioning-your-action

### Lint - reviewdog integration

This reviewdog action template itself is integrated with reviewdog to run lints
which is useful for Docker container based actions.

![reviewdog integration](https://user-images.githubusercontent.com/3797062/72735107-7fbb9600-3bde-11ea-8087-12af76e7ee6f.png)

Supported linters:

- [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
- [reviewdog/action-hadolint](https://github.com/reviewdog/action-hadolint)
- [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)

### Dependencies Update Automation
This repository uses [reviewdog/action-depup](https://github.com/reviewdog/action-depup) to update
reviewdog version.

![reviewdog depup demo](https://user-images.githubusercontent.com/3797062/73154254-170e7500-411a-11ea-8211-912e9de7c936.png)
