\name{fitvbiglm}
\alias{fitvbiglm}
\title{
Automated Fitting of Biglm Object
}
\description{
Fits a biglm object on any sized dataset. Automatically chunks up the data and
returns a fitted biglm object on the entire dataset.
}
\usage{
fitvbiglm(BaseModel, filename, currentchunksize = -1, silent = TRUE, MemoryAllowed = 0.5, TestedRows = 1000, AdjFactor = 0.095)
}
\arguments{
  \item{BaseModel}{
BaseModel is a biglm object.  Must have a formula in the biglm object that specifies
the model ie. y~x1 + x2  etc.  
}
  \item{filename}{
Name of the training set file
}
  \item{currentchunksize}{
Allows user to specify the size of chunking.  default is -1 for automatically
determining the size by use of getbestchunksize function
}
  \item{silent}{
specify as TRUE to suppress all nonimportant messages by the function
}
  \item{MemoryAllowed}{
See function getbestchunksize for argument description.
}
  \item{TestedRows}{
See function getbestchunksize for argument description.
}
  \item{AdjFactor}{
See function getbestchunksize for argument description.
}
}
\details{
}
\value{
Returns a fitted biglm object.
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

#get smaller chunk of data to fit initial model
columnnames<-names(read.csv(SampleData, nrows=2,header=TRUE))
datafeed<-readinbigdata(SampleData,chunksize=1000,col.names=columnnames)
datafeed(TRUE)
firstchunk<-datafeed(FALSE)

#create a biglm model from the small chunk with all variables that will be consdered
#for variable selection.
bigmodel <- biglm(PurePremium ~ cont1 + cont2 + cont3 + cont4 + cont5,data=firstchunk,weights=~cont0)

#now fit the model on the humongous dataset
finalbigmodel<-fitvbiglm(bigmodel,SampleData)


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ linear }
\keyword{ regression }
\keyword{ memory }
\keyword{ fit }
