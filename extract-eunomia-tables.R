library(Eunomia)

exportFolder <- "/Users/erikwestlund/code/ohdsi-test-data/data/eunomia";
options(scipen=9999)
Eunomia::exportToCsv(outputFolder = exportFolder);

copyCommands <- lapply(gsub(pattern = "\\.csv$", "", list.files(exportFolder)), function(file) {
  return (paste0("TRUNCATE TABLE cdm.", file, ";\nCOPY cdm.", file, " FROM '", paste0(exportFolder, "\\", file, sep=""), ".csv' DELIMITER ',' CSV HEADER NULL AS '';"))
})

cat(paste0(copyCommands, collapse="\n"))