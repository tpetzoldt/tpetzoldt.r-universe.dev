library(jsonlite)

username <- "tpetzoldt"

# 1. Fetch current universe packages (e.g. your active CRAN packages)
pkgs <- fromJSON(sprintf("https://%s.r-universe.dev/api/packages", username))

registered_pkgs <- data.frame(
  package = pkgs$Package,
  url     = pkgs$RemoteUrl,
  subdir  = NA_character_,
  stringsAsFactors = FALSE
)

# 2. Define additional packages (GitHub + R-Forge)
additional_pkgs <- data.frame(
  package = c("antibioticR", 
              "biblioview", 
              "growthrates",
              "cardidates",
              "qualV",
              "FME",
              "marelac"),
  url     = c("https://github.com/tpetzoldt/antibioticR", 
              "https://github.com/tpetzoldt/biblioview", 
              "https://github.com/markvanderloo/growthrates",
              "https://github.com/r-forge/cardidates",
              "https://github.com/r-forge/qualV",
              "https://github.com/r-forge/FME",
              "https://github.com/r-forge/marelac"
              ),
  subdir  = c(rep(NA, 3), "pkg/cardidates", "pkg/qualV", "pkg/FME", "pkg/marelac"),
  stringsAsFactors = FALSE
)

coauthored_pkgs <- data.frame(
  package = c("proto"),
  url     = c("https://github.com/hadley/proto"), # Or official repo / CRAN mirror
  subdir  = NA,
  stringsAsFactors = FALSE
)

# 3. Combine and remove duplicates (keeps the first occurrence)
combined_df <- rbind(registered_pkgs, additional_pkgs, coauthored_pkgs)
combined_df <- combined_df[!duplicated(combined_df$package), ]
combined_df <- combined_df[order(combined_df$package), ]

# 4. Format into a clean list structure (removes 'subdir: null' entries)
pkg_list <- lapply(seq_len(nrow(combined_df)), function(i) {
  item <- list(
    package = combined_df$package[i],
    url     = combined_df$url[i]
  )
  if (!is.na(combined_df$subdir[i])) {
    item$subdir <- combined_df$subdir[i]
  }
  return(item)
})

# 5. Write to packages.json
writeLines(
  toJSON(pkg_list, pretty = TRUE, auto_unbox = TRUE), 
  "packages.json"
)
