_ = require 'lodash'
grunt = require 'grunt'
xmlParser = require 'xml2json'
path = require 'path'
helpers = require(path.join __dirname, '..', '..', '..', 'tasks', 'helpers')(grunt)

if helpers.canBuild 'ios'

  exports.phonegap =
    'plist file should contain white status bar configuration': (test) ->
      test.expect 2
      appName = grunt.config.get 'phonegap.config.name'

      xml = grunt.file.read "test/phonegap/platforms/ios/#{appName}/#{appName}-Info.plist"
      plist = xmlParser.toJson xml, object: true
      test.equal true, _.contains(plist.plist.dict.key, "UIStatusBarStyle"), "contains key UIStatusBarStyle"
      test.equal true, _.contains(plist.plist.dict.key, "UIViewControllerBasedStatusBarAppearance"), "contains key UIViewControllerBasedStatusBarAppearance"
      test.done()

    'plist file should contain gap:config-file changes from config.xml': (test) ->
      test.expect 4
      appName = grunt.config.get 'phonegap.config.name'

      xml = grunt.file.read "test/phonegap/platforms/ios/#{appName}/#{appName}-Info.plist"
      plist = xmlParser.toJson xml, object: true
      test.equal true, _.contains(plist.plist.dict.key, "UISupportedInterfaceOrientations"), "contains key UISupportedInterfaceOrientations"
      test.equal 2, plist.plist.dict.array[0].string.length, "correct number of orientations"
      test.equal true, _.contains(plist.plist.dict.array[0].string, "UIInterfaceOrientationLandscapeLeft"), "contains orientation UIInterfaceOrientationLandscapeLeft"
      test.equal true, _.contains(plist.plist.dict.array[0].string, "UIInterfaceOrientationLandscapeRight"), "contains orientation UIInterfaceOrientationLandscapeRight"
      test.done()
