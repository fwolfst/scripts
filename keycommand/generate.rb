#!/usr/bin/env ruby

# Released under the GPLv3+, Copyright 2022 Felix Wolfsteller
# Small script to create "command" kind of SSH keys to be used with
# ~/.ssh/authorized_keys .

# Usage:
#   - call it, its interactive
#
# Then, 'install' the public key and its directive via authorized_keys file.
#
# Connect to the server via
#
#   ssh -o "IdentitiesOnly=yes" -i /path/to/key user@host > command.response


require 'bundler/inline'
require 'fileutils'

begin
  require 'faker'
  require 'tty-font'
  require 'tty-prompt'
rescue LoadError
  STDERR.puts "-> installing dependencies..."
  gemfile(true) do
    source 'https://rubygems.org'
    gem 'faker'
    gem 'tty-font'
    gem 'tty-prompt'
  end
end

puts TTY::Font.new("3d").write("keycommand")

prompt = TTY::Prompt.new

name    = prompt.ask("Name for key:", default: Faker::Superhero.descriptor)
place   = prompt.ask("Directory to store key:", default: '/tmp/%s' % name.gsub(/[^a-zA-Z0-9]/,'_') )
command = prompt.ask("command to execute on host:")
comment = prompt.ask("comment for key:", default: '(%s)[%s]' % [name,command])

puts

puts "creating directory"
FileUtils.mkdir_p place

puts "creating key"
EMPTY_PASSPHRASE = ''
system("ssh-keygen",
       "-t", "rsa",
       "-f", File.join(place, 'key'),
       "-N", EMPTY_PASSPHRASE,
       '-q',
       "-C", comment)

puts "creating authorized_keys line"
public_key = File.read(File.join(place, "key.pub"))

# older ssh server
File.write(
  File.join(place, "key.authorized_key_line_legacy"),
  "command=\"%s\",no-port-forwarding,no-user-rc,no-X11-forwarding,no-agent-forwarding,no-pty %s" % [command, public_key])
# just use 'restrict' for newer ssh server
File.write(
  File.join(place, "key.authorized_key_line"),
  "command=\"%s\",restrict %s" % [command, public_key])

puts " * Install the commandkeys ~/.ssh/authorized_keys - line"
puts " * Use like"
puts "    ssh -o \"IdentitiesOnly=yes\" -i %s user@host > command.response" % File.join(place, "key")

puts "done"


exit 0
