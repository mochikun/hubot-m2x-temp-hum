# Description:
#   Hubot responds your M2X data
#
# Dependencies:
#   None
#
# Configuration:
#   None
#   export HUBOT_M2X_KEY=your_m2x_key
#   export HUBOT_M2X_DEVID=your_m2x_device_id
#   export HUBOT_M2X_TEMP=your_m2x_stream_id1
#   export HUBOT_M2X_HUM=your_m2x_stream_id2
#
# Commands:
#   hubot rtemp - Hubot responds your room's temp data
#   hubot rhum - Hubot responds your room's hum data
#
# Notes:
#   None
# Author:
#   mochikun

config = 
	key: process.env.HUBOT_M2X_KEY
	devid: process.env.HUBOT_M2X_DEVID
	m2x_temp: process.env.HUBOT_M2X_TEMP
	m2x_hum: process.env.HUBOT_M2X_HUM

module.exports = (robot) ->
	unless config.key?
		robot.logger.error 'process.env.HUBOT_M2X_KEY is not defined'
		return
	unless config.devid?
		robot.logger.error 'process.env.HUBOT_M2X_DEVID is not defined'
		return
	unless config.m2x_temp?
		robot.logger.error 'process.env.HUBOT_M2X_TEMP is not defined'
		return
	unless config.m2x_hum?
		robot.logger.error 'process.env.HUBOT_M2X_HUM is not defined'
		return

	robot.respond /rtemp/i, (msg) ->
		request = msg.http("http://api-m2x.att.com/v2/devices/#{config.devid}/streams/#{config.m2x_temp}")
			.header('X-M2X-KEY', "#{config.key}")
			.get()
		request (err, res, body) ->
			json = JSON.parse body
			if res.statusCode == 200 
				msg.send "Your room temp: #{json.value} #{json.unit.symbol} ( #{json.latest_value_at} )"
			else
				msg.send "get error"

	robot.respond /rhum/i, (msg) ->
		request = msg.http("http://api-m2x.att.com/v2/devices/#{config.devid}/streams/#{config.m2x_hum}")
			.header('X-M2X-KEY', "#{config.key}")
			.get()
		request (err, res, body) ->
			json = JSON.parse body
			if res.statusCode == 200 
				msg.send "Your room hum: #{json.value} #{json.unit.symbol}( #{json.latest_value_at} )"
			else
				msg.send "get error"
