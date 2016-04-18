#/usr/bin/ruby

require "json"
require "fileutils"


def copy(src, dest)
    FileUtils.cp(src, dest, {:verbose => true})
end


def sync(source_json_data, target_json_data)
    if source_json_data["last_sync_time"] == target_json_data["last_sync_time"]
        synctime = source_json_data["last_sync_time"]
    else
        puts "Sync Time Error!" ## Error when last sync times are not same.
    end

    sourceDir = source_json_data["dir"]
    targetDir = target_json_data["dir"]

    source_json_data["file"].each{|key, value|
        puts "filename = #{key}"
        fDir_source = source_json_data["file"][key]["fDir"]
        fDel_source = source_json_data["file"][key]["fDel"]

        if fDel_source == 1
            if (target_json_data["file"][key] == nil)
                ## do nothing
            else
                targetModTime = target_json_data["file"][key]["modtime"]
                fDel_target = target_json_data["file"][key]["fDel"]
                fDir_target = target_json_data["file"][key]["fDir"]

                if ( fDel_target == 1)
                    ## Both deleted. Delete JSON infomation.
                    source_json_data["file"].delete(key)
                    target_json_data["file"].delete(key)
                else
                    if (targetModTime > synctime)
                        if fDir_target == 1
                            Dir.mkdir("#{sourceDir}/#{key}")
                        else
                            copy("#{targetDir}/#{key}", "#{sourceDir}/#{key}")
                        end
                    else  ## if target is older than synctime
                        if fDir_target == 1
                            File.delete("#{targetDir}/#{key}/*")
                            Dir.rmdir("#{targetDir}/#{key}")
                        else
                            File.delete("#{targetDir}/#{key}")
                        end
                        source_json_data["file"].delete(key)
                        target_json_data["file"].delete(key)
                    end
                end
            end

        else # if fDel_source != 1
            if  fDir_source == 1  ## if directory
                if (target_json_data["file"][key] == nil) ## if directory not found in target, mkdir
                    Dir.mkdir("#{targetDir}/#{key}")
                else
                    if target_json_data["file"][key]["fDir"] == 0 ## if target directory is not a directory, it's problem
                        puts "Error! #{sourceDir}/#{key} is a directory but #{targetDir}/#{key} is not!"
                    end
                    # if both are existing directory, nothing hove to be done
                end
        
            else ## if it is not a directory

                if target_json_data["file"][key] == nil
                    puts "This is a new file in sourceDir."
                    copy("#{sourceDir}/#{key}", "#{targetDir}/#{key}")
                else
                    sourceModTime = source_json_data["file"][key]["modtime"]
                    targetModTime = target_json_data["file"][key]["modtime"]
            
                    if sourceModTime > synctime && targetModTime > synctime
                        puts "Both have been modified. Confilicts!"
                        timestr = Time.now.strftime("%y%m%d-%H%M")
                        copy("#{sourceDir}/#{key}", "#{targetDir}/#{key}.confilct#{timestr}")
                        puts "Source File has been modified."
                    elsif sourceModTime > synctime && targetModTime < synctime
                        copy("#{sourceDir}/#{key}", "#{targetDir}/#{key}")
                    elsif sourceModTime < synctime && targetModTime > synctime
                        copy("#{targeteDir}/#{key}", "#{sourceDir}/#{key}")
                    else
                        puts "Both File has been untouched."
                    end
                #                puts "now is #{Time.now.to_i}"
                end
            end
        end
    }
    
    target_json_data["file"].each{|key, value|
        fDir_target = target_json_data["file"][key]["fDir"]
        fDel_target = target_json_data["file"][key]["fDel"]
        
        if (source_json_data["file"][key] == nil)
            if fDir_target == 1 ## if directory
                 Dir.mkdir("#{sourceDir}/#{key}")
            else
                puts "This is a new file in targetDir."
                copy("#{targetDir}/#{key}", "#{sourceDir}/#{key}")
            end
        end
    }
end
