\name{readinbigdata}
\alias{readinbigdata}
\title{ Create a Connection to Very Large Datasets for Linear Model Fitting  
}
\description{ 
   This function opens a connection to a dataset.  It is typically 
used when the dataset used for fitting is too large to reside in R 
memory.  Does not necessarily need to be used by end-user.
}
\usage{
readinbigdata(filename, chunksize, ...)
}
\arguments{
  \item{filename}{
The name of the file that is being connected to.
}
  \item{chunksize}{
The size of each chunk that will be read into memory at a time when 
fitting models.  Default is -1 which means that the chunk will be determined
by the function getbestchunksize.
}
  \item{\dots}{
Primarily used to pass col.names option to internal functions.
}
}
\details{
This function does not need to be called by end-user.  It is called everytime 
a model needs to be fit by the main workhorse fitting routines.
}
\value{
Returns a function that passes the next set of lines of data when the argument is 
FALSE and resets to the beginning of the file when the Argument is TRUE.  The function
passed also give NULL when the end of the file has been reached.
}
\references{
Most of the function was taken from the example given in the biglm package.
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

datafeed<-readinbigdata(SampleData,chunksize=1000,col.names=columnnames)

## The function is currently defined as
readinbigdata<-function(filename, chunksize,...){
	#This function sets a connection to the large dataset with the specified chunksize.
	#The return value is either the next chunk of data or NULL if there is no additional data left.
	#Additionally if a reset=TRUE flag is passed, then the data stream goes back to the beginning.
	#This was originally done to accommodate the bigglm data function option
	#Taken mostly from help from biglm package

	#initialize connection
	conn<-NULL
	function(reset){
		if(reset){
			if(!is.null(conn)) close(conn)
			conn<<-file (description=filename, open="r")
			#print("new connection open")
		} else{
			#make sure header isn't read for other cases and assign next block of data
			rval<-read.csv(conn, nrows=chunksize,header=FALSE,skip=1,...)
			
			#print("rows processed")
			#print(dim(rval))
			
			if (nrow(rval)==0) {
				close(conn)
				conn<<-NULL
				rval<-NULL
				#print("end of file reached")
			}
			#print(reset)
			#print(dim(rval))
			return(rval)
		}
	}
}

}
\keyword{ chunk }
\keyword{ linear }
\keyword{ regression }
\keyword{ memory }

