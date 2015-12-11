library(sqldf)

# Download and unzip file
zip.file <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                          destfile = zip.file)
unzip (zip.file, exdir = "./data")
unlink(zip.file)

# Estimate the size of data file
top.size <- object.size(read.table("./data/household_power_consumption.txt", sep = ";", nrow=1000))
size.estimate <- top.size * 2075.259
size_mb <- paste("The dataset memory requrement estimation is", round(size.estimate/1024/1024, 2), "Mb")
print(size_mb)

# Read selected data from file
data <- read.csv.sql("./data/household_power_consumption.txt", 
         sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'",
         header = TRUE, sep = ";")
closeAllConnections()

# Replace '?' character with NA and check if there is any NA among data
data[data == "?"] = NA
sum(is.na(data))

# Create new POSIXct variable 'datetime'
data$datetime <- with(data, as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"))

# Print plot
png(filename="./data/plot3.png", 
    units="px", 
    width=480, 
    height=480, 
    pointsize=12, 
    res=72)
with(data, plot(datetime, Sub_metering_1, type="n", xlab = "", ylab = "Energy sum metering"))
with(data, points(datetime, Sub_metering_1, col = "black", type = "l"))
with(data, points(datetime, Sub_metering_2, col = "red", type = "l"))
with(data, points(datetime, Sub_metering_3, col = "blue", type = "l"))
legend("topright", lty=c(1,1), col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()