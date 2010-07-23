\name{getbestchunksize}
\alias{getbestchunksize}
\title{
Calculate Optimal Size of Each Chunk of Data when Fitting Models
}
\description{
Reads in a small portion of the data and measures the amount of memory the 
portion occupies in R and then calculates the best size for each chunk 
based on available memory and additional overhead needed for calculations.
}
\usage{
getbestchunksize(filename, MemoryAllowed = 0.5, TestedRows = 1000, AdjFactor = 0.095, silent = TRUE)
}
\arguments{
  \item{filename}{
The name of the file being chunked
}
  \item{MemoryAllowed}{
The maximum amount of memory,in gigabytes, that you want allowed by the R process 
on the current system or OS.  The recommend setting is 0.5-1.0 Gb. Please see the 
CRAN website for inherent limits to memory on various versions of R.
}
  \item{TestedRows}{
Number of rows to read in for determining optimal chunksize.  On thousand is set 
by default
}
  \item{AdjFactor}{
Adjustment factor to account for overhead of processes during fitting.  Increase 
factor to increase the memory used.  By default, the factor is 0.095.
}
  \item{silent}{
Set silent=TRUE to suppress most messages from function.
}
}
\details{
}
\value{
Returns the optimal chunksize as the number of lines to read each iteration.
}
\references{
}
\author{
Alan Lee
\email{alanlee@stanfordalumni.org}
}
\note{
}


\seealso{
}
\examples{
#Get external data.  For your own data skip this next line and replace all
#instance of SampleData with "YourFile.csv".
SampleData=system.file("extdata","SampleDataFile.csv", package = "allan")

#To get optimal chunksize for up to 1 Gb of allowable ram use for R while
#testing memory use by reading 1000 rows of current dataset and suppressing
#some output.
currentchunksize<-getbestchunksize(SampleData,MemoryAllowed=1 ,TestedRows=1000,silent=FALSE)


## The function is currently defined as
getbestchunksize<-function(filename,MemoryAllowed=0.5,TestedRows=1000,AdjFactor=0.095,silent=TRUE){
	#Function that tests data size and adjusts memory for best chunking of large dataset
	#This is done by reading in a number of rows(1000 by default)and then measuring the size of the memory
	#used.  Memory allwed is specified in Gb.  The adjfactor is a factor used to adjust memory for overhead
	#in the biglm fitting functions.
  
	#get column names	
	columnnames<-names(read.csv(filename, nrows=2,header=TRUE))
	#read in rows and test size
	datapreview<-read.csv(filename, nrows=TestedRows,header=TRUE)
	datamemsize<-object.size(datapreview)
	optimalchunksize=floor(((MemoryAllowed*1000000000)/datamemsize[1])*TestedRows *AdjFactor)
	if (silent!=TRUE){
		print("Total memory usage for 1000 lines:")
		print(datamemsize)
		print("Chunksize for dataframe after adjustment factor:")
		print(optimalchunksize)
	}
	return(optimalchunksize)
}

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ linear }
\keyword{ regression }
\keyword{ memory }
\keyword{ chunk }
\keyword{ chunksize }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
