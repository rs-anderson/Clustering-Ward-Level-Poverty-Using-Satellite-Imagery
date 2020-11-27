# Clustering of Ward Level Poverty through the use of Satellite-Imagery

This is the Github repo for the paper *Clustering Ward-Level Poverty Using Satellite Imagery* by Ryan Anderson and Andomei Smit. The aim of this research is to cluster Gauteng wards based on their level of poverty and, as a result, create a poverty map. Furthermore, the clustering will purely be based on publicly available data - assessing the potential for census-less poverty mapping. Since high-resolution satellite imagery is publicly-available, the wards will be clustered from the information that can be extracted from this imagery.

The general methodology followed in the paper is as follows:
* **Step 1:** Obtain a set of satellite images for each of the Gauteng wards
* **Step 2:** Extract a feature set for the wards from the satellite imagery using a pre-trained CNN
* **Step 3:** The dimensions of the features are reduced and then clustered using Kmeans and HDBSCAN


See the paper at <code>papers/Honours_Project_2020.pdf</code> for more information.

## Setup

In order to install the necessary packages, it is recommended to use the file *environment.yml*. To do this, run the following command in the repo: 
```
conda env create -f environment.yml
```
Then activate the environment *honoursprojectenv* by running the following:
```
conda activate honoursprojectenv
```
Then make sure you are running a kernel associated with this environment by first running:
```
conda install -c anaconda ipykernel
```
Then run:
```
python -m ipykernel install --user --name=honoursprojectenv
```
If you get any import errors, click on the "Kernel" tab at the top of the notebook and change the kernel to the *honoursprojectenv* kernel.

Unfortunately, for the R scripts, you will have to install the necessary packages yourself.

## Scripts

### feature_extraction

<code>get_ward_boundaries.ipynb</code>:
Reading in the coordinates for the Gauteng wards from the geojson shapefile, and then writing the centers for the images to /data/ward_image_centers.csv. These centers will then be used to extract the images.

<code>get_image_centers.ipynb</code>:
Reading in the coordinates for the Gauteng wards from the geojson shapefile, and then writing the centers for the images to /data/ward_image_centers.csv. These centers will then be used to extract the images.

<code>get_images.ipynb</code>:
Using /data/ward_image_centers.csv, this notebook then gets two images from Google Static Maps API for each of the center coordinates - one with the ward overlayed in black and one without. These images are stored in /images/ward_*k*/edited/*ij*.png where *k* is the ward number and *ij* are the row and column positions, respectively, of the image in the grid of images from the specific ward (e.g. top left = 00).

<code>get_features.ipynb</code>:
Reading in the coordinates for the Gauteng wards from the geojson shapefile, and then writing the centers for the images to /data/ward_image_centers.csv. These centers will then be used to extract the images.

### clustering


### visualisation_validation


## Other Scripts

**Map Visualization**:
Javascript app using the Google Static Maps Javascript API for visualizing images to be extracted. The scripts can be found in /javascript_app/. To run the javascript app, it is recommended to run a local Python server using:
```
python3 -m http.server
```
or something similar depending on your version of Python, and then access the app on the browser at the generated local server address.

## Note on Scripts

You will need to get a Google Static Maps API key for both the Javascript API (for the maps visualization) and for the general Static Maps API (for requesting images).

