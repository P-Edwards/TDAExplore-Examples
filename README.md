TDAExplore-Examples
-------------

Copyright (C) 2021 [Parker
Edwards](https://sites.nd.edu/parker-edwards)

Description
-----------

Examples for producing the figures in [paper placeholder](https://sites.nd.edu/parker-edwards) [TDAExplore](https://github.com/P-Edwards/TDAExplore). 

Version 1.0.0
-------------

External requirements
---------------------
* [TDAExplore-ML](https://github.com/P-Edwards/TDAExplore-ML)
* Bash


Installation
---------------------------
The examples expect an installation of TDAExplore-ML in the root directory, even if you've installed TDAExplore-ML before.

``` sh
	git clone https://github.com/P-Edwards/TDAExplore-ML.git 
```
Follow the installation instructions for TDAExplore-ML if you have not previously.

If you would like to re-run computations rather than use pre-computed results, download the data directory [data placeholder](https://sites.nd.edu/parker-edwards). Place the folder `data/` in this project's root directory. Alternatively:

```sh
curl url/to/data/source.zip | tar -x
```

Usage
------
The package includes a directory for data-based figures in [paper placeholder](https://sites.nd.edu/parker-edwards). For every figure directory, you can run
```sh
cd <figure directory>/data_and_plot_for_paper
chmod +x plotting.sh
./plotting.sh
```
Plot results will be placed in the same directory. The .RData files included in these directories are the same as those used for the original figures.

If you would like to re-run computations using e.g. 8 cores, you can run
```sh
cd <figure_directory>/computation
chmod +x compute.sh
./compute.sh 8
```
Computation results (including new plots) will be placed in `computation/computation_results`. Note that several computations are quite intensive, particularly those in Supplemental 1 and Supplemental 2 (AB)


Highlighted examples
--------------------
Several of the computations provide illustrative examples of TDAExplore-ML's interface. In all cases the relevant file for the Figure is `computation/compute.sh`. 

* Figure 1C - Generating a mask for a single image.
* Figure 4 - Generating "line scan" summaries from circular images
* Supplemental 2D - Generating summaries and extracting scores trained from a different run.


License
-------
These examples are licensed under the MIT license. Note that TDAExplore-ML is only available under GPLv3.
