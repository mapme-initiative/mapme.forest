% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ClassStat2.R
\name{ClassStat2}
\alias{ClassStat2}
\title{Calculates landscape class statistics based on the R package "SDMTools"}
\usage{
ClassStat2(
  inputLayer,
  cellsize = 30,
  bkgd = NA,
  latlon = FALSE,
  na.rm = TRUE,
  FragStats = "all"
)
}
\arguments{
\item{inputLayer}{a matrix of data with patches identified as classes (unique integer values) as e.g.,
a binary lanscape of a species distribution or a vegetation map. Matrix can be
a raster of class ’asc’ (adehabitat package), ’RasterLayer’ (raster package) or
`SpatialGridDataFrame`` (sp package).}

\item{cellsize}{cell size (in meters) is a single value representing the width/height of cell edges (assuming square cells).}

\item{bkgd}{the background value for which statistics will not be calculated.}

\item{latlon}{\code{logical}: Indicates whether or not the
\code{inputForestMap} object is based on a geographic coordinate system
or is projected to a planar coordinate system. In the former case,
area is approximated by \code{\link[raster:area]{raster::area}}.}

\item{na.rm}{Logical if NA values should be removed when calculating the statistics. Defaults to TRUE.}

\item{FragStats}{Character vector list of forest fragmentation parameetrs to be calculated.}
}
\value{
A raster stack with the two layers per class in the 'classValue' object.
}
\description{
ClassStat2 calculates a user defined set of landscape fragmentation indices for patch types identified
 in a matrix of data or in a raster of class ’asc’ (SDMTools & adehabitat packages), ’RasterLayer’ (raster package)
 or ’SpatialGrid-DataFrame’ (sp package). It is actually used as a helper function
 within the \code{\link{FragStatsCalc}} function.
 It is heavily based on the \code{\link[SDMTools:ClassStat]{SDMTools:ClassStat}} function.
}
\author{
Darius Görgen (MapTailor Geospatial Consulting GbR) \email{info@maptailor.net}
\cr
\emph{Maintainer:} MAPME-Initiative \email{contact@mapme-initiative.org}
\cr
\emph{Contact Person:} Dr. Johannes Schielein
\cr
\emph{Copyright:} MAPME-Initiative
\cr
\emph{License:} GPL-3
}
\keyword{internal}
