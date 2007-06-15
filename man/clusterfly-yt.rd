\name{clusterfly}
\alias{clusterfly}
\alias{package-clusterfly}
\title{Clustefly}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
This method creates a convenient data structure for dealing with a dataset and a number of alternative clusterings.
}
\usage{clusterfly(df, rescale=TRUE)}
\arguments{
\item{df}{data frame to be clustered}
\item{rescale}{rescale, if true each variable will be scaled to have mean 0 and variance 1.}
}

\details{Once you have created a clusterfly object, you can add
clusterings to it with \code{\link{cfly_cluster}}, and
visualise then in GGobi with \code{\link{cfly_show}} and
\code{\link{cfly_animate}}.	 Static graphics are also
available: \code{\link{cfly_pcp}} will produce a parallel
coordinates plot, \code{\link{cfly_dist}} will show
the distribution of each variable in each cluster, and
\code{\link{cfly_fluct}} compares two clusterings with a
fluctuation diagram.

If you want to standardise the cluster labelling to one
group, look at \code{\link{clarify}} and \code{\link{cfly_clarify}}}
\seealso{vignette("introduction")}
\examples{}
\keyword{dynamic}
