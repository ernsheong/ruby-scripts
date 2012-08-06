#!/usr/bin/env ruby

# This simple script converts Test::Unit tests to RSpec tests
# COMMAND LINE: ruby specify.rb dir_name
# This will read all *_test.rb files in dir_name and write its corresponding *_spec.rb files. Deletes *_test.rb files after that

Dir["#{ARGV[0]}/**/*_test.rb"].each do |file|
  text = File.read(file)
  newfile = file.sub(/_test/, "_spec")

  # Do translation
  text.gsub! /require\((.*)\)/, "require 'spec_helper'"
  text.gsub! /class (.*)Test <.*/, 'describe \1 do'
  
  text.gsub! /def setup/, "before :all do"
  text.gsub! /def/, "it"
  text.gsub! /test_(\S*)/, '"' +'\1'+'" do'
  text.gsub! /assert_redirected_to/, "response.should redirect_to"
  text.gsub! /assert_equal\((.*), (.*)\)/, '\2.should == \1'
  text.gsub! /assert_not_nil\((.*)\)/, '\1.should_not be_nil'
  text.gsub! /assert_nil\((.*)\)/, '\1.should be_nil'
  text.gsub! /assert_response\(:success\)/, "response.should be_success"
  text.gsub! /assert_template\((.*)\)/, 'response.should render_template \1'
  text.gsub! /assert\(!(.*)\)/, '\1.should be_false'
  text.gsub! /assert\((.*)\)/, '\1.should be_true'
  text.gsub! /assert_match\((.*), (.*)\)/, '\2.should match \1'

  File.open(newfile, "w") {|f| f.puts text}
  File.delete(file)
end