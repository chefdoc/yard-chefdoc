#
# Cookbook Name:: test-cookbook1
# Custom Resource:: etc_dir
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# Description
# Creates a directory in /etc

resource_name :etc_dir

# The directory name to create. Can be a path like 'one/two/three'
# that will be created in /etc/one/two/tree
property :dir_name, String, name_property: true

# The owner of the directory to be created.
property :owner, default: 'root', required: true, sensitive: true

# A test property with only a name
property :name_only_here

# A test property with only a name and type
property :name_and_type_here, [TrueClass, FalseClass]

default_action :create

# Creates the directory name passed in /etc
action :create do
  directory "/etc/#{new_resource.dir_name}" do
    recursive true
    owner new_resource.owner
    group 'root'
    mode '0755'
    action :create
  end
end

# Deletes the directory passed in /etc
action :delete do
  directory "/etc/#{dir_name}" do
    recursive true
    action :delete
  end
end
