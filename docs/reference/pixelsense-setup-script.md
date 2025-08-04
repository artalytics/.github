# Minimizing Environment Setup for the `pixelsense` Package (v0.8.1)

## Overview of the **PixelSense** Package (v0.8.1)

We first confirm that the **artalytics/pixelsense** package is at version **0.8.1**. PixelSense is an R package in the Artalytics platform focused on **image verification** tasks. Its functionality centers around verifying digital artwork images and generating certification documents. Key features and components include:

* **Image Similarity & Verification:** PixelSense can compute perceptual hashes and similarities for images to detect duplicates or verify authenticity. For example, a function `compute_sim()` (in `R/image-verify.R`) calculates similarity metrics given an image hash. This helps ensure an uploaded artwork is unique compared to existing ones in the database.
* **Certificate Generation:** The package generates verification certificates (PDF files) for artworks. A function `renderCertificate()` (in `R/cert-render.R`) assembles LaTeX templates with artwork images and signatures, producing a PDF certificate. (Earlier tests showed issues including remote image URLs in LaTeX; the fix was to download those images locally before compilation, ensuring LaTeX can include them properly.)
* **Platform Integration:** PixelSense relies on **artalytics core libraries** for platform services. It imports internal packages **`artcore`** and **`artutils`** for database access, cloud storage, and other shared utilities. For instance, `artcore` provides database connectivity (via `rpgconn` to a PostgreSQL DB) and S3/Spaces storage access (via `paws.storage`), enabling PixelSense to fetch reference data or store results.
* **Web Application Components:** PixelSense includes a Shiny web interface to interact with these verification features. It imports **Shiny** and UI helpers (like **`shinyNextUI`** from RinteRface and **`waiter`** for loading screens). This suggests PixelSense offers Shiny modules or apps for users (e.g., an admin UI to upload an image and view its verification certificate or similarity results).
* **Use of External APIs/AI:** The package suggests integration with OpenAI via **`artopenai`** (an Artalytics package likely wrapping OpenAI’s API). This is optional (in **Suggests**), possibly to analyze or describe images using AI. It’s not required for core operation but can enhance the verification process.
* **Utility Dependencies:** PixelSense leverages a variety of R packages for data handling and image processing. For example, it uses **`magick`** and **`OpenImageR`** for image reading, transformations, and hashing; **`pdftools`** (suggested) for handling PDFs; and familiar tools like **`data.table`**, **`stringr`**, **`httr/httr2`** for data manipulation and web requests. It also uses **`tinytex`** (with a minimal TeX installation) to compile LaTeX templates into PDF certificates.

**Repository Structure:** The PixelSense repository is a standard R package structure. All R functions reside under `R/` (e.g. `image-verify.R`, `cert-render.R`, etc.), tests under `tests/` (e.g. `test-cert-render.R` and `test-image-verify.R` focusing on the certificate output and similarity computation), and package metadata in files like `DESCRIPTION` and `NAMESPACE`. There may also be a Shiny app directory or module definitions, given the Shiny-related imports. The **DESCRIPTION** file (excerpted below) succinctly lists the package’s dependencies and system requirements:

> **DESCRIPTION excerpt:** PixelSense requires R 4.1+, imports Artalytics core packages and numerous CRAN packages (data.table, magick, etc.), and has suggested packages for testing and extended features. It also specifies system libraries needed for imaging and numeric computing (ImageMagick++, Armadillo, BLAS/LAPACK, FFTW, etc.) – reflecting the image processing and matrix operations under the hood.

## Global vs. Package-Specific Environment Setup

The Artalytics organization provides a **global environment setup script** (previously `inst/codex-env-setup.sh` in each repo, now centralized as `.github/scripts/setup-full-env.sh`) to configure a development environment for **all** Artalytics R packages. This global script installs a broad range of system libraries and R packages to cover every package’s needs. For example, it adds the CRAN repository and installs R 4.5, then installs system dependencies like **ImageMagick**, **Poppler**, **Tesseract OCR**, **FFmpeg**, **PostgreSQL client libraries**, etc., even if some repos don’t use all of these. It then uses **{pak}** (R package manager) to install all core Artalytics packages (artcore, artutils, artbenchmark, artopenai, artopensea, pixelsense, artpipelines, etc.) in one batch. This ensures a one-time setup of a full dev/test environment, but it is **time-consuming** when a given repository only needs a subset of those components.

