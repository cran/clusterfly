# Clustefly
# This method creates a convenient data structure for dealing with a dataset and a number of alternative clusterings.
# 
# Once you have created a clusterfly object, you can add 
# clusterings to it with \code{\link{cfly_cluster}}, and
# visualise then in GGobi with \code{\link{cfly_show}} and
# \code{\link{cfly_animate}}.	 Static graphics are also
# available: \code{\link{cfly_pcp}} will produce a parallel
# coordinates plot, \code{\link{cfly_dist}} will show
# the distribution of each variable in each cluster, and
# \code{\link{cfly_fluct}} compares two clusterings with a
# fluctuation diagram.
# 
# If you want to standardise the cluster labelling to one
# group, look at \code{\link{clarify}} and \code{\link{cfly_clarify}}
# 
# @arguments data frame to be clustered
# @arguments rescale, if true each variable will be scaled to have mean 0 and variance 1.
# @seealso vignette("introduction")
# @alias package-clusterfly
# @keyword dynamic 
clusterfly <- function(df, rescale=TRUE) {
	if (rescale) df <- rescaler(df)

	g <- NULL
	getg <- function(cf, reset=FALSE) {
		if (reset && valid_ggobi(g)) close(g)
		if (!valid_ggobi(g)) g <<- ggobi(df)
		invisible(g)
	}

	structure(list(
		df = df, 
		clusters = list(), 
		ggobi = getg,
	), class="clusterfly")
}


# Dynamic plot: show in ggobi
# Opens an instance ggobi for this dataset (if not already open), and colours the points according the cluster assignment.
# 
# @arguments clusterfly object
# @arguments clustering to display
# @arguments add convex hull? see \code{\link{addhull}} for details
# @keyword dynamic 
# cfly_show(o, 1)
# cfly_show(o, "kmeans")
cfly_show <- function(cf, idx = "true", hulls = FALSE) {
	g <- cf$ggobi()[1]
	cl <- cf$clusters[[idx]]
	glyph_colour(g) <- cl
	if (hulls) {
		addhull(g[1], g, cl)
		glyph_colour(g['hulls']) <- g['hulls']$id
	}
}

# Add clustering
# 
# @keyword internal 
"[[<-.clusterfly" <- function(x, i, value) {
	x$clusters[[i]] <- value
	x
}

# Convert clusterfly object to data.frame
# Concatenates data and cluster assignments into one data.frame.	Cluster assignments are prefixed with \code{cl_}
# 
# @arguments clusterfly object
# @arguments 
# @keyword manip 
as.data.frame.clusterfly <- function(x, ...) {
	cl <- as.data.frame(x$clusters)
	names(cl) <- paste("cl_", names(cl), sep="")
	cbind(x$df, cl)
}

# Clarify clusters
# Match all cluster indices to common reference
# 
# It's a good idea to run this before running any
# animation sequences so that unnecessary colour 
# changes are minimised.
# 
# @arguments clusterfly object
# @arguments method to use, see \code{\link{clarify}}
# @arguments index to reference clustering
# @keyword manip
#X o <- cfly_clarify(o, "Region")
cfly_clarify <- function(cf, reference=1, method="rowmax") {
	ref <- cf$clusters[[reference]]
	cf$clusters <- sapply(cf$cluster, function(x) clarify(x, ref, method=method), simplify=FALSE)
	cf
}

# Add clustering
# Add clustering 
# 
# Clustering method needs to respond to \code{\link{clusters}},
# if the default does not work, you will need to write
# your own to extract clusters.
# 
# @arguments clusterfly object
# @arguments clusterfing method (function)
# @arguments arguments passed to clustering method
# @arguments name of clustering
# @keyword manip 
#X cfly_cluster(o, kmeans, 4)
#X cfly_cluster(o, kmeans, 4, name="blah")
cfly_cluster <- function(cf, method, ..., name = deparse(substitute(method))) {
	cf[[name]] <- clusters(method(cf$df, ...))
	cf
}

# Print clusterfly object
# @keyword internal 
print.clusterfly <- function(x, ...) {
	cat("Data:		 ", paste(names(x$df), collapse=", "), "	[", nrow(x$df), "x", ncol(x$df), "]\n", sep="")
	cat("Clusters: ", paste(names(x$clusters), collapse=", "), "\n", sep="")	
}


# Dynamic plot: Animate glyph colours
# Animate glyph colours according to provided cluster ids.
# 
# This function will animiate endless until you manually break the loop
# using Ctrl-Break or Ctrl-C.	 
# 
# @arguments list of cluster ids that you want to animate across
# @arguments number of seconds to pause between each change
# @keyword dynamic 
#X # Press Ctrl-Break or Ctrl-C to exit
#X \dontrun{cfly_animate(cfly_clarify(o))}
cfly_animate <- function(cf, i = 1:length(cf$clusters), pause = 1) {
	g <- cf$ggobi()
	gd <- g[1]
	colours <- cf$clusters[i]
	while(TRUE) {
		for(col in colours) {
			if (!valid_ggobi(g)) return()
			glyph_colour(gd) <- col
			Sys.sleep(pause)
		}
	}
}

