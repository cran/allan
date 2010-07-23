\name{allan-package}
\alias{allan-package}
\alias{allan}
\docType{package}
\title{
Automated Large Linear Analysis Node
}
\description{
Builds on biglm package to automate fitting of linear models with data 
that do not fit into R memory.  Also includes a forward step variable
selection routine.  None of the functions are bounded by the size of the
training or validation datasets.  Requires biglm package.
}
\details{
\tabular{ll}{
Package: \tab allan\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2010-06-15\cr
License: \tab What license is it under?\cr
LazyLoad: \tab yes\cr
}
The main functions that the user will use are fitvbiglm, predictvbiglm, and 
allanVarSelect.  The fitvbiglm function fits a biglm object to a specified 
training dataset of any size.  The predictvbiglm function returns the AIC, 
BIC, and MSE of a linear model on a specified validation dataset.  The 
allanVarselect function takes a biglm object and performs forward stepwise 
variable selection and returns the fitted model.
}
\author{
Alan Lee
\email{alanlee@stanfordalumni.org}


Maintainer:
Alan Lee
\email{alanlee@stanfordalumni.org}
}
\references{
biglm package.
}
\keyword{ package }
\keyword{ linear }
\keyword{ regression }
\keyword{ selection }
\keyword{ memory }
\keyword{ unbounded }
\keyword{ large }
\seealso{

}
\examples{
#Get external data.  For your own data skip this next line and replace all
#instance of SampleData with "YourFile.csv".
SampleData=system.file("extdata","SampleDataFile.csv", package = "allan")

#get column names of dataset
columnnames<-names(read.csv(SampleData, nrows=2,header=TRUE))

#use the readinbigdata function to grab a small portion of the data
datafunction<-readinbigdata(SampleData,chunksize=1000,col.names=columnnames)

#initialize dataset and set to first line with TRUE
datafunction(TRUE)

#assign a small chunk to a dataset to create a biglm object
smallchunk<-datafunction(FALSE)

#fit a biglm object with all variables being considered for model
bigmodel <- biglm(PurePremium ~ cont1 + cont2 + cont3 + cont4 + cont5,data=smallchunk,weights=~cont0)

#perform var selection and look for best 3 variables using MSE as a metric.  You
#should use a different file for validation but for simplicity here we use same.
bestmodel<-allanVarSelect(bigmodel,SampleData,SampleData,NumOfSteps=3,criteria="MSE",silent=FALSE)

#just for fun, fit the full model again
bestmodelagain<-fitvbiglm(bigmodel,SampleData)


}