**Why Customize for PixelSense?** In continuous integration (CI) or developer setups for *pixelsense*, we can save significant time by installing **only the dependencies needed for this package** (plus its suggests for testing). The global script’s “install everything” approach, while comprehensive, does unnecessary work for a single package’s CI – for instance, PixelSense likely doesn’t require OCR (Tesseract) or video processing (FFmpeg) capabilities, so installing those libraries and related R packages is wasted effort. By extracting a **minimal setup script** for PixelSense, we avoid installing extra system libraries and packages, potentially cutting down setup time by several minutes.

## Extracting PixelSense-Specific Dependencies

To create a minimal environment setup, we identify PixelSense’s exact requirements from its **DESCRIPTION** (since it fully enumerates the needed dependencies). We will include:

* **System Libraries:** Only those listed under **SystemRequirements** (and any additional libraries needed by PixelSense’s R packages, including suggested ones). According to DESCRIPTION, PixelSense needs the following system libs: **ImageMagick++**, **Armadillo**, **BLAS/LAPACK**, **ARPACK**, **FFTW3**, **JPEG**, **PNG**, **TIFF**, and a Fortran compiler. In Ubuntu package terms, these correspond to: `libmagick++-dev`, `libarmadillo-dev`, `libblas-dev`, `liblapack-dev`, `libarpack++2-dev`, `libfftw3-dev`, `libjpeg-dev`, `libpng-dev`, `libtiff5-dev`, and `gfortran`.

  Additionally, **PixelSense’s suggested packages** imply a few more libraries:

  * The **`pdftools`** package (in Suggests) requires Poppler libraries. We include `libpoppler-cpp-dev` and its data (`poppler-data`) so that pdftools can compile and run.
  * PixelSense’s core imports include **`httr`/`httr2`** which use libcurl and openssl under the hood, and **`artcore`** which needs libpq for PostgreSQL access. Thus, we include `libcurl4-openssl-dev`, `libssl-dev`, `libxml2-dev` (for XML parsing needs), and `libpq-dev` (Postgres client library). These were part of the global script and are indeed relevant here (e.g., artcore’s SystemRequirements call out libpq).
  * We do **not** include extras like Tesseract (OCR) or FFmpeg’s `libavfilter` since PixelSense does not use OCR or video processing. Similarly, we skip `libgit2-dev` (useful for dev tools or git-based packages) and `libarchive-dev` (for general archive handling) because they aren’t required by PixelSense or its dependencies.
  * Basic build tools (make, GCC, etc.) are needed to compile packages. The global script already included `build-essential`, `pkg-config`, and we keep those for completeness.

* **R Packages:** We install PixelSense and all its R package dependencies:

  * **Direct Imports/Depends:** These will be pulled in automatically by installing the PixelSense package via **pak** (which reads the Imports/Depends and Remotes). For instance, installing `artalytics/pixelsense` will fetch **artcore**, **artutils**, **shinyNextUI**, **rdstools**, etc. from GitHub as specified in **Remotes**, and all CRAN packages like **data.table**, **magick**, **shiny**, etc. from CRAN. We ensure **pak** (the R package manager) is available to handle this efficiently.
  * **Suggested packages:** To fully equip the dev/test environment, we also install Suggests: **testthat** (for running PixelSense’s tests), **knitr** (for vignette or report generation), **shiny.react** (enhances the Shiny UI with React components), **pdftools** (for any PDF text extraction or inspection), and **artopenai** (for optional AI features). These won’t be auto-installed with the main package by default, so we explicitly include them in the installation step.
  * **TinyTeX and LaTeX:** PixelSense’s certificate generation uses **tinytex** (in Imports) to call LaTeX. Instead of installing the TinyTeX R package from source, we follow the same approach as the global script: install a lightweight TeX distribution and the **r-cran-tinytex** binary package. Specifically, we install minimal TeX Live packages (`texlive-latex-base`, `texlive-latex-extra`, `texlive-fonts-recommended`, `texlive-luatex`, `latexmk`) to support compiling the certificate template to PDF, and then install **TinyTeX** via `apt` as a binary (this provides the R interface without needing to compile or download TeX live on the fly). This approach yields a faster, reproducible LaTeX setup.

By extracting only the above, we drop all unrelated installations. This lean script ensures the environment has **everything PixelSense needs** to build, run, and test, but nothing extra. We expect this targeted installation to save significant setup time (possibly on the order of 5+ minutes), especially in CI contexts, compared to the all-inclusive script.

## Minimal Setup Script for **PixelSense**

Below is the **PixelSense-specific environment setup script**, distilled from the global setup. It installs R (ensuring a recent version), the minimal required system libraries for PixelSense and its dependencies, and then uses **pak** to install PixelSense plus all its R package dependencies (including suggested packages for testing). Finally, it sets up TinyTeX and LaTeX support for PDF certificate generation.

