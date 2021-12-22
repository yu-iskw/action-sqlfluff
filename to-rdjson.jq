{
  source: {
    name: "sqlfluff",
    url: "https://github.com/sqlfluff/sqlfluff"
  },
  diagnostics: (. // {}) | map(. as $file | $file.violations[] as $violation | {
    message: $violation.description,
    code: {
      value: $violation.code,
      url: "https://docs.sqlfluff.com/en/stable/rules.html#sqlfluff.core.rules.Rule_\($violation.code)"
    },
    location: {
      path: $file.filepath,
      range: {
        start: {
          line: $violation.line_no,
          column: $violation.line_pos
        },
      }
    },
    severity: "WARNING",
  })
}
