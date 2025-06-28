# main_script71.R


# Make sure working directory is the same as the script location (implicitly handled in GitHub Actions)
# Print working directory
cat("Working directory:", getwd(), "\n")

# Set up and confirm output folder
output_dir <- file.path(getwd(), "outputs/script71")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
cat("Created directory:", output_dir, "\n")

# Confirm contents before saving
print("Files in 'outputs' before saving:")
print(list.files("outputs", recursive = TRUE))

# Save dummy test file just to verify
writeLines("test", file.path(output_dir, "test.txt"))




# Load the helper script
source("RD_and_DT_Algorithm_copy.R")  # Ensure this file is in the same directory

lambda <- 2


cost <- 7


results_3 <- data.frame(
  Run = integer(),
  C = numeric(),
  Length = numeric(),
  Cost = numeric(),
  NumDisambigs = integer(),
  N = integer()
)



for (i in 1:100) {
  set.seed(200+i)
  obs_gen_para <- c(gamma = 0.3, d = 5, noPoints = 150, no_c = 75, no_o = 75)
  result <- ACS_Alg_M(obs_gen_para, kei = 5, lambda, cost)
  
  results_3[i, ] <- list(
    Run = i,
    C = cost,
    Length = result$Length_total,
    Cost = result$Cost_total,
    NumDisambigs = length(result$Disambiguate_state),
    N = 75
  )
}

saveRDS(results_3, file.path(output_dir, "data_25_1_3.rds"))





results_4 <- data.frame(
  Run = integer(),
  C = numeric(),
  Length = numeric(),
  Cost = numeric(),
  NumDisambigs = integer(),
  N = integer()
)



for (i in 1:100) {
  set.seed(300+i)
  obs_gen_para <- c(gamma = 0.3, d = 5, noPoints = 200, no_c = 100, no_o = 100)
  result <- ACS_Alg_M(obs_gen_para, kei = 5, lambda, cost)
  
  results_4[i, ] <- list(
    Run = i,
    C = cost,
    Length = result$Length_total,
    Cost = result$Cost_total,
    NumDisambigs = length(result$Disambiguate_state),
    N = 100
  )
}

saveRDS(results_4, file.path(output_dir, "data_25_1_4.rds"))












# Combine all results into one table
results <- rbind(results_3, results_4)

# Format output
results_out <- data.frame(
  Index = paste0('"', 1:nrow(results), '"'),  # Quoted index
  results[, c("C", "Length", "Cost", "NumDisambigs", "N")]  # Make sure column names match
)

# Define the custom header (space-separated, quoted)
header <- '"C" "length" "cost" "number_of_disambiguations" "n"'

# Define output path
txt_path <- file.path(output_dir, "results_ACS1_mixed.txt")

# Write header manually
writeLines(header, txt_path)

# Append data
write.table(
  results_out,
  file = txt_path,
  append = TRUE,
  row.names = FALSE,
  col.names = FALSE,
  quote = FALSE,
  sep = " "
)

cat("✅ Text results saved to:", txt_path, "\n")
