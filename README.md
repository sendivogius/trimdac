Repository contains simple project which displays pixel characteristic for different trimDAC thresholds. It also allows to calculate correction for given threshold.
One can see working application at https://tsatlawa.shinyapps.io/pixelDet/

## Background

In order to improve spatial resolution in hybrid pixel detectors, designed ASICs have very small pixels (50-100 μm). Manufacturing so small circuits has impact on pixel's characteristic and there exist solutions enhancing channels uniformity. One of them is to add independent trimming DAC to each pixel and therefore allow some degree of configuration. 

During testing of manufactured chip, characteristic of each pixel and each trimming DAC setting can be read and later optimal trim DAC value can be chosen.


If you are interested in pixel detectors field, I encourage you to get familiar with articles:
* http://ieeexplore.ieee.org/document/6872148
* http://yadda.icm.edu.pl/yadda/element/bwmeta1.element.baztech-05b1c26f-8f15-47ca-b945-b258098f62fb/c/chmot54_01.pdf
* http://iopscience.iop.org/article/10.1088/1748-0221/9/12/C12046
* http://www.ijet.pl/old_archives/2011/4/70.pdf
* http://lss.fnal.gov/archive/2013/pub/fermilab-pub-13-518-ppd.pdf


## User interface
User interface contain global settings section and three tabs:
1.  Correction
2.  Pixel characteristic
3.  Simulation

In global settings user can change:
* counter - in case when chip has two counters (in working example only 'low' is supported)
* trimDAC value
* selected pixel location - user can enter values here or click on threshold scans to get pixel location
* mode - values or peaks positions
* peak detection method - getting index of maximum value or fitting Gaussian and taking peak position
* additional info checkbox - for some tabs it displays more data

### Correction tab
In upper part of interface two threshold scans are displayed.
On the left side there is scan for selected trimDAC value and on the right after correction.
Correction threshold can be selected above, and ther's option to select best threshold (with lowest stddev).


Below graphs there are histograms of peak positions and summary table with some basic statistics.

When additional info is turned on, mean (red) and stddev lines (green) are displayed on 
threshold scans as well as histograms contain Gaussian fits.

### Pixel characteristic tab
Screen contains two graphs associated with selected pixel. Upper one displays counts values for selected trimDAC value and lower peaks position for all trimmings. By clicking on DAC characteristic user can select trimming DAC value.

### Simulation tab
Tab contains simulated visualizations of pixel detectors. By running simulation user can see effect of the correction. Most of the pixel should have high (yellow) values when simulated threshold is very close to corrected threshold.
