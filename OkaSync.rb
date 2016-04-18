#/usr/bin/ruby
$LOAD_PATH << "./include"
#puts $LOAD_PATH

require "json"

require "initialize.rb"
require "synchronize.rb"
require "listdir.rb"


sourcedir = "/Users/oka/OkaSync_test/test1"  #input path to the source directory  (two directories are equal)
targetdir = "/Users/oka/OkaSync_test/test2"  #input path to the target directory

sourceJson = "#{sourcedir}/.OkaSyncFlag.json"
targetJson = "#{targetdir}/.OkaSyncFlag.json"


#for debugging
#`rm #{sourceJson} #{targetJson}`



#
#  Main Routine
#

initialize_all(sourcedir, targetdir)


source_json_data = readJson(sourceJson)
target_json_data = readJson(targetJson)


listdir(targetdir, target_json_data)
listdir(sourcedir, source_json_data)


sync(source_json_data, target_json_data)


source_json_data["last_sync_time"] = source_json_data["time"]
target_json_data["last_sync_time"] = target_json_data["time"]
synctime = Time.now.to_i
source_json_data["time"] = synctime
target_json_data["time"] = synctime

writeJson(sourceJson, source_json_data)
writeJson(targetJson, target_json_data)


puts "sync end."
