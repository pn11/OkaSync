#/usr/bin/ruby

require "json"
require "fileIO.rb"

def initialize_json(fname)
    if !File.exist?(fname)
        json_data = {  "time" => Time.now.to_i,
            "last_sync_time" => Time.now.to_i,
            "dir" => fname.gsub("/.OkaSyncFlag.json", ""),
            "file" => {}
            # {"dummy_name" => {"modtime" => 0, "deleted" => false}}
        }
        writeJson(fname, json_data)
    end
end

def initialize_all(sourcedir, targetdir)
    initialize_json("#{sourcedir}/.OkaSyncFlag.json")
    initialize_json("#{targetdir}/.OkaSyncFlag.json")
end
