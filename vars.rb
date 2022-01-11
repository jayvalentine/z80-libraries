CLK_SPEED_HZ = 3_686_400

HERE = __dir__
CONFIG = File.expand_path(File.join(HERE, 'config/modularz80.cfg'))

LIB_INCLUDE = File.join(HERE, 'include')
LIB = HERE

LIB_EXCLUDE = ["config", "include", "crt0", ".lib", "tmp"]

CRT0 = File.join(HERE, 'crt0.asm')
PROCESS_CRT0 = File.join(HERE, 'process_crt0.asm')
