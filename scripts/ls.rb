#!/bin/sh

pkgx --quiet mash pkgx/ensure ruby "$0" | pkgx --quiet gum format
exit 0

#!/usr/bin/ruby
require 'pathname'

def find_versions(dir, result)
  Dir.foreach(dir) do |entry|
    next if entry == '.' || entry == '..' # Skip current and parent directories

    path = File.join(dir, entry)

    if File.directory?(path) && !File.symlink?(path)
      if entry =~ /^v\d+\./
        version = entry.sub(/^v/, '')
        parent_dir = Pathname.new(dir).relative_path_from($pkgx_dir)
        result << "| #{parent_dir} | #{version} |"
      else
        find_versions(path, result) # Recursively call for subdirectories
      end
    end
  end
end

# Define the path to the .pkgx directory
$pkgx_dir = File.expand_path('~/.pkgx')
result = []

# Start the recursive search
find_versions($pkgx_dir, result)

# Output the Markdown table
puts "| Project | Version |"
puts "|---------|---------|"
puts result.join("\n")