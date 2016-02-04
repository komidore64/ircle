#
# Copyright (C) 2015 Adam Price (komidore64 at gmail dot com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require './lib/ircle/version'

Gem::Specification.new do |gem|
  gem.name = "ircle"
  gem.version = Ircle::VERSION
  gem.authors = ["M. Adam Price"]
  gem.email = ["komidore64@gmail.com"]
  gem.homepage = "http://rubygems.org/gems/ircle"
  gem.summary = "IRC bot framework"
  gem.description = "Ircle is an IRC bot framework written to give you freedom in customizing your own IRC bot using ruby."
  gem.licenses = ["GPL-3"]

  # TODO
  # gem.files

  # TODO
  # gem.test_files

  # TODO
  # gem.executables

  gem.add_dependency("cinch", "~> 2.3.1")

  gem.add_development_dependency("rake", "~> 10.4.2")
  gem.add_development_dependency("rubocop", "~> 0.35.1")
  gem.add_development_dependency("simplecov") #, "~> some version")
