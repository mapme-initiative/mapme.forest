% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LossCalc.R
\name{loss_calc_seq}
\alias{loss_calc_seq}
\title{Loss area calculation single mode (Helper Function)}
\usage{
loss_calc_seq(inputForestMap, inputLossMap, studysite, years, unis, latlon)
}
\arguments{
\item{inputForestMap}{A raster stack}

\item{inputLossMap}{A raster layer}

\item{studysite}{An sf object with a single polygon}

\item{years}{Numeric vector indicating years}

\item{unis}{Numeric vector indicating yearly cell values}

\item{latlon}{Logical indicating if raster is projected or unprojected}
}
\value{
A data.frame with yearly values of forest cover loss.
}
\description{
Loss area calculation single mode (Helper Function)
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
