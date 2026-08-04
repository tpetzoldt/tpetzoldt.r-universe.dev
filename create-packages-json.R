library(jsonlite)

username <- "tpetzoldt"

# 1. Fetch current universe packages (e.g. your active CRAN packages)
pkgs <- fromJSON(sprintf("https://%s.r-universe.dev/api/packages", username))

registered_pkgs <- data.frame(
  package = pkgs$Package,
  url     = pkgs$RemoteUrl,
  subdir  = NA_character_,
  role    = "maintainer",
  status  = "release",
  on_cran = TRUE,
  stringsAsFactors = FALSE
)

# 2. Define additional packages (GitHub + R-Forge maintainer repos)
additional_pkgs <- data.frame(
  package = c("antibioticR", 
              "biblioview"),
  url     = c("https://github.com/tpetzoldt/antibioticR", 
              "https://github.com/tpetzoldt/biblioview"),
  subdir  = c(NA_character_, NA_character_),
  role    = c("maintainer", "maintainer"),
  status  = c("dev", "dev"),
  on_cran = c(FALSE, FALSE),
  stringsAsFactors = FALSE
)

# 3. Define co-authored / contributed packages
coauthored_pkgs <- data.frame(
  package = c("FME",
              "marelac",
              "proto"),
  url     = c("https://github.com/r-forge/FME",
              "https://github.com/r-forge/marelac",
              "https://github.com/hadley/proto"),
  subdir  = c("pkg/FME", "pkg/marelac", NA_character_),
  role    = c("co-author", "co-author", "co-author"),
  status  = c("release", "release", "release"),
  on_cran = c(TRUE, TRUE, TRUE),
  stringsAsFactors = FALSE
)

# 4. Combine and remove duplicates (keeps the first occurrence)
combined_df <- rbind(registered_pkgs, additional_pkgs, coauthored_pkgs)
combined_df <- combined_df[!duplicated(combined_df$package), ]
combined_df <- combined_df[order(combined_df$package), ]

# 5. Format into a clean list structure (removes NA 'subdir' entries, retains metadata)
pkg_list <- lapply(seq_len(nrow(combined_df)), function(i) {
  item <- list(
    package = combined_df$package[i],
    url     = combined_df$url[i],
    role    = combined_df$role[i],
    status  = combined_df$status[i],
    on_cran = combined_df$on_cran[i]
  )
  if (!is.na(combined_df$subdir[i])) {
    item$subdir <- combined_df$subdir[i]
  }
  return(item)
})

# 6. Write to packages.json
writeLines(
  toJSON(pkg_list, pretty = TRUE, auto_unbox = TRUE), 
  "packages.json"
)