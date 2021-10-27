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

rule ".o" => ".c" do |t|
    system("zcc +#{CONFIG} -compiler=sccz80 -O2 -I#{File.join(HERE, "include")} --no-crt -c -o #{t.name} #{t.source}")
end

rule ".o" => ".asm" do |t|
    temp_dir = File.join(File.dirname(t.source), "tmp")
    FileUtils.mkdir(temp_dir) unless Dir.exist?(temp_dir)

    system("m4 #{t.source} > #{temp_dir}/#{File.basename(t.source)}")
    system("z80asm -mz80 -o#{t.name} #{temp_dir}/#{File.basename(t.source)}")
end

namespace 'lib' do
    task 'crt0' => "#{HERE}/crt0.o"

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
        task lib => (["prebuild_#{lib}"] + dependencies.ext('.o')) do
            # Delete temporary files (if they exist).
            if Dir.exist? File.join(HERE, "src", lib, "tmp")
                FileUtils.rm_r(File.join(HERE, "src", lib, "tmp"))
            end

            system("z80asm -x#{File.join(HERE, lib)}.lib #{dependencies.ext('.o').to_a.join(" ")}")
        end

        desc "Clean generated files and output from compiling library '#{lib}'"
        task "clean:#{lib}" do
            Dir.glob(File.join(HERE, "src", lib, "**", "*.o")).each do |o|
                FileUtils.rm(o)
            end

            if File.exist? File.join(HERE, "#{lib}.lib")
                FileUtils.rm(File.join(HERE, "#{lib}.lib"))
            end
        end
    end
end
