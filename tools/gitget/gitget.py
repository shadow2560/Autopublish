#!/usr/bin/python
"""
Download a specific folder from a github repo:
    gitget.py https://github.com/divs1210/kilvish/tree/master/examples/bricksnball 
"""
__author__ = 'Divyansh Prakash'

import os
import sys
import subprocess

if __name__ == '__main__':
  if len(sys.argv) > 1:
    github_src = sys.argv[1]

    try:
      head, branch_etc = github_src.split('/tree/')
      folder_url = '/'.join(branch_etc.split('/')[1:])
    except:
      print 'err:\tnot a valid folder url!'
    else:
      print 'fetching...'
      # print '/'.join([head, 'trunk', folder_url])
      # print inspect.getfile(inspect.currentframe())
      # print os.path.dirname(os.path.realpath(__file__))
      # print os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe()))) # script directory
      subprocess.call([os.path.join(os.path.dirname(os.path.abspath(os.path.realpath(sys.argv[0]))), 'svn\svn.exe'), 'checkout', '/'.join([head, 'trunk', folder_url])])
  else:
    print 'use:\tgitget.py https://github.com/user/project/tree/branch-name/folder\n'