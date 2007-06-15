\name{cfly_animate}
\alias{cfly_animate}
\title{Dynamic plot: Animate glyph colours}
\author{Hadley Wickham <h.wickham@gmail.com>}

\description{
Animate glyph colours according to provided cluster ids.
}
\usage{cfly_animate(cf, i = 1:length(cf$clusters), pause = 1)}
\arguments{
\item{cf}{list of cluster ids that you want to animate across}
\item{i}{number of seconds to pause between each change}
\item{pause}{}
}

\details{This function will animiate endless until you manually break the loop
using Ctrl-Break or Ctrl-C.}

\examples{# Press Ctrl-Break or Ctrl-C to exit
\dontrun{cfly_animate(cfly_clarify(o))}}
\keyword{dynamic}
