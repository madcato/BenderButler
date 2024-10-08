BenderButler
============

Set of scripts for managing automated tasks with developement tools like: redmine, Xcode server, git, simple CI. It's main porpouse is to perform automated tasks managed by a project manager tool.

## Installation

Execute in command line: 

    INSTALL_DIR=$HOME/.BenderButler sh <(curl -fsSL https://raw.githubusercontent.com/madcato/BenderButler/master/install.sh)

Then you cam execute this Rakefile task from any path.

    bender task [arg1] [arg2]

## Requirements 

Install gems:

	$ cd $HOME/.BenderButler
	$ bundle install

## Configuration

### Environmental variables

To publish .bender.yml errors in github, define this environmental variables:

- GITHUB_LOGIN
- GITHUB_PASSWORD

This two varaibles are requires for accesing to Redmine API server(needed for pomodoro):

- XRedmineAPIKey
- XRedmineAdminAPIKey

## Howto compile an Xcode code from the command line

xcodebuild -scheme ZaragozaMap -archivePath /Users/danielvela/Desktop/ZgZMap.xcarchive archive
or
xcodebuild -workspace euronovios.xcworkspace -scheme euronovios -archivePath ./euronovios.xcarchive archive



xcodebuild -exportArchive -exportFormat IPA -exportPath ZgZmap.ipa -archivePath /Users/danielvela/Desktop/ZgZMap.xcarchive



----------------

git clone --branch develop https://veladan@bitbucket.org/veladan/euronovios_ios.git

xcodebuild -workspace euronovios.xcworkspace -scheme euronovios -archivePath ./euronovios.xcarchive archive

xcodebuild -exportArchive -exportFormat IPA -exportPath euronovios.ipa -archivePath ./euronovios.xcarchive


## Upload ipa to TestFlightApp

team token = c5ee7992711ffb335aef867a2133cb9e_MjU4MjI4MjAxMy0wOC0xMiAxOTozODoxNC4yOTEwOTM
upload token = 3175a6bba8992bfe79a5f78199805b04_NTA4ODkwMjAxMi0wNi0yNyAxNDowMDowOS43MDQ4OTI


curl http://testflightapp.com/api/builds.json -F file=@euronovios.ipa -F api_token=3175a6bba8992bfe79a5f78199805b04_NTA4ODkwMjAxMi0wNi0yNyAxNDowMDowOS43MDQ4OTI -F team_token=c5ee7992711ffb335aef867a2133cb9e_MjU4MjI4MjAxMy0wOC0xMiAxOTozODoxNC4yOTEwOTM -F notes='This build was uploaded via the upload API' -F notify=False 



-------------------


exec 'dir'		#That replaces the current process with the one created by the command
system 'dir'	# This method returns true if the command was successful. It redirects all output to the program's
`dir`			# These methods will return the stdout, and redirect stderr to the program's


-------------------

Use gem install git to manage code and don't use command line commands

--------------------

Redmine

If you receive 403 Forbidden access when accesing to Users info, you must use the API Key of an administrator user.

## Pomodoro

Script: pomodoro.rb

### Features

- The scripts receives as a parameter the task number to do
- Search for the task in the Redmine server
- Start a countdown of X minutes
- Finishing a notification is sent to Mac OS X
- Finishing the log time is sent to Redmine server
- Allow to finish the pomodoro before ending by finishing it or cancel it.  

### Future improvements

- Choose the task selection with an iphone app
- Change the testflight upload script to use the new testflight apple service


### Doc

Doc: http://www.redmine.org/projects/redmine/wiki/Rest_api

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

## .bender.yml

Create this file to run scripts. 

Executing: 

	$ bender

without parameters, it searches for a .travis.yml in the current path. If its found, then execute all the shell commands set in the yml file.

### Example of yml file

```yml
repository: madcato/SwiftSample

install:
  - git pull
  - swift build
  - mkdir -p log

script:
  - .build/debug/SwiftSample > ./log/output.log

after_script:
  - git add .
  - git commit -m 'automated commit'
  - git push

```

### Sections 

- **repository**  Is the repository name used to create issues when the script founds an error. If some of the commands provoke an error, an issue is created including the error output of the shell command.

The rest of the sections are executed in this order:

1. **before\_install** To Install installiton requisites like git, pip, apt-get, etc
2. **install** To install project
3. **before\_script** To setup your running enviroment
4. **script** Run main process
5. **after\_success** / **after_failure** Called after main script is executed, only one will be called: depends on failure or success
6. **after\_script** Runs after main process

If some of the commands provoke an error, an issue is created if **repository** is indicated and the execution stops. No other shell command is executed.

## Simple CI

THIS SECTION DOESN'T WORK

Using [git-hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) to execute some script processing. This processing executes the `.bender.yml` file into your project base directory. Each time a `git push` is made into the server, the bender yml process is invocated.

### Requirements

* gitlab-runner [Install](https://docs.gitlab.com/runner/install/) [Documetnation](https://docs.gitlab.com/runner/commands/)

### Configuration

1. Open a `ssh` session to the server where the git bare repository is located.
2. Create a building directory cloning the repo into it.
3. Navigate where the git repository base directory is located.
4. Execute `$ bender ci init <user@remote_machine> <build_dir>`.

In order to remove the CI processing, execute `$ bender ci remove`.

When the bare repo is updated, gitlab-runner is started, this process read the file `.gitlab.yml` and run the build steps.

## rake commands
### kebab
Transforms a string to kebacase format: "CaseStudy 3 comm" becomes -> "casestudy-3-comm"

    $ rake kebab\["CaseStudy 3 comm"\]

## iOS CI

Create a `.bender-ios` file in the root of your project. This file contains the configuration for the CI process.

### Example of .bender-ios file

```rb
# Sample file

desc "Building..."
lane :build do
  build(:scheme => "Bender")
end

desc "Testing..."
lane :test do
  test(:scheme => "Bender")
end

desc "Deploying..."
lane :deploy do
  archive(scheme: "Bender")
  export(exportOptionsPlist: "ExportOptions.plist")
  upload(apiKey: ENV["APPSTORE_API_KEY_ID"], apiIssuer: ENV["APPSTORE_ISSUER_ID"])
end
```

Run each lane by executing:
```bash
  $ bender ios build
  $ bender ios test
  $ bender ios deploy
```

## remotize

Generates a bare git repository into a remote server, and configure de origin remote in the local git configuration.

Sample:
$ bander remotize project_name git@server.local
