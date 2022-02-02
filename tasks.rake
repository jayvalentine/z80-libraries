# Libraries for the Modular Z80 Computer.
# Copyright (c) 2020 Jay Valentine.
#
# Set of tasks to allow dependent applications to automatically build these libraries
# as part of the build process.
#
# To add a library as a dependency to a rake task, 'load' this file as below:
#
# load '<dir>/tasks.rake'
#
# A dependency can then be added using the 'lib' namespace, e.g.
#
# task 'build' => 'lib:stdlib' do ...
#

require_relative 'vars.rb'

namespace 'lib' do
    task 'crt0' => "#{HERE}/crt0.rel"

    task 'process_crt0' => "#{HERE}/process_crt0.rel"

    Dir.glob("#{HERE}/src/*").each do |path|
        lib = File.basename(path)
        next if LIB_EXCLUDE.any? { |e| lib.include? e }

        task "prebuild_#{lib}" do
            if File.exist?(File.join(path, "#{lib}.rb"))
                require_relative File.join(path, "#{lib}.rb")
                prebuild()
                undef prebuild
            end
        end

        dependencies = Rake::FileList.new([File.join(HERE, "src", lib, "*.asm"), File.join(HERE, "src", lib, "*.c")])
        
        desc "Build library '#{lib}'"
        task lib => (["prebuild_#{lib}"] + dependencies.ext('.rel')) do
            # Delete temporary files (if they exist).
            if Dir.exist? File.join(HERE, "src", lib, "tmp")
                FileUtils.rm_r(File.join(HERE, "src", lib, "tmp"))
            end

            cmd = "sdcclib #{File.join(HERE, lib)}.lib #{dependencies.ext('.rel').to_a.join(" ")}"
            puts cmd
            system(cmd)
        end

        desc "Clean generated files and output from compiling library '#{lib}'"
        task "clean:#{lib}" do
            Dir.glob(File.join(HERE, "src", lib, "**", "*.rel")).each do |o|
                FileUtils.rm(o)
            end

            if File.exist? File.join(HERE, "#{lib}.lib")
                FileUtils.rm(File.join(HERE, "#{lib}.lib"))
            end
        end
    end
end
