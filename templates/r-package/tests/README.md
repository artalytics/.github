# Testthat Unit Testing

Tests marked with prefix `(w/Mockups)` avoid live network calls by using `local_mocked_bindings` and local fixtures. These are for testing as part of CI/CD pipeline.

## External dependencies

- TBD

## Unit Testing

- Tests should achieve 85% coverage 
- Every function should have a unit test that makes no external connections (for CI) with the prefix "(w/Mockups)"
