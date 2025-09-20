COMMUNICATION

* Ask clarifying questions when doing so will lead to higher-impact responses, more precise results, or better-quality code.
* Assumptions are acceptable only when confidence is high that they are correct, useful, or recommended. Otherwise, follow up with questions to ensure alignment and mutual understanding.
* Unless explicitly noted (e.g., I request a “concise explanation”), provide details that help me learn and understand.

DEVELOPMENT PRACTICES

* Primary language: R. I almost exclusively develop code as R packages.
* Documentation: Use Roxygen2.
* Unit testing: Use testthat.
* Package installs: prefer pak over remotes in Dockerfiles or install steps.
* CI/CD Workflows included in package and use GitHub Actions.
* Unit Tests should typically be mocked to achieve coverage and run on GitHub-hosted runners.
* Live (non-mocked) unit tests may be included but must be skipped on CI with skip\_on\_ci.
* Shiny apps always developed and contained in their own R package.
* Shiny app codebase modularized using Shiny Modules where appropriate.
* Shiny app R-package unit tested with shinytest2.
* Shiny app R-packages include a Dockerfile and dockerignore, either in inst/docker/ or package root.
* Exceptions: Quarto projects (websites, books, blogs) and small snippets for testing or iteration.

CODING STYLE

* Always call external functions explicitly with package::function.
* Only exception: functions inside the same package namespace.
* Avoid library() calls, even in collaborative snippets, tests, or interactive sessions.

DATA HANDLING IN R

* For tabular datasets: always use data.table, not tibbles or dplyr.
* Open to tidyverse packages for non-table tasks, but data operations default to data.table.

PACKAGE AND FUNCTION PREFERENCES

* Use R’s native pipe operator |>
* Use fs for file handling, not base R.
* Always call external package functions explicitly.
* Prefer paste0() over paste().
* Write clear, helpful comments to clarify logic and decisions.

STRING MANIPULATION

* Prefer stringr over base R string functions.
* Exception: for simple concatenation, use paste0() if clearer, e.g. paste0("thumbnails/", artist, ".jpeg").
* For complex multi-line concatenation operations, typically prefer stringr::str\_glue() over paste0.

OPTIONAL TAGGING

* Use TODO comments for recommended follow-up tasks.
* Example: # TODO: Refactor this block for efficiency

GOLDEN RULE

* Always prioritize robustness, performance, efficiency, and code quality over stylistic preferences.
* If more lines of code make execution faster, choose performance over compactness.
* If another framework becomes more efficient than data.table in the future, consider adopting it.
* When performance is equal, prioritize compactness, readability, and comments that explain the “why,” not just the “what.”

SUMMARY CHECKLIST

* Ask clarifying questions when needed.
* Default to detail unless concise is requested.
* Develop as R packages (Roxygen2, testthat, GitHub Actions).
* Shiny apps: modularized, packaged, shinytest2, Dockerfile.
* Explicit package calls with package::function.
* Tables → data.table (not tibbles/dplyr).
* Native pipe (|>).
* File operations → fs package.
* String operations → stringr (except simple paste0).
* Use clear, helpful comments.
* TODO tags optional for follow-ups.
* Above all: prioritize performance and robustness.
