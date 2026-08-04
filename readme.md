# Thomas Petzoldt's R-Universe Registry

https://tpetzoldt.r-universe.dev

This repository contains the configuration used by R-universe to build and host my R packages across CRAN, GitHub, and R-Forge.

## Package List

The complete set of tracked packages is defined in [packages.json](packages.json).

This configuration file is generated and updated using the script [create-packages-json.R](create-packages-json.R).

## How to Install Packages

To install packages primarily from CRAN, falling back to this universe for development versions or non-CRAN packages:

```r
options(repos = c(
  CRAN = "https://cloud.r-project.org",
  tpetzoldt = "https://tpetzoldt.r-universe.dev"
))

install.packages("package_name")
```

## Build Frequency

Package builds are triggered automatically roughly once every 24 hours or whenever changes are committed to this repository.
