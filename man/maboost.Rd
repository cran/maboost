\name{maboost}
\alias{maboost}
\alias{maboost.default}
\alias{maboost.formula}
\alias{maboost.machine.bin}
\alias{maboost.machine.mult}
\title{
Binary and Multiclass Boosting Algorithms
}

\description{
\sQuote{maboost} is used to fit a variety of stochastic boosting models for binary and multiclass responses 
as described in \emph{A Boosting Framework on Grounds of Online Learning} by T. Naghibi and B. Pfister, (2014).
}
\usage{
maboost(x,...)
\method{maboost}{default}(x, y,test.x=NULL,test.y=NULL,breg=c("entrop","l2")
,type=c("normal","maxmargin","smooth","sparse"),C50tree=FALSE,iter=100, nu=1
,bag.frac=0.5,random.feature=TRUE,random.cost=TRUE,smoothfactor=1
,sparsefactor=FALSE,verbose=FALSE,\dots,na.action=na.rpart)
           
\method{maboost}{formula}(formula, data, \dots, subset, na.action=na.rpart)

}

\arguments{
   \item{x}{matrix of descriptors.}
  \item{y}{vector of responses (class labels).}
  \item{formula}{a symbolic description of the model to be fit.}
  \item{data}{dataframe containing variables and a column corresponding to class labels.}
  \item{test.x}{testing matrix of discriptors (optional)}
  \item{test.y}{vector of testing responses (optional)}
  \item{breg}{ \code{breg="l2"} (default) selects quadratic Bregman divergence and \code{breg="entrop"} uses KL-divergence which results in a adaboost-like algorithm (with a different choice of eta).}
  \item{type}{determine the type of the algorithm to be used. Default is running the algorithm in the normal mode. \code{type="maxmargin"}: it guarantees that the margin of the final hypothesis converges to max-margin (at each round t, it divides eta by t^.5). \code{type="sparse"}: It uses SparseBoost and only works with \code{breg="l2"}. It generates sparse weight vectors by projecting the weight vectors onto R+. It can be used for multiclass but it is kind of meaningless since the multiclass setting uses a weight matrix instead of weight vector and increasing the sparsity of this matrix does not result in the sparsity of the weight vector (which is the sum over col. of the weight matrix). \code{type="smooth"}: flag to start smooth boosting. Only works for \code{breg="l2"} and for binary classification. Note that for \code{type="smooth"}, smoothfactor parameter should also be set, accordingly}
  \item{C50tree}{flag to use C5.0 as the weak classifier. It is only recommended for multiclass setting where rpart maybe too weak to satisfy boostability condition. If it is used, don't forget to set the \code{CF} and \code{minCases} parameters in C50Control properly}
  \item{iter}{number of boosting iterations to perform.  Default = 100.}
  \item{nu}{shrinkage parameter for boosting, default taken as 1. It is multiplied in eta and controls its largeness. Note that in the case of using sparseboost, nu can also be increased to enhance sparsity, at the expense of increasing the risk of divergence}
  \item{bag.frac}{sampling fraction for samples taken out-of-bag.  This allows one
                  to use random permutation which improves performance.}
  \item{random.feature}{flag to grow a random forest type trees.  If TRUE, at each round a small set of features (num_feat^.5) are selected to grow a tree. It generally speeds up the convergence specially for large data sets and improves the performance.}
  \item{random.cost}{flag to assign random costs to selected features. By assigning random costs (look at cost in rpart.control) to the selected features (if random.forest=TRUE) it tries to decorrelates the trees and usually in combination with random.feature it improves the generalization error.}
  \item{smoothfactor}{an integer between 1 to N (number of examples in data) and have to be set if smooth is TRUE. If smoothfactor=K then examples weights are <=1/K and the final error is <K/N}
  \item{sparsefactor}{ When it is true, an explicit l1 norm regularization term is used in the projection step of the algorithm (see [1]) to enhance the sparsity. Default is FALSE to guarantee the convergence of the Sparseboost algorithm. Note that, this parameter can also be set to a numeric value which is directly multiplied in the l1-norm regularization factor (see def. of alpha in [1]). }
  \item{verbose}{flag to output more details about internal parameters, error, num_zero, sum of weights, eta (classifeir coefficient) and max of weights, at each round of boosting. Default is FALSE}
   \item{subset}{an optional vector specifying a subset of observations to be used in the fitting process.}
  \item{na.action}{a function that indicates how to process \sQuote{NA} values.  Default=na.rpart for rpart and na.pass for C5.0.}
  \item{\dots}{arguments passed to \code{rpart.control} and \code{C50Control}.  For stumps, use \code{maxdepth=1,cp=-1,minsplit=0,xval=0}.
             \code{maxdepth} controls the depth of trees, and \code{cp}
	     controls the complexity of trees. For C5.0 use \code{CF,minCases} control the complexity and size of the tree. The smaller the \code{CF} is, the less complex the tree and the larger the \code{minCases}, the smaller the size of the C5.0 tree }
}

\details{
This function directly follows the algorithms listed in \emph{\dQuote{Boosting on Grounds of Online Learning}}.

When using usage \sQuote{maboost(y~.)}:
  data must be in a data frame.  Response can have factor or numeric values (preferably factor form).
  missing values can be present in the descriptor data, whenever
  na.action is set to any option other than na.pass.
    
After the model is fit, \sQuote{maboost} prints 
  a summary of the function call, 
  the method used for boosting, 
  the number of iterations,
  the final confusion matrix (observed classification vs predicted classification; 
  labels for classes are same as in response),  
  the error for the training set, and testing, training , and kappa estimates of the 
  appropriate number of iterations.

  A summary of this information can also be obtained with the command \sQuote{print(x)}.

  Corresponding functions (Use help with summary.maboost, predict.maboost, \dots
  varplot.maboost for additional information on these commands):

  summary :  function to print a summary of the original function call, method
                 used for boosting, number of iterations, final confusion matrix,
                 accuracy, and kappa statistic (a measure of agreement between
                 the observed classification and predicted classification).
                 \sQuote{summary} can be used for training, testing, or
		 validation data.  
		 

  predict :  function to predict the response for any data set (train,
  test, or validation)

  
  varplot.maboost :  plot of variables ordered by the variable importance measure (based on improvement).

 
  update : add more trees to the \code{maboost} object.
}

\value{
  \item{model}{
    The following items are the different components created by the algorithms:
    trees:  ensemble of rpart or C5.0 trees used to fit the model
    alpha:  the weights of the trees used in the final aggregate model
    F    :  F[[1]] corresponds to the training sum, F[[2]]], \dots corresponds to
            testing sums.
   errs  :  matrix of errs, training, kappa, testing 1, kappa 1, \dots
   lw    :  last weights calculated, used by update routine
   num_zero: a vector of length iter containing the number of zeros in the weight vector at each round.
  }
  \item{fit}{
    The predicted classification for each observation in the original level of the response.
  }
  \item{call}{
    The function call.
  }
  \item{nu}{shrinkage parameter}
  \item{breg}{
    The type of maboost performed:  \sQuote{"l2"}, \sQuote{"entrop"}.
  }
  \item{confusion}{
    The confusion matrix (True value vs. Predicted value) for the training data.
  }
  \item{iter}{
    The number of boosting iterations that were performed.
  }
  \item{actual}{
    The original response vector.
  }
}
 
