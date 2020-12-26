zipFile <- "exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("Data/household_power_consumption.txt")) {
    dataURL <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
    download.file(dataURL, zipFile, mode = "wb")
    unzip(zipFile, files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, exdir = "Data", unzip = "internal", setTimes = FALSE)
    file.remove(zipFile)
}

# Define Directory where File is located
dirName <- 'Data'

# load power consumption data
fileName = "household_power_consumption.txt"
fileNamePower <- file.path(dirName, fileName)

data <- read.table(file = fileNamePower, header = TRUE, sep = ';')

# subset data set
data <- subset(data, Date == '1/2/2007' | Date == '2/2/2007')

# Convert some features to numeric features
ColNames <- names(data[3:9])
numericList <- c(ColNames)
data[, numericList] <- lapply(data[, numericList], function(x) as.numeric(as.character(x)))

# Merge date & time into single column
dateTime <- as.POSIXct(paste(data$Date, data$Time, sep = ";"), format = "%d/%m/%Y;%H:%M:%S")
data <- cbind("DateTime" = dateTime, data)
data$Date <- NULL
data$Time <- NULL
remove(dateTime)

# ========================================================================================================================================
# Create and plot graph
# ========================================================================================================================================

# Plot graph
png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")

par(mfrow = c(2, 2))

# Add plot 1 to top, left
plot(data$DateTime, data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")

# Add plot 2 to top, right
plot(data$DateTime, data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

# Add plot 3 to bottom, left
plot(data$DateTime, data$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")
lines(data$DateTime, data$Sub_metering_2, type = "l", col = "red")
lines(data$DateTime, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1, 1, 1), bty = 'n', col = c("black", "red", "blue"))

# Add plot 3 to bottom, right
plot(data$DateTime, data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power", lwd = 0.5)

dev.off()
