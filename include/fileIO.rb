#/usr/bin/ruby

require "json"


def readJson(fname)
    json_data = open(fname) do |io|
        JSON.load(io)
    end
    return json_data
end


def writeJson(fname, json_data)
    f = File.open(fname, "w")
    f.puts JSON.pretty_generate(json_data)
    f.close()
end

def getFileTime(json_data, name)
    modtime = -1
    hash = json_data["file"][name]
    if (hash != nil)
        modtime = hash["modtime"]
    end
    return modtime
end

