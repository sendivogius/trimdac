Repository contains simple project which displays pixel characteristic for different trimDAC thresholds. It also allows to calculate correction for given threshold.
One can see warking application at https://tsatlawa.shinyapps.io/pixelDet/

## Background


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
