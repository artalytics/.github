---
name: "artcore - Foundation Package Improvements"
about: "Track improvements to the foundation package that all others depend on"
title: "[artcore] Improvements"
labels: ["priority:p0", "repo:artcore", "epic"]
---

# artcore - Foundation Package Improvements

**Priority:** P0 (Foundation Package)  
**Estimated effort:** 2–3 days  
**Dependencies:** None

## 🎯 Objectives
Complete critical improvements to the foundation package that all other packages depend on.

## 📋 Tasks
- [ ] Review test placeholders in `tests/testthat/test-*.R`
- [ ] Complete missing unit tests (`cdn_asset_url()`, env var validation, UUIDs, DB helpers)
- [ ] Verify coverage >80%
- [ ] Validate `.onLoad()` env var handling
- [ ] Test `inst/setup-env.sh`
- [ ] Document env vars in README
- [ ] Run R CMD check and fix issues
- [ ] Run `lintr`
- [ ] Verify examples in docs
- [ ] Review README, update copilot instructions
- [ ] Verify roxygen2 docs

## ✅ Definition of Done
- All tests pass  
- R CMD check passes  
- Setup script installs successfully  
- Documentation current and accurate
