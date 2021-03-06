% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createGrid.R
\name{createGrid}
\alias{createGrid}
\title{Creates a grid of squared polygons that fully cover the spatial extent of the study area. Study area is defined by the
Raster Layers (e.g. the Hansen data sets) thar are used as inout to calculate the forest fragmentation statistics.}
\usage{
createGrid(rasters = NULL, spacing = 500)
}
\arguments{
\item{rasters}{A raster stack with the forest map rasters.}

\item{spacing}{A numeric vector defining the spacing of grids in meters, e.g. "500" will create grids of size
500m * 500m. "500" will be the default}
}
\value{
A raster stack with the two layers per class in the 'classValue' object.
}
\description{
Creates a grid of squared polygons that fully cover the spatial extent of the study area. Study area is defined by the
Raster Layers (e.g. the Hansen data sets) thar are used as inout to calculate the forest fragmentation statistics.
}
\keyword{internal}
