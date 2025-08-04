#!/usr/bin/env bash
# CODEX environment setup script
# Date: 2025-08-03
# Ensures R >= 4.5 and necessary system/R dependencies are installed

set -euo pipefail

# -> Verify GITHUB_PAT is set for private GitHub installs
if [ -z "${GITHUB_PAT:-}" ]; then
  echo "Error: GITHUB_PAT environment variable is not set. Please export it before running this script."
  exit 1
fi

# 1. Update package lists
sudo apt-get update

# 2. Install prerequisites for adding CRAN repository and fetching keys
sudo apt-get install -y --no-install-recommends \
  software-properties-common \
  dirmngr \
  gnupg \
  wget \
  apt-transport-https \
  ca-certificates

# 3. Fetch and install CRAN GPG key securely
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | sudo gpg --dearmor -o /usr/share/keyrings/cran.gpg

# 4. Add CRAN repository (signed by the downloaded key)
CODENAME=$(lsb_release -cs)
echo "deb [signed-by=/usr/share/keyrings/cran.gpg] https://cloud.r-project.org/bin/linux/ubuntu ${CODENAME}-cran40/" \
  | sudo tee /etc/apt/sources.list.d/cran.list

# 5. Refresh package lists
sudo apt-get update

# 6. Install R >= 4.5 and system dependencies
sudo apt-get install -y \
  r-base r-base-dev \
  build-essential gfortran pkg-config \
  libmagick++-dev libgit2-dev libssl-dev libcurl4-openssl-dev \
  libxml2-dev libpoppler-cpp-dev poppler-data \
  libavfilter-dev libpq-dev libarchive-dev libimage-exiftool-perl \
  libarmadillo-dev libblas-dev liblapack-dev libarpack++2-dev \
  libfftw3-dev libjpeg-dev libpng-dev libtiff5-dev \
  libtesseract-dev libleptonica-dev tesseract-ocr-eng

# 7. Verify R version
echo "Installed R version:" $(Rscript -e 'cat(getRversion())')

# 8. Install core R packages non-interactively
Rscript -e 'install.packages(c("remotes", "pak", "devtools", "roxygen2", "testthat"), repos = "https://cloud.r-project.org")'

# -> Verify you're in package root by checking for DESCRIPTION
if [ ! -f DESCRIPTION ]; then
  echo "Error: DESCRIPTION file not found. Please run this script from the root of your R package."
  exit 1
fi

# 9. From the repository root, install DESCRIPTION dependencies
Rscript -e 'remotes::install_deps(dependencies = TRUE)'

# 10. Install any missing GitHub packages
Rscript -e 'remotes::install_github(c(
  "r-data-science/rdstools",
  "artalytics/artutils",
  "artalytics/artcore",
  "RinteRface/shinyNextUI"
))'

# 11. Install TinyTeX (ensures lualatex is available)
Rscript -e 'if (!requireNamespace("tinytex", quietly = TRUE)) install.packages("tinytex", repos = "https://cloud.r-project.org"); tinytex::install_tinytex()'

# 12. Confirmation message
echo "✅ CODEX environment setup complete!"