```bash
#!/usr/bin/env bash
# Environment setup for PixelSense (artalytics/pixelsense) v0.8.1

set -euo pipefail

# 1. Add CRAN repository for latest R packages (Ubuntu)
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends software-properties-common dirmngr gnupg ca-certificates wget apt-transport-https
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/cran.gpg
CODENAME=$(lsb_release -cs)
echo "deb [signed-by=/usr/share/keyrings/cran.gpg] https://cloud.r-project.org/bin/linux/ubuntu ${CODENAME}-cran40/" | sudo tee /etc/apt/sources.list.d/cran.list
sudo apt-get update -y

# 2. Install R (>= 4.1) and essential build tools
sudo apt-get install -y \
    r-base r-base-dev \
    build-essential gfortran pkg-config

# 3. Install system libraries required by PixelSense and its R packages
sudo apt-get install -y \
    libmagick++-dev            `# for R 'magick' (ImageMagick++)` \
    libarmadillo-dev           `# for linear algebra (RcppArmadillo)` \
    libblas-dev liblapack-dev  `# BLAS/LAPACK for Armadillo/FFT computations` \
    libarpack++2-dev           `# ARPACK for matrix operations (e.g., clustering/UMAP if used)` \
    libfftw3-dev               `# FFTW for image processing or frequency analysis` \
    libjpeg-dev libpng-dev libtiff5-dev `# image formats for 'magick' and 'OpenImageR'` \
    libpoppler-cpp-dev poppler-data     `# Poppler for 'pdftools' (PDF text extraction)` \
    libcurl4-openssl-dev libssl-dev     `# for 'httr/httr2' and any HTTPS requests (Curl/OpenSSL)` \
    libxml2-dev                `# for XML parsing (if needed by HTTR or other packages)` \
    libpq-dev                  `# PostgreSQL client for 'artcore' database access`

# 4. Verify R installation
echo "Installed R version: $(Rscript -e 'cat(getRversion())')"

# 5. Install pak (R package manager) for fast package installation
Rscript -e 'install.packages("pak", repos="https://cloud.r-project.org")'

# 6. Install PixelSense and its R package dependencies (incl. suggested packages)
Rscript -e 'pak::pkg_install(c(
    "artalytics/pixelsense",    # PixelSense package (will bring Imports/Remotes)
    "artalytics/artopenai",     # Suggested: OpenAI integration
    "shiny.react",              # Suggested: React components for Shiny
    "knitr", "pdftools",        # Suggested: reporting and PDF tools
    "testthat"                  # Suggested: testing framework
  ))'

# 7. Install TinyTeX (LaTeX) for PDF rendering (certificate generation)
sudo apt-get install -y --no-install-recommends \
    texlive-latex-base texlive-latex-extra texlive-fonts-recommended texlive-luatex latexmk

# 8. Install TinyTeX R package as a binary (provides tinytex:: tools without full TeX distro)
sudo apt-get install -y --no-install-recommends r-cran-tinytex

echo "✅ PixelSense environment setup complete."
```

**Notes:**

* This script assumes a Debian/Ubuntu environment (as in CI). It installs system libraries with apt-get. Comments (`# ...`) are added for clarity, mapping each lib to the R package or feature that requires it.
* We explicitly include PixelSense’s *suggested* packages in the `pak::pkg_install` call to ensure a complete dev/test setup. The main PixelSense install will automatically pull all **Imports** (and their dependencies) – including internal packages from GitHub (artcore, artutils, etc.) and CRAN packages (data.table, magick, etc.) – thanks to the Remotes specified in the DESCRIPTION. Using **{pak}** downloads packages in parallel and uses binary builds when available, speeding up installation.
* The LaTeX installation is minimal. We include just enough TeX Live packages for compiling typical documents (the certificate uses the **LuaLaTeX** engine, hence `texlive-luatex` and `latexmk` for building). Then we install **TinyTeX** via apt (`r-cran-tinytex`), which provides the R functions to interface with LaTeX without needing to invoke a massive TeX installer at runtime.
* We skip any components not needed by PixelSense (e.g., Tesseract/OCR libraries, FFmpeg, etc.), keeping the setup lean. If applying this process to another repository, one would replace the PixelSense-specific details (package name and its unique dependencies) accordingly. The approach remains: use the package’s DESCRIPTION to drive which system libs and R packages to include.

By tailoring the environment setup to the **pixelsense** package, we ensure faster build times while still providing all necessary dependencies for development and testing. Future agents can follow this template – substituting the package name and adjusting for that package’s DESCRIPTION – to create minimal env setup scripts for other Artalytics R packages. This fosters efficient, package-specific CI pipelines without sacrificing functionality.
