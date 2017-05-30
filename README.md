# sdc-hubot
[Hubot](https://hubot.github.com/) scripts to manage [Streamsets Data Collector](https://streamsets.com/products/sdc/) servers and pipelines.  

One script (sdc-helper) available at present time, to do basic monitoring of SDC servers and pipelies. These are the commands available so far:  
* *sdc check <sdc_url>* - Checks if the given SDC server is alive  
* *sdc pipeline <pipeline_name> status* - Checks the current status of a given pipeline  
* *sdc get uuid <pipeline_name>* - Returns the uuid of a given pipeline  
* *sdc pipeline counts <pipeline_uuid>* - Returns the current record counts for a given pipeline  
* *sdc pipeline jvm metrics <pipeline_uuid>* - Returns the JVM metrics for a given pipeline  
* *sdc help* - Displays a list of all the available commands in this script  

In order to use the script in your bot instance, you need to downlad it into its  *$BOT_HOME/scripts* directory and then restart the bot.
