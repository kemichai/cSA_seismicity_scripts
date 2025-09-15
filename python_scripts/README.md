How to run the codes
--------------------
The simplest way to run these Python codes is using conda.
 
Before we get started, you need to install Anaconda. 
Anaconda is cross-platform package manager software for scientific data analysis. 
You can download the installation file based on your operating system and install Anaconda or
miniconda using the following [link](https://docs.conda.io/en/latest/miniconda.html)

 
Once you have installed conda, open a terminal (Linux) 
create a new environment with the following dependencies using:
```bash
conda config --add channels conda-forge
conda create -n csa python=3.7 eqcorrscan=0.4.2 ipython pip obspy matplotlib numpy pandas pyproj shapely basemap
source activate csa_seis
```
Now you should be able to run the following commands in a terminal and make the plots:
```python
# Run this command to create figures 5 to 9 of the publication
python Figures_5-9.py

# Run the following to create figure 10 of the publication
python Figure_10.py
```
