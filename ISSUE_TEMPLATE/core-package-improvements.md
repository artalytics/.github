---
name: "Core Package Improvements"
about: "Foundational improvements for core packages"
title: "[package] Core Package Improvements"
labels: ["priority:p0", "epic"]
---

# [PACKAGE_NAME] - Core Package Improvements

**Priority:** P0 (Core Package)  
**Estimated effort:** 2–3 days  
**Dependencies:** None (update if needed)

## 🌿 Objectives
Complete critical improvements to the core package that other packages depend on.

## 📋 Tasks
- [ ] Review test placeholders in `tests/testthat/test-*.R`
- [ ] Complete missing unit tests for core functions (e.g., CDN helpers, environment validation, UUID generation, database helpers)
- [ ] Ensure test coverage exceeds 80%
- [ ] Add or validate `.onLoad()` function for environment variables
- [ ] Identify and document required environment variables
- [ ] Add validation warnings for missing critical env vars
- [ ] Create or update setup script in `inst/setup-env.sh`
- [ ] Test setup script installs all dependencies
- [ ] Document any required system dependencies (e.g., ImageMagick, FFmpeg, ExifTool, etc.)
- [ ] Run `R CMD check` and fix issues
- [ ] Run `lintr` and address style problems
- [ ] Verify examples in documentation work
- [ ] Review and update `README.md` for accuracy and completeness
- [ ] Verify roxygen2 documentation is complete

## ✅ Definition of Done
- [ ] All tests pass
- [ ] `R CMD check` passes without errors
- [ ] Setup script installs dependencies successfully
- [ ] Environment validation is robust
- [ ] Documentation is current and accurate
