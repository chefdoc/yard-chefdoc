# YARD-Chef

[![Build Status](https://travis-ci.org/chefdoc/yard-chefdoc.svg?branch=master)](https://travis-ci.org/chefdoc/yard-chefdoc) [![Gem Version](https://badge.fury.io/rb/yard-chefdoc.svg)](https://badge.fury.io/rb/yard-chefdoc)

Disclaimer: This YARD plugin is still in the early development stages. Please use with care and expect things to break.

## Description

yard-chefdoc is a [YARD](http://yardoc.org/) plugin for that adds support for documenting [Chef](http://www.chef.io/) cookbooks.

## Installation

This project is still in early development, so it has not yet been released on rubygems.org.

## How to document your Cookbooks

The cookbook to be documented has to be vendored, which can be done using Berkshelfs `vendor` command or by downloading the released cookbook from a Chef Supermarket or Chef Server.

For yard-chefdoc the most important part about the vendor process is that your metadata.rb gets evaluated to a static metadata.json.

### Cookbook README

The cookbook README.md in markdown format will be the landing page. Additionally a list of all all other objects with their short description will be added.

### Cookbook Metadata

Metadata information will be included in the documentation automatically. This requires a `metadata.json` to be present, not a `metadata.rb`. Check "cookbook vendoring" for more info.

### Libraries and standard YARD functionality

Your libraries will be documented out of the box by YARD. See the [YARD Documentation](http://yardoc.org/) on how to document them.

### File headers and descriptions

With Chefs special cookbook directory structure is makes sense to add descriptions for certain files rather than for Classes, Modules etc. like Ruby. For recipe and attribute files yard-chefdoc will try to find a header which is defined by a comment block starting at the first line and ending at the first blank line.

Within this header a description can be given. This is defined to start by a comment line containing the single word `Description` and ending at the end of the comment block/header. A working example is:

```
#
# Cookbook Name:: my-cookbook
# Attribute:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# Description
# Here are some default attributes

default['my-cookbook']['brokkoli'] = %(delicious healthy)
```

In this example the description for the file `attributes/default.rb` would be `Here are some default attributes`. This description can of course also span multiple lines. Mind the blank line after the header, without this the header would serve as a description for the attribute `['my-cookbook']['brokkoli']`.

### Attributes

Attributes are automatically parsed and added to the documentation. Each attribute can have its own description which is simply the comment block above the attribute. Example:

```
# Set this attribute to define which plugins should be installed
default['my-application']['plugins'] = %w(github slack ldap)
```

### Resources

Modern Chef custom resources are automatically documented. Comments on properties and actions are added accordingly.

## Generating Cookbook Docs

To generate documentation you can either use the command line or create a rake task.

Command line:
```
cd /path/to/cookbook
yardoc --plugin chefdoc "**/*.{rb,json}"
```

Rake task:
```
require 'yard'

YARD::Config.load_plugin 'chefdoc'
YARD::Rake::YardocTask.new do |t|
  t.files = ['<path_to_cookbooks_repo>/**/*.{rb,json}']
  # t.options = ['--debug']
end
```

Then just run `rake yard`.

## Viewing Cookbook Docs

YARD output will be present in a directory named `doc` which will be located in the same folder from where the command was run. The will also be a cache directory with all the information necessary to render the documentation pages in a directory name `.yardoc`.

It is recommended to view these pages from a running YARD server.  To start a local YARD server you should be in the same directory that contains your generated `.yardoc` directory.  Once there run:

`yard server --plugin chefdoc --cache`

For more information about YARD server see [YARD documentation](http://rubydoc.info/docs/yard/file/docs/GettingStarted.md#yard_Executable)

# License and Thanks

This project was originally a fork of yard-chef by RightScale, Inc. Special thanks goes to them for providing the base for this.

Copyright (c) 2017 Jörg Herzinger. This code is distributed under the MIT license, see LICENSE for details.<br>
Copyright (c) 2012 RightScale, Inc.
