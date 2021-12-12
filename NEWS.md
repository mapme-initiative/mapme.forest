# mapme.forest 1.0

* Added a `NEWS.md` file to track changes to the package.
* `statsGRASS()` function now allows users to set a temp directory via `tmpdir` (#5).
* `downloadGFW()` now downloads the Forest greenhouse gas emission layer of Harris et al (2021) (see https://data.globalforestwatch.org/datasets/gfw::forest-greenhouse-gas-emissions/about) (#6)
* Functions working with the new CO2 emission layer now issue a warning that the data
should not be used in analysis until routines have been adapted. The same warning is now
included in the README until the issue has been resolved (#7)
