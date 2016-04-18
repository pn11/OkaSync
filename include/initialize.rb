#/usr/bin/ruby

require "json"
require "fileIO.rb"

def makeConfigure(confname)
    puts "Enter the path to the source directory:"
    sourcedir = gets.chomp
    puts "Enter the path to the target directory:"
    targetdir = gets.chomp
        
    json_data_conf = {"sourcedir" => sourcedir,
                    "targetdir" => targetdir}
    writeJson(confname, json_data_conf)
    return json_data_conf
end
    
def loadConfigure(confname)
    if File.exist?(confname)
        json_data_conf = readJson(confname)
    else
        puts "Config file not found. Create new."
        json_data_conf = makeConfigure(confname)
    end
    return json_data_conf
end

def initialize_json(fname)
    if !File.exist?(fname)
        json_data = {  "time" => Time.now.to_i,
            "last_sync_time" => Time.now.to_i,
            "dir" => fname.gsub("/.OkaSyncFlag.json", ""),
            "file" => {}
        }
        writeJson(fname, json_data)
    end
end

def initialize_all(sourcedir, targetdir)
    initialize_json("#{sourcedir}/.OkaSyncFlag.json")
    initialize_json("#{targetdir}/.OkaSyncFlag.json")
end
