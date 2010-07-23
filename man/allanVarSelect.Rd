\name{allanVarSelect}
\alias{allanVarSelect}
\title{
Memory Unlimited Forward Stepwise Variable Selection for Linear Models 
}
\description{
The function performs forward stepwise variable selection for linear models
on any sized dataset, even if it does not fit into R memory.  AIC, BIC, and MSE
are the available criteria for variable selection.  The variable that minimizes
these metrics is selected each step until the specified number of variables are
entered into the model.  The selection starts with a NULL model and adds variables.
}
\usage{
allanVarSelect(BaseModel, TrnDataSetFile, ValDataSetFile, ResponseCol = 1, NumOfSteps = 10, criteria = "AIC", currentchunksize = -1, silent = TRUE, MemoryAllowed = 0.5, TestedRows = 1000, AdjFactor = 0.095)
}
\arguments{
  \item{BaseModel}{
A biglm object that has a formula that specifies the full model with all variables
being considered for selection.  ie.  y ~ x1+x2+x3+.... etc.  In order to get a biglm
object to pass, you will need to create a biglm model on a small subsection of the 
dataset if the dataset cannot fit into R memory.  Note:  Offsets should be specified
with an offset option instead of included in the model formula.  Otherwise an error 
may result.
}
  \item{TrnDataSetFile}{
The training dataset that the BaseModel will be trained on.  Unlimited by size.
}
  \item{ValDataSetFile}{
The validation dataset that the BaseModel will be validated on.  AIC, BIC, and MSE will
be calculated from this dataset to select variables.  Unlimited by size.
}
  \item{ResponseCol}{
The column that the y or response variable is in in the dataset.  Training, validation,
as well as the smaller data chunk that the passed biglm object was initially fit on must
all have the same format ie. same variables and columns.
}
  \item{NumOfSteps}{
Number of variables to enter into the final fitted model.
}
  \item{criteria}{
criteria for variable selection.  "AIC","BIC", or "MSE" can be chosen
}
  \item{currentchunksize}{
See documentation for getbestchunksize.
}
  \item{silent}{
Boolean.  Suppresses unnecessary output to screen if silent=TRUE.
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
Returns the final fitted biglm object with the final number of variables
specified.  The selection statistics is saved in the object under
$SelectionSummary.
}
\references{
}
\author{
Alan Lee
\email{alanlee@stanfordalumni.org}
}
\note{
Offsets should be specified with the offset option and not placed in the 
model formula to avoid errors.
}


\seealso{
}
\examples{
#Get external data.  For your own data skip this next line and replace all
#instance of SampleData with "YourFile.csv".
SampleData=system.file("extdata","SampleDataFile.csv", package = "allan")

#fit smaller data to biglm object
columnnames<-names(read.csv(SampleData, nrows=2,header=TRUE))
datafeed<-readinbigdata(SampleData,chunksize=1000,col.names=columnnames)
datafeed(TRUE)
firstchunk<-datafeed(FALSE)

#create a biglm model from the small chunk with all variables that will be consdered
#for variable selection.
bigmodel <- biglm(PurePremium ~ cont1 + cont2 + cont3 + cont4 + cont5,data=firstchunk,weights=~cont0)

#now run variable selection
FinalModel<-allanVarSelect(bigmodel,SampleData,SampleData,NumOfSteps=2,criteria="MSE",silent=FALSE)




}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ stepwise }
\keyword{ linear }
\keyword{ regression }
\keyword{ memory }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
