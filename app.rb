# This file contains your application, it requires dependencies and necessary
# parts of the application.
require 'rubygems'
require 'ramaze'
require 'mongo'
require 'winrm'
require 'winrm-fs'
require 'FileUtils'

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]

require __DIR__('controller/init')
require __DIR__('lib/mongo_ops')
require __DIR__('lib/winrm_ops')
require __DIR__('lib/fetch_display')