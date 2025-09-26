# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the **artalytics/.github** repository - a special GitHub organization repository that manages:

- **Organization Profile**: Public-facing README displayed on the Artalytics GitHub organization page
- **Issue Templates**: Standardized templates for different package types and improvement workflows
- **Label Management**: Centralized label definitions synchronized across all organization repositories
- **Workflow Automation**: GitHub Actions for organization-wide label synchronization
- **AI Collaboration Guidelines**: Comprehensive coding standards and practices for AI assistants

This repository serves as the **public face** of the Artalytics organization on GitHub and provides organizational infrastructure for consistent project management across all repositories.

## Repository Structure

```
/Users/bobbyf/Projects/artalytics/.github/
├── .git/                              # Git repository (separate from parent)
├── .github/workflows/                 # GitHub Actions for this repo
│   └── manage-labels.yml             # Daily label synchronization workflow
├── ISSUE_TEMPLATE/                    # Organization-wide issue templates
│   ├── artcore-improvements.md        # Foundation package (P0 priority)
│   ├── artutils-improvements.md       # Utilities package (P0 priority)
│   ├── artpipeline-improvements.md    # Pipeline package improvements
│   ├── shiny-module-template.md       # Shiny module packages (P1 priority)
│   └── specialized-package-template.md # Domain-specific packages
├── profile/                           # Organization profile content
│   ├── README.md                      # Public organization description
│   └── assets/
│       └── Platform Diagrams - Simple.svg # Architecture diagram
├── AGENTS.md                          # AI assistant coding preferences
├── AI-Collaboration-Guidance.md       # Comprehensive AI coding guide
├── manage-your-labels.yml             # Label definitions for org sync
└── github-public.Rproj               # RStudio project file
```

## Key Commands

### Repository Management
```bash
# Navigate to .github repository
cd /Users/bobbyf/Projects/artalytics/.github

# Check repository status (separate git repo)
git status
git remote -v  # Points to artalytics/.github.git

# View organization profile locally
cat profile/README.md
```

### Label Management
```bash
# View current label configuration
cat manage-your-labels.yml

# Trigger manual label sync (requires GitHub CLI and permissions)
gh workflow run "Manage org labels" --repo artalytics/.github
```

### Issue Template Management
```bash
# List available issue templates
ls -la ISSUE_TEMPLATE/

# View specific template
cat ISSUE_TEMPLATE/artcore-improvements.md
cat ISSUE_TEMPLATE/shiny-module-template.md
```

## Development Workflows

### Updating Organization Profile
1. Edit `/Users/bobbyf/Projects/artalytics/.github/profile/README.md`
2. Update assets in `profile/assets/` if needed
3. Commit and push changes
4. Changes appear immediately on https://github.com/artalytics

### Managing Issue Templates
1. Templates are automatically available across all org repositories
2. Edit existing templates in `ISSUE_TEMPLATE/`
3. Templates follow YAML front matter + Markdown structure
4. Include priority labels (`priority:p0`, `priority:p1`) and repo tags

### Label Synchronization
- Labels defined in `manage-your-labels.yml`
- Automated daily sync via GitHub Actions at 9 AM UTC
- Manual trigger available via `workflow_dispatch`
- Syncs to all repositories listed in the `repositories` section

## Architecture & Standards

### Package Ecosystem Overview
The organization manages an R package ecosystem with:

- **Foundation**: `artcore` (P0) - Database, paths, environment setup
- **Utilities**: `artutils` (P0) - Higher-level utilities building on artcore
- **Pipelines**: `artpipelines` - Processing orchestration
- **Shiny Modules**: `mod*` packages (P1) - UI components (modUpload, modBrowse, etc.)
- **Domain Packages**: Specialized functionality (artopenai, artopensea, pixelsense, etc.)
- **Applications**: Platform apps and sites
- **Infrastructure**: Build tools and metrics

### Priority System
- **P0 (Foundation)**: Critical packages all others depend on (`artcore`, `artutils`)
- **P1 (Specialized)**: Application modules and domain-specific packages
- **Epic**: Cross-cutting work spanning multiple repositories

### R Development Standards
Key standards enforced across the organization:

- **Package-based architecture**: Every component is an R package
- **Explicit namespacing**: Always use `package::function()` syntax
- **data.table over dplyr**: For performance and consistency
- **Native pipe**: Use `|>` instead of `%>%`
- **CDN assets**: No local static files, use CDN helper functions
- **Environment configuration**: Secrets via env vars, never hardcoded
- **Structured logging**: Use `rdstools::log_*()` functions
- **Comprehensive testing**: testthat with mocked dependencies

## Differences from .github-private

This **public** `.github` repository differs from the private version:

- **Public visibility**: Content is publicly accessible on GitHub
- **Organization profile**: Contains the public-facing org description
- **Sanitized templates**: Issue templates contain no sensitive information
- **General guidelines**: AI collaboration guidance is suitable for public viewing
- **Open label system**: Label definitions can be publicly viewed

The private `.github-private` repository likely contains:
- Internal-only issue templates
- Sensitive workflow configurations
- Private organizational procedures
- Security-related templates and processes

## Related Files

- **AI Guidelines**: See `AI-Collaboration-Guidance.md` for comprehensive R development standards
- **Agent Preferences**: See `AGENTS.md` for concise AI assistant preferences
- **Organization Profile**: See `profile/README.md` for public organization description
- **Label Config**: See `manage-your-labels.yml` for organization-wide label definitions

## Notes for Claude Code

- This is a **separate git repository** within the artalytics project structure
- Focus on **organization-level** changes, not individual package development
- When updating issue templates, consider impact across all organization repositories
- Follow R package development standards outlined in the AI guidance documents
- Prefer editing existing files over creating new ones
- Never include sensitive information in this public repository