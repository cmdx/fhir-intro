# Getting Started with IBM's FHIR Server

This repo contains assets to get you up and running with IBM's FHIR Server for use in your own demos and POCs.  

**Part 1** describes how to start an instance of IBM's Open Source FHIR server on Open Shift.  
  
**Part 2** describes how to generate synthetic patient data using the Synthea package.  If you've never used Synthea you'll find it's a very nice way to create realistic patient data quickly and easily.   
  
**Part 3** describes how to load the Synthea data into the FHIR server using Python.  

**Part 4** describes how to do some basic querying of the data using Python.
  
## Repo Contents

* `fhir-deploy.sh` - a script to deploy the FHIR server on OpenShift
* `fhir-service.sh` - a script to create the OpenShift servers to expose the server.
* `fhir-intro-load.ipynb` - a Python notebook that loads a tar zip file of FHIR json objects into the FHIR server.
* `fhir-intro-query.ipynb` - a Python notebook that shows how to do some basic querying and manipulation of the FHIR data.
* `covid-high-risk.csv` - List of conditions associated with severe COVID.  Used in the query notebook.
* `pennsylvania_counties.json` - Geojson file used in the query notebook to display Choropleth map of Pennsylvania.

## Part 1: Start an Instance of IBM's FHIR Server on OpenShift
* Copy all scripts to a local working directory.
* Make all scripts executable: chmod +x *.sh
* Use oc login to connect to your cluster.
* Edit and run the `fhir-service.sh` script.
  - Update the `<PASSWORD>` placeholders with the desired FHIR server password.  
    ***IMPORTANT***: Use a **secure** password, as this server will be public facing.
  - Execute the script.
* Execute `fhir-service.sh`  
* It will take about five minutes for the FHIR server to start.
* Obtain the FHIR server external IP address using the OpenShift console or by running:  
`oc get service fhir`.

## Part 2: Generate FHIR Data Using the Synthea Open Source Package  
* Follow the instructions at (https://github.com/synthetichealth/synthea) to install Synthea and check the install:  
`git clone https://github.com/synthetichealth/synthea.git`  (or download and unzip)  
`cd synthea`  
`./gradlew build check test`  
  
* Execute Synthea using the command:  
`./run_synthea [-s seed] [-p populationSize] [-m moduleFilter] [state [city]]`  
  
For example:  
`./run_synthea -p 2000 -a 0-107 -m *cancer*:*heart*:*copd* Pennsylvania > penn1.txt`  
Creates a patient population of 2000 patients from Pennsylvania, in age range 0-107 and includes the cancer, heart disease, and COPD models along with other general health issues.  A complete description of the modules can be found on the Synthea site.  These disease models are very complex and are based on the actual clinical presentations, symptoms and disease progressions.  

> **Tip:** Consider saving the standard output to a file because the "seed" for the run is displayed.  This is handy if you want to re-generate the same set of data by using the `-s` option of subsequent runs.

For a full list of options run `./run_synthea --help` and consult the documentation.
  
There are also many options you might take a look at in the file:  
`synthea-master/src/main/resources/synthea.properties`  

> **Tip:** I often use these overrides:  
`generate.only_alive_patients = true`  
`generate.append_numbers_to_person_names = false`  
`exporter.csv.export = [true|false]`   
`exporter.fhir.export = [true|false]`   
  
* Once you're happy with your dataset, cd to `synthea-master/output/fhir` and run `tar -zcvpf` to create a tar zip file of your json objects.  For example:  
`tar -zcvpf pa-fhir-2k-$(date +%Y-%m-%d).tar.gz *.json`  
* Download this file and then upload it to a Watson Studio project.

## Part 3: Load the FHIR Data Using Python  
The notebook is in the repo and is shared here:  
(https://dataplatform.cloud.ibm.com/analytics/notebooks/v2/62756ea0-72d6-428c-8795-3d93515f073c/view?access_token=569688fb9940c321dc812d906774ba8559660fa33a75db2f9775ce50ddb7f45d)
    
* Copy the `fhir-intro-load.ipynb` notebook into your project.
* In the **Configuration** section:  
  - Update the `s3info` dictionary with your COS credentials.  
  - Update the `<fhir_user_password>` string in the `httpAuth` variable with the password you used in the `fhir-deploy.sh` script.
  - Update the `<fhir_server_ip>` string in the `urlBase` variable with the IP of your FHIR server, obtained in Part 1.
* Run the notebook.

## Part 4: Query the FHIR Data Using Python
The notebook is in the repo and is shared here:  
(https://dataplatform.cloud.ibm.com/analytics/notebooks/v2/bb48eaa0-8641-414a-bf10-0731bc6673e3/view?access_token=a74c9413d3523119b09485fe512f9f31abb0856d44e1a05d48cd83223bfbf877)
    
* Copy the `fhir-intro-query.ipynb` notebook into your project.  
* In the **Configuration** section:  
  - Update the `<fhir_user_password>` string in the `httpAuth` variable with the password you used in the `fhir-deploy.sh` script.
  - Update the `<fhir_server_ip>` string in the `urlBase` variable with the IP of your FHIR server, obtained in Part 1.
  - Read the notes in the "Set up Nominatim" section and optionally set the `<my_nominatum_app_name>` variable.  This variable can be any string.  It is used by the Nominium service to throttle requests.
  - Run the notebook.

## Helpful Links

IBM FHIR Server Main Site:  
(https://ibm.github.io/FHIR/)  
  
Formatting FHIR Search Query URLs - Useful for exploring the data with Postman, CURL or other API tool:
(https://smilecdr.com/docs/tutorial_and_tour/fhir_search_queries.html)  
  
Paul Bastide is a FHIR guru at IBM.  He published a nice blog & video for getting started with FHIR on Docker.  
Blog: (https://bastide.org/2020/11/23/ibm-fhir-server-using-the-docker-image-with-near-feature-and-fhir-examples-from-jupyter-notebooks/)  
Video: (https://www.youtube.com/watch?v=1MU_R_tfSDI)  
  
Main FHIR Specification Site:  
(http://hl7.org/fhir/)  

Search Parameters for Patient Records:  
(https://www.hl7.org/fhir/r4/patient.html#search)  
  
Search Parameters for Conditions (Problems):  
(http://hl7.org/fhir/condition.html#search)
  
