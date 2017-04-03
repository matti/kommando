$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kommando'
require 'byebug'

require 'rspec-prof'
RSpecProf.printer_class = RubyProf::GraphHtmlPrinter
  # The printer to be used when writing profiles

RSpecProf::FilenameHelpers.file_extension = "html"
  # The file extension for profiles written to disk

RSpecProf::FilenameHelpers.output_dir = "profiles"
  # The destination directory into which profiles are written
