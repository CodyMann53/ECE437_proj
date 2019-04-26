import subprocess
import re
import sys

# USER VARIABLES
asmfile = './asmFiles/mergesort_report.asm'
latencies = range(0,12,2) # 0 to 10 in steps of 2

# make clean first
subprocess.check_output('make clean',shell=True)
print("Deleted old files")

# run assembler to get meminit.hex file
print("Running asm")
subprocess.check_output('asm ' + asmfile,shell=True)
print("Done running asm")

stats = []

for lat in latencies:
  print('~~~~~~~~~LATENCY: ' + str(lat) + ' ~~~~~~~~~')
  cyclecount = -1
  # set latency in RAM file
  edited = ""
  with open('./source/ram.sv') as ramfile:
    ramtxt = ramfile.read()
    newlat = 'LAT = ' + str(lat) + ';'
    edited = re.sub(r'LAT[\s=]+\d+;', newlat, ramtxt)

  with open('./source/ram.sv', 'w') as ramfile:
    if(not edited):
      print("ERROR: Could not find LAT parameter in ram.sv")
      sys.exit(1)
    else:
      ramfile.write(edited)

  # call make system to make sure compilation successful
  print("Compiling design files")
  subprocess.check_output('make system', shell=True)
  print("Compilation completed")

  # run synthesis with target frequency of 200 MHz
  print("Starting synthesis")
  subprocess.check_output('synthesize -t -f 200 system', shell=True)
  print("Synthesis complete")

  # run simulation
  print("Starting simulation")
  simoutput = subprocess.check_output('make system.sim',shell=True)
  simsearch = re.search(r'(\d+) cycles.', simoutput.decode('utf-8'))
  if simsearch:
    cyclecount = simsearch.group(1)
    stats.append((lat, int(cyclecount)))
  else:
    print("ERROR: Could not get cycle count")
    sys.exit(1)

print(stats)
