#!/usr/bin/python

import os

#------------------------------------------------------------------------------
def contains(data,value):
  try:
    data.index(value)
  except ValueError:
    return False
  return True

#------------------------------------------------------------------------------
def cleanldd(libs):
  cleanLibs=[]
  for lib in libs:
    libline=lib.split()
    if (libline[1]=='=>'):
      if (libline[2]=='not'):
        print 'WARNING: %s was not found.'%libline[0]
      elif (libline[2][0:3]=='(0x'):
        # print 'Skipping internal %s'%(libline[2])
        q=1
      else:
        cleanLibs.append(libline[2])
    elif (libline[0][0]=='/'):
      cleanLibs.append(libline[0])
    else:
      print 'WARNING: Skipping %s'%(lib)
      continue
  return cleanLibs

#-----------------------------------------------------------------------------
def walkdeps(inputLibs, outputLibs, visitedLibs, home):
  for lib in inputLibs:

    # # This is not what you want
    # if (os.path.islink(lib)):
    #   print '%s is a symlink, skipped it.'%(lib)
    #   continue

    if (contains(visitedLibs,lib)):
      # print 'Already visited %s'%(lib)
      continue
    else:
      # print 'Finding deps for %s'%(lib)
      visitedLibs.append(lib)
      if ((not contains(lib,home)) and (not contains(outputLibs,lib))):
        # print 'Found %s'%(lib)
        outputLibs.append(lib)
      cmd='/usr/bin/ldd %s'%(lib)
      f=os.popen(cmd)
      depLibs=cleanldd(f.readlines())
      f.close()
      walkdeps(depLibs, outputLibs, visitedLibs, home)

  return outputLibs

home='/usr/common/graphics/ParaView/builds/PV3-3.98.1/'
prefix='/usr/common/graphics/ParaView/3.98.1-mom-so/lib/system-libs/'

ldlib=os.environ['LD_LIBRARY_PATH']
os.environ


cmds=["","",""]
cmds[0]='ls %s/lib/*.so*'%(home)
cmds[1]='ls %s/bin/pvserver'%(home)
cmds[2]='ls %s/bin/pvbatch'%(home)

for cmd in cmds:

  f=os.popen(cmd)
  pvlibs=f.readlines()
  f.close()

  libsToCopy=walkdeps(pvlibs,[],[],home)

  print "Copying..."
  for lib in libsToCopy:
    cmd='/bin/cp -vdL %s %s'%(lib,prefix)
    f=os.popen(cmd)
    line=f.readlines()
    f.close()
    print line[0],





