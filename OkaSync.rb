#/usr/bin/ruby
$LOAD_PATH << './include'

require "json"
require "initialize.rb"

confname = "/Users/oka/.OkaSyncConf"

sourcedir = "/Users/oka/OkaSync_test/test1"
targetdir = "/Users/oka/OkaSync_test/test2"

sourceflag = "#{sourcedir}/.OkaSyncFlag"
targetflag = "#{targetdir}/.OkaSyncFlag"

sourceJson = "#{sourcedir}/.OkaSyncFlag.json"
targetJson = "#{targetdir}/.OkaSyncFlag.json"


#for debugging
#`rm #{sourceJson} #{targetJson}`

def listdir(dirname, json_data)
	Dir.glob("#{dirname}/**/*").each{|fname|
		mtime = File.mtime(fname).to_i
        inode = File.stat(fname).ino
        puts "#{fname} #{mtime} #{inode}"
		fname.gsub!("#{dirname}/", "")
		puts dirname
		json_data["file"][fname] = {"modtime" => mtime}
	}
end
		
# file が remove された場合はどう処理する？？



#
#  Main Routine
#



#listdir(sourcedir)

initialize_all(sourcedir, targetdir)


source_json_data = readJson(sourceJson)
target_json_data = readJson(targetJson)


listdir(targetdir, target_json_data)
listdir(sourcedir, source_json_data)

def sync(source_json_data, target_json_data)
	if ( source_json_data["last_sync_time"] == target_json_data["last_sync_time"] )
		synctime = source_json_data["last_sync_time"]
	else
		puts "Sync Time Error!"
	end
	
	source_json_data["file"].each{|key, value|
		if (target_json_data["file"][key] == nil)
			puts "This is a new file."
		else
			sourceModTime = source_json_data["file"][key]["modtime"]
			targetModTime = target_json_data["file"][key]["modtime"]

			if ( sourceModTime > synctime)
				puts "Source File was modified."
				if (targetModTime > synctime)
					puts "Target File was also modified.  Confilicts!"
				end
			elsif (targetModTime > synctime)
				puts "Target File was modified."
			else
				puts "Both File were untouched."
			end
		puts "now is #{Time.now.to_i}"
		end
	}
end


sync(source_json_data, target_json_data)


source_json_data["last_sync_time"] = source_json_data["time"]
target_json_data["last_sync_time"] = target_json_data["time"]
synctime = Time.now.to_i
source_json_data["time"] = synctime
target_json_data["time"] = synctime
writeJson(sourceJson, source_json_data)
writeJson(targetJson, target_json_data)


#puts getFileTime(json_data, "/Users/oka/OkaSync_test/test1/test2.tst")
#puts getFileTime(json_data, "/Users/oka/OkaSync_test/test1/test2.ttt")





