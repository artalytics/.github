---
name: "[MODULE_NAME] - Shiny Module Improvements"
about: "Improvements checklist for Shiny module repos"
title: "[module] Improvements"
labels: ["priority:p1", "repo:mod*", "epic"]
---

# [MODULE_NAME] - Shiny Module Improvements

**Priority:** P1 (Application Module)  
**Estimated effort:** 1–2 days  
**Dependencies:** artcore, artutils completion

## 📋 Tasks
- [ ] Complete test placeholders
- [ ] Add `shiny::testServer()` tests
- [ ] Test UI generation
- [ ] Mock DB/API dependencies
- [ ] Add `.onLoad()` env validation
- [ ] Setup script in `inst/setup-env.sh`
- [ ] Document dependencies
- [ ] Run R CMD check
- [ ] Test integration with sample data
- [ ] Verify namespace exports
- [ ] Improve README with examples

- [ ] Update example applications for the module (if available)
- [ ] Verify module works in headless CI (e.g., shinytest2)
- [ ] Document module interface
- [ ] Add demo mode instructions

## ✅ Definition of Done
- Tests (including Shiny) pass  
- Module works in demo mode  
- Setup creates working environment  
- Docs include integration examples
