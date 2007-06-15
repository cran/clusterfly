# Visualise Kohonen self organising map with GGobi
# Displays both data, and map in original high-d space.
# 
# Map variables added as map1 and map2.  Plot these to 
# get traditional SOM plot.  Tour over all other variables to
# see how well the map fits the original data.
# 
# @arguments SOM object
# @keyword cluster
# @keyword dynamic
#X if (!is.null(nsl("cran.r-project.org")) && require("som")) {
#X d.music <- read.csv("http://www.ggobi.org/book/data/music-all.csv")
#X 
#X music <- rescaler(d.music)[complete.cases(d.music), 1:10]
#X music.som <- som(music[,-(1:3)], 6, 6, neigh="bubble", rlen=1000)
#X ggobi(music.som)
#X }
ggobi.som <- function(data, ...) {
	som <- data
	original <- data.frame(
		som$data, 
		map1 = jitter(som$visual$x) + 1, 
		map2 = jitter(som$visual$y) + 1, 
		net=factor(FALSE)
	)

	xs <- som$xdim
	ys <- som$ydim

	net <- som$code
	colnames(net) <- colnames(som$data)
	net <- cbind(net, expand.grid(map1=1:xs, map2=1:ys), net=factor(TRUE))
	rownames(net) <- paste("net", 1:nrow(net), sep="")

	df <- rbind(original, net)

	g <- ggobi(df)
	glyph_colour(g[1]) <- c(1,3)[df$net]
	d <- displays(g)[[1]]
	variables(d) <- list(X = "map1", Y = "map2")

	# Add net edges
	netlines <- make_net(xs, ys)
	edges(g) <- netlines
	edges(d) <- g[2]
	
	invisible(g)
}

# Make edge structure for SOM net
# @keyword internal
make_net <- function(xs, ys) {
	netlines <- with(expand.grid(y=1:(xs-1), x=1:(ys)), rbind(
		cbind((x - 1) * xs + y, (x - 1)		 * xs + y + 1),
		cbind((x - 1) * xs + y,	 x				 * xs + y)
	))
	netlines <- rbind(netlines, cbind(1:(ys-1) * xs, 2:ys * xs))
	netlines <- apply(netlines, 2, function(x) paste("net", x, sep=""))
	netlines
}

# Animate by setting rlen = something small
# and calling som.update repeatedly
# ---- doesn't work, som.update doesn't seem to do anything
# ggobi_som_update <- function(som, g) {
# 
#		# Update clustering
#		old <- g[1][!as.log
# ical(g[1]$net), c("map1", "map2")]
#	 jitter <- old - round(old)
#		
#		g[1][!as.logical(g[1]$net), c("map1", "map2")] <- cbind(som$visual$x, som$visual$y) + 1	 + jitter
#		
#		g[1][as.logical(g[1]$net), setdiff(names(g[1]), c("map1", "map2", "net"))] <- som$code
#		# Update cluster centres
#		
# }
# 
# 
# music.som <- som(music[,-(1:3)], 5, 7, neigh="bubble", rlen=100)
# g <- ggobi_som(music.som)
# 
# music.som <- som.update(music.som, rlen=50)
# ggobi_som_update(music.som, g)