\references{
  [1] Naghibi, T., Pfister, B. (2014). \emph{A Boosting Framework on Grounds of Online Learning.} 
    NIPS.

 [2] Culp, M., Johnson, K., Michailidis, G. (2006). \emph{maboost: an R Package
    for Stochastic Boosting} Journal of Statistical Software, 16.
}

\author{
Tofigh Naghibi, ETH Zurich

Special thanks to Dr. Mark Culp and his colleagues who developed the 'ada' package. A big part of this package has been built upon their code. In particular, summary, print and varplot.maboost functions are imported from 'ada' package with almost no changes. For further info about 'ada' which implements different variations of Anyboost, look at [2]
}

\section{Warnings}{
  (a) Choose type="normal" or "maxmargin" for multiclass classification. SmoothBoost do not work in multiclass setting and SparseBoost does not make sense to be used for multiclass classification (where we have to deal with a weight matrix rather than a weight vector).
  
  (b) cost variable in rpart.control is the only variable in rpart.control that CANNOT be set through maboost. It is reserved for random.cost.
 }

\seealso{
  \code{\link{print.maboost}},\code{\link{summary.maboost}},\code{\link{predict.maboost}} ,\code{\link{update.maboost}},\code{\link{varplot.maboost}}
}

\examples{
## fit maboost model
data(iris)
##drop setosa
iris[iris$Species!="setosa",]->iris
##set up testing and training data (60\% for training)
n<-dim(iris)[1]
trind<-sample(1:n,floor(.6*n),FALSE)
teind<-setdiff(1:n,trind)
iris[,5]<- as.factor((levels(iris[,5])[2:3])[as.numeric(iris[,5])-1])
##fit a tree with maxdepth=6 (a variable pass to rpart.control). 
gdis<-maboost(Species~.,data=iris[trind,],iter=50,nu=2
                   ,breg="l2", type="sparse",bag.frac=1,random.feature=FALSE
                   ,random.cost=FALSE, C50tree=FALSE, maxdepth=6,verbose=TRUE)
##to see the average zeros in the weighting vectors over the 40 rounds of boosting
print(mean(gdis$model$num_zero))
##prediction
pred.gdis= predict(gdis,iris,type="class");
##variable selection
varplot.maboost(gdis)
}

\keyword{classes}
\keyword{models}
\keyword{methods}


