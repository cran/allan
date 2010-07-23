\name{predictvbiglm}
\alias{predictvbiglm}
\title{
Generates Predictions and Fitting Statistics for biglm object
}
\description{
Generates prediction statistics on a validation file and returns data frame of results.
For actual predictions, use the biglm predict function.
}
\usage{
predictvbiglm(BaseModel, ValFileName, currentchunksize = -1, ResponseCol = 1, silent = TRUE, MemoryAllowed = 0.5, TestedRows = 1000, AdjFactor = 0.095)
}
\arguments{
  \item{BaseModel}{
BaseModel is a biglm object.  Must have a formula in the biglm object that specifies
the model ie. y~x1 + x2  etc.  
}
  \item{ValFileName}{
Validation filename.  Can be any size.  This is what is used to calculate AIC,BIC, 
or MSE and other statistics. 
}
  \item{currentchunksize}{
Allows user to specify the size of chunking.  default is -1 for automatically
determining the size by use of getbestchunksize function
}
  \item{ResponseCol}{
The column that the y or response variable is in in the dataset.  Training, validation,
as well as the smaller data chunk that the passed biglm object was initially fit on must
all have the same format ie. same variables and columns.
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
Returns a data frame that contains the AIC,BIC, and MSE of the model
on the specified validation or ValFileName file. 
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

#now use predictvbiglm to get metric results
metricresults<-predictvbiglm(finalbigmodel,SampleData,ResponseCol=1)


## The function is currently defined as
predictvbiglm<-function(BaseModel,ValFileName,currentchunksize=-1,ResponseCol=1,silent=TRUE,MemoryAllowed=0.5,TestedRows=1000,AdjFactor=0.095){
	#This function takes a biglm object and makes predictions as well as returns fit statistics 
	
	#get optimal chunksize if not specified
	if (currentchunksize==-1){
		currentchunksize<-getbestchunksize(ValFileName,MemoryAllowed=MemoryAllowed,TestedRows=TestedRows,AdjFactor=AdjFactor,silent=silent)

	}


	#get datafeed
	columnnames<-names(read.csv(ValFileName, nrows=2,header=TRUE))
	datafeed<-readinbigdata(ValFileName,chunksize=currentchunksize,col.names=columnnames)

	#initialize running total variables
	ObsVec<-NULL
	RSSVec<-NULL
	VarianceVec<-NULL
	MeanVec<-NULL
	Var1Vec<-NULL
	YValues<-NULL
	WeightVec<-NULL

	#fit first interation
	#use data grabbing function and initialize for first iteration
	datafeed(TRUE)
	#use predict for biglm to get predictions
	CurrentDataSet<-datafeed(FALSE)
	while (!is.null(CurrentDataSet)){
		Predictions<-predict(BaseModel,CurrentDataSet)
	
		#set current number of observations in current iteration
		CurrentNumObs=length(Predictions)

		#assign weight vector depending on whether weights have been specified
		#weights not assigned
		if (is.null(BaseModel$weights)){
			#assign weights as all same
			weightvector<-as.vector(matrix(1,CurrentNumObs,1))
		} 
		#weights assigned
		else{
			#parse name of weights
			weightname<-substr(BaseModel$weights,1,100)[2]
			#assign to weights
			weightvector<-as.vector(eval(parse(text=paste("CurrentDataSet","$",weightname,sep=""))))
		}

		#calculate mean, variance, and RSS for current chunk
		CurrentMean=weighted.mean(CurrentDataSet[,ResponseCol],weightvector)
		CurrentVariance=sum(((CurrentDataSet[,ResponseCol]-CurrentMean)^2)*weightvector)/sum(weightvector)
		CurrentRSS= sum(((Predictions-CurrentDataSet[,ResponseCol])^2)*weightvector)
		
		#store data for all chunks in vector for final calculation
		RSSVec<-c(RSSVec,CurrentRSS)
		MeanVec<-c(MeanVec,CurrentMean)
		VarianceVec<-c(VarianceVec,CurrentVariance)
		ObsVec<-c(ObsVec,CurrentNumObs)
		WeightVec<-c(WeightVec,weightvector)
		#for debugging save y values
		#YValues<-c(YValues,CurrentDataSet[,ResponseCol])
		
		#increment dataset feed connection to next chunk
		CurrentDataSet<-datafeed(FALSE)
	}

	#calculate total RSS mean and variance
	TotalRSS<-sum(RSSVec)
	TotalMean<-weighted.mean(MeanVec,ObsVec)
	TotalObs<-sum(ObsVec)
	MSEValue<-TotalRSS/sum(WeightVec)
		
	MeanVariance<-sum((MeanVec)^2*(ObsVec/TotalObs))-TotalMean^2
	TotalVariance<-sum((VarianceVec*ObsVec)/TotalObs)+MeanVariance
	#Calculate degrees of freedom: add all variables plus intercept if necessary
	NumParameters=attr(BaseModel$terms,"intercept")+length(attr(BaseModel$terms,"term.labels"))

	#Calculate likelihood and resulting measures
	LogLikelihood= (-TotalObs/2)*(log(2*pi*(TotalVariance^2)))-(1/2)*TotalRSS/(TotalVariance^2)
	AICValue=2*NumParameters-2*LogLikelihood
	BICValue=-2*LogLikelihood+NumParameters*log(TotalObs)
	#data frame with values
	metricvalues<-data.frame(AICValue,BICValue,MSEValue)
	#return metric for measuring model
	return(metricvalues)

}


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ predict }
\keyword{ linear }
\keyword{ regression }
\keyword{ memory }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
