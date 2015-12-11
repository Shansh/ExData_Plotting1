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

# Print plot
png(filename="./data/plot1.png", 
    units="px", 
    width=480, 
    height=480, 
    pointsize=12, 
    res=72)
hist(data$Global_active_power, main = "Global active power", 
     xlab = "Global active power (kilowatts)", col = "red")
dev.off()