log.data <- read.csv("data/log.csv", sep = ";",
                     stringsAsFactors = FALSE)

log.data.split <- split(log.data, log.data[["Unique.Vector.ID"]])

types.data <- read.csv("data/types.csv", sep = ";")

types.data.split <- split(types.data, types.data[["Type"]])

listChoices <- as.list(as.numeric(names(log.data.split)))
names(listChoices) <- names(log.data.split)

log.data.split.timestamps <- lapply(log.data.split, 
                    function(x) as.POSIXct(strptime(x[["Timestamp"]], 
                                    format = "%Y-%m-%dT%H:%M:%OS")))

log.data.split.timestamps.limits <- lapply(log.data.split.timestamps, 
                                          function(x) c(min(x), max(x)))