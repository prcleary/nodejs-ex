# Run R Shiny on OpenShift!

This project installs the libraries and packages needed to run R Shiny on an OpenShift web server instance, using R 3.3.0 and Shiny 0.13.2.

## Usage

1. Create a new app on [openshift](https://www.openshift.com/) using nodejs-0.10 as the cartridge type.
rhc app create rshinyapps nodejs-0.10

2. Clone the source code for your OpenShift app to your desktop. You can find the source code url in your OpenShift app admin panel.

3. Delete the contents of the source code folder, except for the .git folder.

4. Clone the source code for this repository.

5. Copy the source code for this repository into the cloned OpenShift app source code folder (everything, except the .git folder).

6. Copy your R project source code into the /samples folder. For example, /samples/myproject.

7. Commit your changes to the OpenShift source code and push back to origin.

8. SSH into your OpenShift server. On Windows, use [PuTTY](https://developers.openshift.com/managing-your-applications/remote-connection.html#download-the-putty-installer), pasting in the address from the OpenShift link under "Remote Access" on the right-side of the page. Remove the text "ssh" from the front of the address.

9. On the server, enter the following commands:

```bash
cd app-root/repo/R
bash deploy_R.sh
bash deploy_libR.sh
bash generate_shiny_server_conf.sh
```

If any errors occur, open the above .sh files and paste the individual commands to the server to install libraries manually. For any additional packages used by your R application, install them manually with the following commands:

```
# Run R console.
R

# Install the package stringr.
install.packages('stringr')
```

If everything went well, you should now have a server running R Shiny!

Access your web application at your OpenShift app url. At the root url, you should see a directory listing. You can navigate to your app at /samples/myproject.

## Updating Your Code

If you make changes to your R project and commit/push the changes back to OpenShift, you will need to run the following command (on your server via SSH) to restart your app:

```bash
cd app-root/repo/R
bash generate_shiny_server_conf.sh
```

## Issues and Trouble-Shooting

If you encounter any errors during the execution of the bash scripts, open the individual .sh file and execute the commands manually, one at a time.

You can confirm R is correctly installed by typing ```R``` at the console to launch the R console environment.

You can install additional R packages directly from the R console by using ```install.packages('name')```.

The OpenShift server has limited memory, so some packages (such as RcppEigen and caret) may be difficult to install.
