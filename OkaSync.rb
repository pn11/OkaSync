#/usr/bin/ruby
$LOAD_PATH << "./include"
#puts $LOAD_PATH

require "json"

require "initialize.rb"
require "synchronize.rb"


confname = "/Users/oka/.OkaSyncConf"

sourcedir = "/Users/oka/OkaSync_test/test1"
targetdir = "/Users/oka/OkaSync_test/test2"

sourceJson = "#{sourcedir}/.OkaSyncFlag.json"
targetJson = "#{targetdir}/.OkaSyncFlag.json"


#for debugging
#`rm #{sourceJson} #{targetJson}`

def listdir(dirname, json_data)
	Dir.glob("#{dirname}/**/*").each{|fname|
		mtime = File.mtime(fname).to_i
        inode = File.stat(fname).ino
		#        puts "#{fname} #{mtime} #{inode}"
		fDir = 0  # 0 if not directory
		if FileTest::directory?(fname)
			fDir = 1
		end
		fname.gsub!("#{dirname}/", "")
		json_data["file"][fname] = {"modtime" => mtime, "fDir" => fDir, "fDel" => 0}
	}
	
	json_data["file"].each{|key, value|
		fname = key
		if !File.exist?("#{dirname}/#{fname}")
			puts "#{fname} has been deleted."
			json_data["file"][fname]["fDel"] = 1
		end

	}
end




#
#  Main Routine
#



#listdir(sourcedir)

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
