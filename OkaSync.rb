#/usr/bin/ruby
$LOAD_PATH << "./include"
#puts $LOAD_PATH

require "json"

require "initialize.rb"
require "synchronize.rb"
require "listdir.rb"

confname = "#{ENV["HOME"]}/.OkaSyncConf.json"


#for debugging
#`rm #{sourceJson} #{targetJson}`


#
#  Main Routine
#


json_data_conf = loadConfigure(confname)
puts "1"

sourcedir = json_data_conf["sourcedir"]
targetdir = json_data_conf["targetdir"]

puts "2"

initialize_all(sourcedir, targetdir)

puts "3"

sourceJson = "#{sourcedir}/.OkaSyncFlag.json"
targetJson = "#{targetdir}/.OkaSyncFlag.json"
source_json_data = readJson(sourceJson)
target_json_data = readJson(targetJson)

listdir(sourcedir, source_json_data)
listdir(targetdir, target_json_data)

sync(source_json_data, target_json_data)


source_json_data["last_sync_time"] = source_json_data["time"]
target_json_data["last_sync_time"] = target_json_data["time"]
synctime = Time.now.to_i
source_json_data["time"] = synctime
target_json_data["time"] = synctime

writeJson(sourceJson, source_json_data)
writeJson(targetJson, target_json_data)


puts "sync end."
