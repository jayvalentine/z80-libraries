require 'rake/clean'

CLK_SPEED_HZ = 3_686_400

HERE = __dir__
CONFIG = File.expand_path(File.join(HERE, 'config/modularz80.cfg'))

CLEAN.include("**/*.o", "**/*.bin", "**/*.hex", "**/*.diss")
CLEAN.include("**/tmp")

LIB_INCLUDE = File.join(HERE, 'include')

LIB_EXCLUDE = ["config", "include", "crt0", ".lib", "tmp"]

CRT0 = FileList.new(File.join(HERE, 'lib/crt0.asm'))

rule ".o" => ".c" do |t|
    system("zcc +#{CONFIG} -compiler=sccz80 -O2 -c -o #{t.name} #{t.source}")
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
        task lib => ["prebuild_#{lib}", dependencies.ext('.o')] do
            system("z80asm -x#{lib}.lib #{dependencies.ext('.o').to_a.join(" ")}")
        end
    end
end
