#' Download GFW and CO2-Emission data
#'
#' This function downloads the necessary Global Forest Watch and CO2 Emission
#'  data for a given shapefile. The shapefile is transformed to its bounding
#'  box, projected to its central UTM Zone and a buffer is applied. The default
#'  buffer size is 5000 meteres, but it can be changes by the user. It uses
#'  gdal system calls to speed up the process. The raw files by default will be
#'  deleted, but they also can be kept on the disk. Note, the CO2 emission data
#'  is only available roughly between 30N and 30S and the function will fail if
#'  your input shapfiles extent plus buffer is extending beyond those limits.
#'  This function relies heavily on code published at https://github.com/azvoleff/gfcanalysis.
#'
#' @param shape A \code{sfObject} determining the extent for which to get the GFW data.
#' @param dataset A \code{charachter} specifiying the version of the GFW data to extract.
#'  Defaults to version 1.6 from 2018. The newer version can be downloaded when
#'  you specify \code{dataset = "GFW-2019-v1.7"}.
#' @param basename A \code{charachter} which will be added to the resulting
#'  file names.
#' @param outdir A \code{charachter} for a local directory for the final outputs.
#'  If it is not existing it will be created without a message. Defaults to the
#'  current working directory.
#' @param keepTmpFiles A \code{logical} indicating if the raw tiles should be kept in
#'  the \code{tmpdir} directory. It defaults to \code{FALSE}, which usually makes sense.
#'  However, if you apply a number of analysis for different extents but there might
#'  be overlaps, it could be useful to keep the downloaded files on your machine.
#'  The function will only download the necessary data if it is not alread present
#'  in the \code{tmpdir}.
#' @param .tmpdir A \code{charachter} indicating a directory where to download
#'  the raw tiles to. It defaults to a random directory name in the actual R temporary
#'  directory. If you want to keep single values, e.g. when your aoi spans multiple
#'  tiles, you can specify a custom directory.
#' @return A \code{vector} of type \code{charachter} with all the files matching
#'  the \code{basename} pattern in the \code{outdir} directory.
#' @author Darius Görgen (MapTailor Geospatial Consulting GbR) \email{info@maptailor.net}
#' \cr
#' \emph{Maintainer:} MAPME-Initiative \email{contact@mapme-initiative.org}
#' \cr
#' \emph{Contact Person:} Dr. Johannes Schielein
#' \cr
#' \emph{Copyright:} MAPME-Initiative
#' \cr
#' \emph{License:} GPL-3
#'
#' @import sf
#' @import raster
#' @import sp
#' @importFrom curl has_internet
#' @importFrom utils download.file
#' @export downloadGFW
#' @name downloadGFW
#'
#' @note This function depends on available gdal binaries on your system. Make sure they
#'   are available as environment variables on your machine or use our docker image instead.
#'
#' @examples
#' \dontrun{
#' aoi = st_read(system.file("extdata", "aoi_polys.gpkg", package = "mapme.forest"))
#'
#' raster_files = downloadGFW(shape = aoi,
#'                             basename = "pkgTest",
#'                             outdir = "./data/",
#'                             keepTmpFiles = T,
#'                             .tmpdir = "./data/tmp")
#'
#' # resulting rasters are not automatically cropped to the extent of aoi
#' rasters = stack(lapply(raster_files, function(f){
#' f = brick(f)
#' f = crop(f, aoi)
#' }))
#' }
#'
downloadGFW <- function(shape,
                        dataset = "GFC-2018-v1.6",
                        basename = "Hansen_1.6",
                        outdir = ".",
                        keepTmpFiles = F,
                        .tmpdir = tempfile(tmpdir = tempdir())){

  warning("IMPORTANT WARNING: The use of the CO2 emission layer during analysis is currently discouraged. /n
           Several routines need to be adapted since the usage of a new data set by Harris et al (2021) (see https://www.nature.com/articles/s41558-020-00976-6)\n
           Check out https://github.com/mapme-initiative/mapme.forest/issues/7 to recieve information if the issue has been solved.")


  out = has_internet()
  if (!out){
    stop("There is no internet connection. Cannot proceed downloading required data.")
  }

  parameters = c("treecover2000", "lossyear", "co2_emission_")
  filenames = file.path(outdir, paste(basename, "_", parameters, ".tif", sep = ""))
  if(sum(file.exists(filenames)) == 3){stop("Output files exists. Please delete if you want to rerun.")}

  # this code is heavily copy & pasted from: https://github.com/azvoleff/gfcanalysis
  # update: new carbon removal data set by Harris (2021) available that is global in extent
  # convert input shape to bounding box
  proj = st_crs(4326)
  if (st_crs(shape)[[2]] != proj) shape = st_transform(shape, proj)
  shape = st_as_sf(st_as_sfc(st_bbox(shape)))
  # make the GFC grid
  grid_GFC = makeGFWGrid(mnx=-180, mxx=170, dx=10, mny=-50, mxy=80, dy=10)

  # look for intersections
  hits = suppressMessages(st_intersects(shape, st_as_sf(grid_GFC)))
  hits = grid_GFC[hits[[1]], ]

  # create directories if non-existing
  if(!file.exists(outdir)) dir.create(outdir, showWarnings = F)
  if(!file.exists(.tmpdir)) dir.create(.tmpdir, showWarnings = F)

  # loop through intersecting tiles and download them to outdir
  file_list = list()

  for (n in 1:length(hits)){

    tile = hits[n, ]
    min_x <- bbox(tile)[1, 1]
    max_y <- bbox(tile)[2, 2]

    # prepare tile names
    if (min_x < 0) {
      min_x <- paste0(sprintf('%03i', abs(min_x)), 'W')
    } else {
      min_x <- paste0(sprintf('%03i', min_x), 'E')
    }
    if (max_y < 0) {
      max_y <- paste0(sprintf('%02i', abs(max_y)), 'S')
    } else {
      max_y <- paste0(sprintf('%02i', max_y), 'N')
    }


    # url for hansen treecover and lossYear
    baseurl = paste0("https://storage.googleapis.com/earthenginepartners-hansen/", dataset, "/")
    parameters = c("treecover2000", "lossyear")
    filenames = paste0("Hansen_", dataset, "_", parameters, "_", max_y, "_", min_x, ".tif")
    urls = paste0(baseurl, filenames)

    # read co2 spatial index
    co2_url = "https://data-api.globalforestwatch.org/dataset/gfw_forest_carbon_gross_emissions/v20211022/download/geotiff?grid=10/40000&tile_id=%s&pixel_meaning=Mg_CO2e_px&x-api-key=2d60cd88-8348-4c0f-a6d5-bd9adb585a8c"
    target = paste0(max_y, "_", min_x)
    url_co2 = sprintf(co2_url, target)
    urls = c(urls, url_co2)
    filenames = c(filenames, paste0("Harris-2021_co2_emission_", max_y, "_", min_x, ".tif"))

    for (i in 1:length(filenames)){
      localname = file.path(.tmpdir, filenames[i])
      if(file.exists(localname)){
        print(paste0("File ", localname, " already exists. Skipping download."))
        next
      } else {
        download.file(urls[i], localname)
      }
    }
    file_list[[n]] = filenames
  }

  # loop through parameters and mosaic them with gdal system calls
  outfiles = unlist(file_list)
  parameters = c("treecover2000", "lossyear", "co2_emission")

  for (p in parameters){
    tmp = file.path(.tmpdir, outfiles[grep(p, outfiles)])
    filename = file.path(outdir, paste0(basename, "_", p, ".tif"))
    if(length(tmp)>1){
      if(file.exists(filename)){
        message("Output file ", filename, " already exists. Skipping translation...")
        next
      } else {
        command = paste0("gdalbuildvrt ", file.path(.tmpdir, "vrt.vrt "), paste(tmp, collapse = " "))
        system(command)
        command = paste0("gdal_translate -ot UInt16 -co COMPRESS=LZW -co BIGTIFF=YES ", file.path(.tmpdir, "vrt.vrt "), filename)
        system(command)
      }
    } else {
      file.copy(tmp, filename)
    }
  }

  if (!keepTmpFiles){
    ls = c(file.path(.tmpdir, outfiles), file.path(.tmpdir, "vrt.vrt"))
    file.remove(ls)
    file.remove(.tmpdir)
  }

  out = list.files(outdir, pattern = basename, full.names = T)
  return(out)
}

#' Create the GFW tile grid
#'
#' This function is used in \code{\link{downloadGFW}} to create a grid representing
#' the GFW tiles.
#'
#' @param mnx Minimum x coordinate
#' @param mxx Maximum x coordinate
#' @param dx x resolution
#' @param mny Minimum y coordinated
#' @param mxy Maximum y coordinated
#' @param dy y resolution
#' @param proj projection as EPSG code
#'
#' @return A grid.
#' @keywords internal
#' @export
#' @importFrom sf st_crs
#' @importFrom methods as
#' @importFrom sp GridTopology SpatialGrid
#' @importFrom utils read.csv
#'
makeGFWGrid <- function(mnx, mxx, dx, mny, mxy, dy,
                        proj=NULL) {
  if (is.null(proj)) proj = st_crs(4326)
  ncells = c((mxx - mnx) / dx,
             (mxy - mny) / dy)
  gt = GridTopology(c(mnx+dx/2, mny+dy/2), c(dx, dy), ncells)
  grd = SpatialGrid(gt, proj4string = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" )
  spix = as(grd, "SpatialPixels")
  spol = as(spix, "SpatialPolygons")
  return(spol)
}
