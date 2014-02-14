#Copyright (c) 2014 Stelligent Systems LLC
#
#MIT LICENSE
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

STDOUT.sync = true

require 'opendelivery'
require 'trollop'
require 'aws-sdk-core'

@sleeptime = 10
@cfn = Aws::CloudFormation.new region: opts[:region]

def print_and_flush(str)
  print str
  $stdout.flush
end

def does_cfn_stack_exist? stackname
  result = true
  begin
    @cfn.describe_stacks stack_name: stackname
  rescue
    result = false
  end
end

def delete_cfn_stack stackname
  @cfn.delete_stack stack_name: stackname
end


opts = Trollop::options do
  opt :region, 'The AWS region to use', :type => String, :default => "us-west-2"
  opt :stackname, 'the OpsWorks stack id to destroy', :type => String, :required => true
end


if does_cfn_stack_exist? opts[:stackname]
  delete_cfn_stack opts[:stack]
end