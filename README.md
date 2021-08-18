# I. Setting up the software for the Workshop 

This instructions have been prepared for GEOG 176A - Summer B - 2021. Most of the material is borrowed from the [PostGIS.net](https://postgis.net/workshops/postgis-intro/). 



## 1. Install PostgreSQL and PostGIS

### Windows and MacOS

Please find the instructions [here](https://postgis.net/workshops/postgis-intro/installation.html). Make sure to download the latest version of the software: **PostgreSQL 13**.  Please follow instructions to the letter. In all of the pop-up windows use the default options and click Yes / Okay! 



***

## 2. Install QGIS 

### Windows and MacOS

Go the [QGIS Download page](https://www.qgis.org/en/site/forusers/download.html) and download **QGIS Standalone Installer Version 3.16** in the corresponding pane. Use *Windows* pane for Windows and *MacOS* pane for MacOS. 



***

## 3. Install DBeaver 

### Windows and MacOS

Go to [DBeaver Download page](https://dbeaver.io/download/) and download **Community Edition 21.1.5** in the corresponding section. Use *Windows* pane for Windows and *MacOS* pane for MacOS. 

##  

## 4. Prepare the data for the Workshop 

Please download the data from the [Workshop page](http://s3.cleverelephant.ca/postgis-workshop-2020.zip). Navigate to the downloaded file and unzip it in the same directory (or any other directory of your choice). 



***

## 5. Set-up the local server and geodatabase 

Follow the set-up instructions [here](https://postgis.net/workshops/postgis-intro/creating_db.html). **IMPORTANT**: in the 'Creating a Database' step there is one important thing that you need to do: setting up a binary path. Navigate to File -> Preferences. Scroll down to Paths -> Binary paths. Scroll down to 'PostgreSQL Binary Path' -> PostgreSQL 13. Click on '...' and input **C:\Program Files\PostgreSQL\13\bin** and click 'validate' (the icon next to '...'). Click Save in the bottom right. On MacOS the path will be different: **/Applications/Postgres.app/Contents/Versions/latest/bin** (or something similar to the specified path). Continue following the instructions on the page. 



## 6. Loading spatial data into geodatabase

Please follow instructions from [this page](https://postgis.net/workshops/postgis-intro/loading_data.html). You will need to use the data that you previously downloaded. 



# II. Exploring the geodatabase with QGIS. 

It is really simple and straightforward to open and work with the data stored in PostgreSQL (PostGIS). 

1. Start the QGIS and create a new project (Project -> New)
2. Connect to the geodatabase that you previously created. (Layer -> Add Layer -> Add PostGIS Layers)
3. In the pop-up windows click 'New'. Use 'nyc1' for name, 'localhost' for host, 'nyc' for Database. In the Authentification panel click on 'Basic' pane and use 'postgres' for user and the password that you previously specified. Click on 'Test Connection'. If the information is correct you will see the corresponding message on successful connection to the database. Click 'OK'.
4. In the Connections list select 'nyc1' and click 'Connect'. You will be prompted to input your username and password (from the previous step). You will see 'public' schema. Click on the triangular next to the 'public' you will see the list of available spatial layers. Press and hold Shift while also selecting all of the layers with the left click and press 'Add'. 
5. In QGIS menu Plugins -> Manage and Install Plugins. Search for 'QuickMapServices' and click 'Install'. Once installed, click 'Close' and navigate to QGIS menu: Web -> QuickMapServices -> Settings -> More Services -> Get contributed pack. Once done, click Save. 
6. In QGIS menu Web -> QuickMapServices -> Stamen -> StamenTonerLite. You may also try out different basemaps to see which one you like better. 



# III. Running spatial queries on geodatabase

We will be using DBeaver to practice the queries as it has some useful functionality, including autocomplete and code formatting, which comes in handy when the names of the tables and variables are long. We will need to add a connection to the database in DBeaver. 

1. Open DBeaver. From menu: Database > New Database Connection. Select 'PostgreSQL' and click 'Next'. Use the same credentials as you used in Part II: Exploring the geodatabase with QGIS. Before hitting 'Finish' make sure to click on 'Test Connection' to check if you input the credentials correctly. Click 'Finish', when done. 
2. Please download the demo.sql file from [My Github repository](https://raw.githubusercontent.com/barguzin/geog176a-ucsb-summerB/main/demo.sql). 
3. We will be running queries in class together, with explanations. The purpose of this exercise is to calculate the number and types of crimes in the vicinity to subway stations in Queens. 



# IV. Terminology and concepts 

## 1. Buffers 

>  **ST_Buffer(geometry,distance)** takes in a buffer distance and geometry type and outputs a polygon with a boundary the buffer distance away from the input geometry.

![](http://postgis.net/workshops/postgis-intro/_images/st_buffer.png)

![](http://postgis.net/workshops/postgis-intro/_images/liberty_positive.jpg)

## 2. Centroid 

Computes a point which is the geometric center of mass of a geometry. Returns geometry. Syntax: ST_Centroid(geometry g1);

![](https://i.imgur.com/z8U4FPy.png)



## 3. Union 

Unions the input geometries, merging geometry to produce a result geometry with no overlaps. Returns geometry. Syntax: ST_Union(geometry[] g1_array);

![](http://postgis.net/workshops/postgis-intro/_images/union.jpg)
