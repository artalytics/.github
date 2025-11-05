# Script to sync labels across all Artalytics repositories
# This script will:
# 1. Delete all existing labels from each repository
# 2. Create standardized labels from manage-labels.yml

$ErrorActionPreference = "Continue"

# Repository list
$repos = @(
    "artalytics/api-waitlist",
    "artalytics/appAdmin",
    "artalytics/appPlatform",
    "artalytics/artauth",
    "artalytics/artbenchmark",
    "artalytics/artcore",
    "artalytics/artsend",
    "artalytics/artutils",
    "artalytics/artpipelines",
    "artalytics/artopenai",
    "artalytics/artopensea",
    "artalytics/modArtist",
    "artalytics/modBrowse",
    "artalytics/modFrames",
    "artalytics/modGallery",
    "artalytics/modUpload",
    "artalytics/pixelsense",
    "artalytics/pixelsense2"
)

# New standardized labels
$labels = @(
    @{name="priority:p0"; color="b60205"; description="Top priority / foundation"},
    @{name="priority:p1"; color="d93f0b"; description="High priority / specialized"},
    @{name="type:epic"; color="5319e7"; description="Cross-cutting work"},
    @{name="type:feature"; color="0e8a16"; description="New capability"},
    @{name="type:bug"; color="d73a4a"; description="Fix incorrect behavior"},
    @{name="type:chore"; color="c2e0c6"; description="Maintenance / infrastructure"},
    @{name="status:ready"; color="1d76db"; description="Ready to start"},
    @{name="status:blocked"; color="000000"; description="Waiting on dependency"},
    @{name="status:in-progress"; color="fbca04"; description="Actively being worked"},
    @{name="task:docs"; color="0075ca"; description="Documentation tasks"},
    @{name="task:tests"; color="5319e7"; description="Testing tasks"},
    @{name="task:database"; color="006b75"; description="Database and schema tasks"}
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Label Synchronization Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

foreach ($repo in $repos) {
    Write-Host "Processing repository: $repo" -ForegroundColor Yellow
    Write-Host "  Step 1: Deleting existing labels..." -ForegroundColor Gray

    # Get all existing labels and delete them
    $existingLabels = gh label list --repo $repo --json name --jq '.[].name' 2>$null

    if ($existingLabels) {
        foreach ($labelName in $existingLabels) {
            if ($labelName) {
                Write-Host "    - Deleting: $labelName" -ForegroundColor DarkGray
                gh label delete $labelName --repo $repo --yes 2>$null | Out-Null
            }
        }
    }

    Write-Host "  Step 2: Creating standardized labels..." -ForegroundColor Gray

    # Create new standardized labels
    foreach ($label in $labels) {
        Write-Host "    + Creating: $($label.name)" -ForegroundColor DarkGray
        gh label create $label.name --color $label.color --description $label.description --repo $repo --force 2>$null | Out-Null
    }

    Write-Host "  [OK] Completed: $repo" -ForegroundColor Green
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Label synchronization complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
