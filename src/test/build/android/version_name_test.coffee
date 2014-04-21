# If you set a `phonegap.config.versionCode` value (function or literal), `grunt phonegap:build` will post-process the generated
# `AndroidManifest.xml` file and set it for you.

grunt = require 'grunt'
xmlParser = require 'xml2json'
path = require 'path'
helpers = require(path.join __dirname, '..', '..', '..', 'tasks', 'helpers')(grunt)

if helpers.canBuild 'android'

  exports.phonegap =
    'versionName in AndroidManifest.xml should match config.versionName': (test) ->
      test.expect 1
      versionName = grunt.config.get 'phonegap.config.versionName'
      xml = grunt.file.read 'test/phonegap/platforms/android/AndroidManifest.xml'
      manifest = xmlParser.toJson xml, object: true
      test.equal versionName, manifest['manifest']['android:versionName'], 'versionName value should match'
      test.done()
