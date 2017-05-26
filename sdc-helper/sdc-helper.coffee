# Description:
#   Streamsets Data Collector monitoring script
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot sdc check <sdc_url> - Checks if the given SDC server is alive
#	hubot sdc pipeline <pipeline_name> status - Checks the current status of a given pipeline
#	hubot sdc get uuid <pipeline_name> - Returns the uuid of a given pipeline
#	hubot sdc pipeline counts <pipeline_uuid> - Returns the current record counts for a given pipeline
#	hubot sdc pipeline jvm metrics <pipeline_uuid> - Returns the JVM metrics for a given pipeline
#	hubot sdc help - Displays a list of all the available commands in this script
#
# Author:
#   Guglielmo Iozzia (@virtualramblas)

sdcInstance = ""
user = ""
pass = ""

module.exports = (robot) ->
	#----------------------------------------
	# Checks if the given SDC server is alive
	#----------------------------------------
	robot.hear /sdc check (.*)/i, (res) ->
		sdcInstance = res.match[1] 
		sdcUrl = sdcInstance + "/rest/v1/system/info"
		auth = "Basic " + new Buffer(user + ':' + pass).toString('base64')
		res.robot.http(sdcUrl)
			.header('Authorization', auth, 'Accept', 'application/json')
			.get() (err, resp, body) ->
				data = null
				try
					data = JSON.parse body
					res.send "#{sdcInstance} seems alive."
				catch error
				   res.send "#{sdcInstance} returned: #{error}"
				   return
		
	#----------------------------------------------
	# Checks the current status of a given pipeline
	#----------------------------------------------
	robot.hear /sdc pipeline (.*) status/i, (res) ->
		pipelineName = res.match[1] 
		sdcUrl = sdcInstance + "/rest/v1/pipelines?filterText=" + pipelineName + "&includeStatus=true"
		auth = "Basic " + new Buffer(user + ':' + pass).toString('base64')
		res.robot.http(sdcUrl)
			.header('Authorization', auth, 'Accept', 'application/json')
			.get() (err, resp, body) ->
				data = null
				try
					data = JSON.parse body 
					for item in data
						for jsonItem in item
							if jsonItem.status?
								res.send "The current status of the #{pipelineName} pipeline is #{jsonItem.status}."
								break
				catch error
				   res.send "#{sdcInstance} returned: #{error}"
				   return
	
	#-------------------------------------
	# Returns the uuid of a given pipeline
	#-------------------------------------
	robot.hear /sdc get uuid (.*)/i, (res) ->
		pipelineName = res.match[1] 
		getPipelineUuidUrl = sdcInstance + "/rest/v1/pipelines?filterText=" + pipelineName
		auth = "Basic " + new Buffer(user + ':' + pass).toString('base64')
		res.robot.http(getPipelineUuidUrl)
			.header('Authorization', auth, 'Accept', 'application/json')
			.get() (err, resp, body) ->
				data = null
				try
					data = JSON.parse body  
					for item in data
						res.send "The #{pipelineName} pipeline uuid is #{item.name}"
				catch error
				   res.send "#{sdcInstance} returned: #{error}"
				   return
	
	#-------------------------------------------------------
	# Returns the current record counts for a given pipeline
	#-------------------------------------------------------
	robot.hear /sdc pipeline counts (.*)/i, (res) ->
		pipelineName = res.match[1] 
		sdcUrl = sdcInstance + "/rest/v1/pipeline/" + pipelineName + "/status"
		auth = "Basic " + new Buffer(user + ':' + pass).toString('base64')
		res.robot.http(sdcUrl)
			.header('Authorization', auth, 'Accept', 'application/json')
			.get() (err, resp, body) ->
				data = null
				try
					data = JSON.parse body  
					metrics = JSON.parse data.metrics
					for key, value of metrics.counters
						if key == "pipeline.batchCount.counter"
							batchCountCounter = value.count
						if key == "pipeline.batchInputRecords.counter"
							batchInputRecordsCounter = value.count
						if key == "pipeline.batchOutputRecords.counter"
							batchOutputRecordsCounter = value.count
						if key == "pipeline.batchErrorRecords.counter"
							batchErrorRecordsCounter = value.count
					res.send "Batch Count = #{batchCountCounter}. Input Records = #{batchInputRecordsCounter}. Output Records = #{batchOutputRecordsCounter}. Error Records: #{batchErrorRecordsCounter}"
				catch error
				   res.send "#{sdcInstance} returned: #{error}"
				   return
	
	#---------------------------------------------
	# Returns the JVM metrics for a given pipeline
	#---------------------------------------------
	robot.hear /sdc pipeline jvm metrics (.*)/i, (res) ->
		pipelineName = res.match[1]
		sdcUrl = sdcInstance + "/rest/v1/pipeline/" + pipelineName + "/status"
		auth = "Basic " + new Buffer(user + ':' + pass).toString('base64')
		res.robot.http(sdcUrl)
			.header('Authorization', auth, 'Accept', 'application/json')
			.get() (err, resp, body) ->
				data = null
				try
					data = JSON.parse body
					metrics = JSON.parse data.metrics
					for key, value of metrics.gauges
						#res.send "#{key} : #{value}"
						if key == "jvm.memory.total.max"
							res.send "Max memory: #{value.value}"
						if key == "jvm.memory.total.committed"
							res.send "Committed memory: #{value.value}"
						if key == "jvm.memory.total.used"
							res.send "Memory used: #{value.value}"
						if key == "jvm.memory.heap.max"
							res.send "Max heap memory:#{value.value}"
						if key == "jvm.memory.heap.committed"
							res.send "Committed heap memory:#{value.value}"
						if key == "jvm.memory.heap.used"
							res.send "Heap memory used: #{value.value}"
						if key == "jvm.memory.non-heap.max"
							res.send "Max non-heap memory: #{value.value}"
						if key == "jvm.memory.non-heap.committed"
							res.send "Committed non-heap memory: #{value.value}"
						if key == "jvm.memory.non-heap.used"
							res.send "Non-heap memory used: #{value.value}"
						if key == "jvm.threads.count"
							res.send "Threads count: #{value.value}"
						if key == "jvm.threads.blocked.count"
							res.send "Blocked threads count:#{value.value}"
						if key == "jvm.threads.daemon.count"
							res.send "Daemon threads count:#{value.value}"
						if key == "jvm.threads.deadlock.count"
							res.send "Deadlock threads count:#{value.value}"
						if key == "jvm.threads.new.count"
							res.send "New threads count:#{value.value}"
						if key == "jvm.threads.runnable.count"
							res.send "Runnable threads count:#{value.value}"
						if key == "jvm.threads.terminated.count"
							res.send "Terminated threads count:#{value.value}"
						if key == "jvm.threads.timed_waiting.count"
							res.send "Time waiting threads count:#{value.value}"
						if key == "jvm.threads.waiting.count"
							res.send "Waiting threads count:#{value.value}"
				catch error
				   res.send "#{sdcInstance} returned: #{error}"
				   return
	
	#-------------------------------------------------------------
	# Displays a list of all the available commands in this script
	#-------------------------------------------------------------
	robot.hear /sdc help/i, (res) ->
		res.send "Available commands: \n\
			sdc check <sdc_url>\n\
			sdc pipeline <pipeline_name> status\n\
			sdc get uuid <pipeline_name>\n\
			sdc pipeline counts <pipeline_uid>\n\
			sdc pipeline jvm metrics <pipeline_uid>\n\
			sdc help"
	