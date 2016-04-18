require "json"

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
