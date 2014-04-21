grunt = require 'grunt'
xmlParser = require 'xml2json'
path = require 'path'
helpers = require(path.join __dirname, '..', '..', '..', 'tasks', 'helpers')(grunt)

if helpers.canBuild 'android'
  exports.phonegap =
    '<application android:screenOrientation> in AndroidManifest.xml should match config.xml oreintation': (test) ->
      test.expect 1

      xml = grunt.file.read 'test/phonegap/platforms/android/AndroidManifest.xml'
      manifest = xmlParser.toJson xml, object: true
      test.equal 'landscape', manifest['manifest']['application']['android:screenOrientation'], 'android:screenOrientation should be landscape'
      test.done()
