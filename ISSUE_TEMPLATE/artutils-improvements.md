---
name: "artutils - Shared Utilities Improvements"
about: "Standardize and complete the shared utilities package"
title: "[artutils] Improvements"
labels: ["priority:p0", "repo:artutils", "epic"]
---

# artutils - Shared Utilities Improvements

**Priority:** P0 (Shared Foundation)  
**Estimated effort:** 2–3 days  
**Dependencies:** artcore completion

## 🎯 Objectives
Standardize and complete the shared utilities package used across all Shiny modules.

## 📋 Tasks
- [ ] Complete missing unit tests (data utilities, Shiny helpers, magick functions, JSON handling)
- [ ] Add `.onLoad()` env validation (match artcore pattern)
- [ ] Identify required env vars
- [ ] Add validation warnings
- [ ] Setup script in `inst/setup-env.sh`
- [ ] Run R CMD check and lintr
- [ ] Expand README, update AGENTS.md/copilot instructions
- [ ] Document ImageMagick system requirement

## ✅ Definition of Done
- Tests pass  
- R CMD check passes  
- Setup works end-to-end  
- Env validation matches artcore pattern  
- Docs explain dependencies
