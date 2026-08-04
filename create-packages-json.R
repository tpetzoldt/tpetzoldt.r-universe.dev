library(jsonlite)

# 1. Packages maintained by Thomas Petzoldt (CRAN + GitHub dev repos)
maintained_pkgs <- data.frame(
  package = c("deSolve",
              "growthrates",
              "simecol",
              "cardidates",
              "qualV",
              "FAmle",
              "FAdist",
              "antibioticR",
              "biblioview",
              "salmoRodeo"),
  url     = c("https://github.com/tpetzoldt/deSolve",
              "https://github.com/tpetzoldt/growthrates",
              "https://github.com/tpetzoldt/simecol",
              "https://github.com/r-forge/cardidates",
              "https://github.com/r-forge/qualV",
              "https://github.com/tpetzoldt/FAmle",
              "https://github.com/tpetzoldt/FAdist",
              "https://github.com/tpetzoldt/antibioticR",
              "https://github.com/tpetzoldt/biblioview",
              "https://github.com/tpetzoldt/salmoRodeo"),
  subdir  = c(NA_character_, 
              NA_character_, 
              NA_character_, 
              "pkg/cardidates", 
              "pkg/qualV", 
              NA_character_, 
              NA_character_, 
              NA_character_, 
              NA_character_,
              NA_character_),
  role    = "maintainer",
  status  = c("release", "release", "release", "release", "release", "release", "release", "dev", "dev", "dev"),
  on_cran = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE),
  stringsAsFactors = FALSE
)

# 2. Co-authored / Contributed packages (not maintained by you on CRAN)
coauthored_pkgs <- data.frame(
  package = c("FME",
              "marelac",
              "proto"),
  url     = c("https://github.com/r-forge/FME",
              "https://github.com/r-forge/marelac",
              "https://github.com/hadley/proto"),
  subdir  = c("pkg/FME", "pkg/marelac", NA_character_),
  role    = "co-author",
  status  = "release",
  on_cran = TRUE,
  stringsAsFactors = FALSE
)

# 3. Combine and sort alphabetically
combined_df <- rbind(maintained_pkgs, coauthored_pkgs)
combined_df <- combined_df[!duplicated(combined_df$package), ]
combined_df <- combined_df[order(combined_df$package), ]

# 4. Format into clean list structure (removes NA 'subdir' entries)
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

# 5. Export to packages.json
writeLines(
  toJSON(pkg_list, pretty = TRUE, auto_unbox = TRUE), 
  "packages.json"
)