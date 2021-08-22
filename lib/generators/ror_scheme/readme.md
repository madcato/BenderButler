# RoR scheme generator

This code generates the Swift Codable classes to decode/encode the json data send by an API made with Rails.

As input you must set the path of an `scheme.rb` file (similar to the one called `scheme_sample.rb` in this directory). As output, a group of files will be created: each one with the name of one decodable class.

## Sample

    $ bender generate codables ./lib/generators/ror_scheme/schema_sample.rb