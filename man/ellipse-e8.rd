\name{ellipse}
\alias{ellipse}
\title{Create multivariate ellipse}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Randomly sample points from a probability contour of a multivariate normal
}
\usage{ellipse(data, npoints=1000, cl=0.95, mean=colMeans(data), cov=var(data), df=nrow(data))}
\arguments{
\item{data}{data frame or matrix}
\item{npoints}{number of points to sample}
\item{cl}{proportion of density contained within ellipse}
\item{mean}{mean vector}
\item{cov}{variance-covariance matrix}
\item{df}{degrees of freedom used for calculating F statistic}
}

\details{There are two ways to use this function.	You can either supply
a data set for which a multivariate normal ellipse will be drawn
or you can supply the mean vector, covariance matrix and number
of dimensions yourself.}

\examples{}
\keyword{internal}
