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

# Export default environment settings (can be overridden)
export ART_RUN_AS_DEMO="${ART_RUN_AS_DEMO:-FALSE}"
export ART_USE_PG_CONF="${ART_USE_PG_CONF:-artprod}"

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

# 8. Install pak for fast parallel installs
Rscript -e 'install.packages("pak", repos = "https://cloud.r-project.org")'

# 9. Use pak to install all core Artalytics packages in parallel
Rscript -e 'pak::pkg_install(c(
  "r-data-science/rdstools",
  "r-data-science/rpgconn",
  "artalytics/artcore",
  "artalytics/artutils",
  "artalytics/artbenchmark",
  "artalytics/artopenai",
  "artalytics/artopensea",
  "artalytics/pixelsense",
  "artalytics/artpipelines"
))'

# 10. Automate rpgconn configuration. Automate rpgconn configuration
mkdir -p "$HOME/.rpgconn"
cat > "$HOME/.rpgconn/config.yml" <<EOF
config:
  artprod:
    host: "artalytics.app"
    port: 5432
    user: "shiny"
    password: !expr Sys.getenv("ART_PG_USER_PASSWD_PRD")
EOF

# 11. Install minimal LaTeX system packages based on certificate.tex requirements
sudo apt-get install -y --no-install-recommends \
  texlive-latex-base \
  texlive-latex-extra \
  texlive-fonts-recommended \
  texlive-luatex \
  latexmk

# 12. Install R tinytex wrapper via Debian package (no extra TeX libs)
sudo apt-get install -y --no-install-recommends r-cran-tinytex

# 13. Confirmation message
echo "✅ CODEX environment setup complete!" C

