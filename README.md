# BenderButler
============

Set of scripts for managing automated tasks with developement tools like a simple CI, or template generators. It's main porpouse is to perform automated tasks managed by a project manager tool.

## Installation

Execute in command line: 

    INSTALL_DIR=$HOME/.BenderButler sh <(curl -fsSL https://raw.githubusercontent.com/madcato/BenderButler/master/install.sh)

Then you cam execute this Rakefile task from any path.

    bender task [arg1] [arg2]

## Requirements 

Install gems:

	$ cd $HOME/.BenderButler
	$ bundle install

## Generators

### ViewModel (Swift)

This generator creates a ViewModel (pattern MVVM)

Sample usage:

	$ bender generate viewmodel Person ProjectName name:STring surname:String age:Int

### C++ class with .cpp and .h files
This generator creates the cpp and h files for a C++ class.

Sample usage:

	$ bender generate c++ NAM1:NAM2:ClassName ProjectName

* *NAM1 and NAM2 are namespaces names*

### Swift Codable structs from a `scheme.rb` Rails config file

As input you must set the path of an `scheme.rb` file (similar to the one called `scheme_sample.rb` in this directory). As output, a group of files will be created: each one with the name of one decodable class.

sample usage:

    $ bender generate codables ./lib/generators/ror_scheme/schema_sample.rb

### Issues generator scaffold

This generator creates a scaffold for an issue creator script. It generates:
- An issues directory
- A `kanban.md` file
- A `create_issus.sh` script to generate issue files.

## Simple CI

Navigate to your project root and run: `bender ci`

## rake commands

To list rake command execute `rake tasks`. This will show bender _Rankefile_, and the task in the _Rakefile_ in the current directory.
