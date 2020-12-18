# mapme.forest <img src='man/figures/logo.png' align="right" height="110"  />

<!-- badges: start -->
![check](https://github.com/mapme-initiative/mapme.forest/workflows/R-CMD-check/badge.svg)
[![Coverage Status](https://img.shields.io/codecov/c/github/mapme-initiative/mapme.forest/master.svg)](https://codecov.io/github/mapme-initiative/mapme.forest?branch=master)
<!-- badges: end -->

## About

The mapme.forest package helps understanding recent and past deforestation dynamics around the world. Next to calculating areal statistics about
the amount of deforestation in a given space, the tool provides you with the ability to calculate a high number of common fragmentation
statistics of a given landscape.

## Tutorial

The tutorial for the usage of the **mapme.forest package** can be found [here](https://mapme-initiative.github.io/mapme.forest/). Please visit
this page in order to get to know the API of mapme.forest.


## Installation instructions under Linux 

The mapme.forest package can then be installed by using the `remotes` package by entering the following command:

`remotes::install_github("mapme-initiative/mapme.forest")`.

Additionally, we ship this package with a Dockerfile which can be used to run the packages and its dependencies as a container. When `cd`ing into the repository,  building and running the image is as simple as:

`docker build -t mapmeForest:latest .`

`docker run -d -p 8787:8787 -e USER=myuser -e PASSWORD=mypassword gans-deforestation`

## Installation instructions under Windows

In our installation instruction we assume that you are going to use R Studio as an IDE. You need to have some software pre-installed software to be able to install the forestIndicator package.

- download and install R >= 3.5.x from https://cran.rstudio.com/
- download and install R Studio from https://rstudio.com/products/rstudio/download/#download
- download and install Rtools from https://cran.r-project.org/bin/windows/Rtools and make Rtools available on the PATH variable
- install the remotes packages with 'install.packages("remotes")'
- install mapme.forest with the following command: `remotes::install_github("mapme-initiative/mapme.forest")` and close R Studio afterwards

Now the package has been sucessfully installed, however, you are not necessarily 100% ready to use it. Since some of the function use gdal system calls we additionally need a valid gdal installation on your machine. 
- go to https://trac.osgeo.org/osgeo4w/ and download the osgeo4w.exe and run it
- chose advanced installation and follow the instructions. In the follwing we assume you choose the standard installation path. If you chose a custom installation path adjust the next inputs accordingly.
- When you are asked which software to install open up the Commandline_Utilities branch and chose the following:
	- gdal 
	- all python3-* entries
- At the Libs branch chose the following package:
	- libs python3-gdal

Once the installation is completed you have to add some environment variables so that Windows know where to look for the programs.
- open: System Controls -> System and Safety -> System -> Advanced Settings -> Environment Variables -> System Variables
- edit the PATH variable and add these three entries:
	- C:\OSGeo4W64\bin
	- C:\OSGeo4W64\apps\Python37
	- C:\OSGeo4W64\apps\Python37\Scripts
- then add four new variables with the following scheme:
	- Name: GDAL_DATA Value: C:\OSGeo4W64\share\gdal
	- Name: PROJ_LIB Value: C:\OSGeo4W64\share\proj
	- PYTHONHOME Value: C:\OSGeo4W64\apps\Python37
	- PYTHONPATH Value: C:\OSGeo4W64\apps\Python37\python.exe
- open up a command line and enter: gdal_calc.py When you are getting some information on how to use this script you are ready to go
- note that the setup outlined above might not be your preffered setup. Of course you can use different setups, e.g. by using virtual anaconda environments. However, this would be fairly advanced setups so we do not outline them here. The important take-away message four you when you are going to use a different setup is that gdal_calc.py as well as the usual gdal command line tools need to be available and executable.
