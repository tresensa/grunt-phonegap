xmldom = require 'xmldom'
path = require 'path'

module.exports = versionName = (grunt) ->
  helpers = require('../../../../helpers')(grunt)

  repair: (fn) ->
    dom = xmldom.DOMParser
    versionName = helpers.config 'versionName'
    if versionName
      phonegapPath = helpers.config 'path'

      manifestPath = path.join phonegapPath, 'platforms', 'android', 'AndroidManifest.xml'
      manifest = grunt.file.read manifestPath

      grunt.log.writeln "Setting versionName to #{versionName} in '#{manifestPath}'"

      doc = new dom().parseFromString manifest, 'text/xml'
      doc.getElementsByTagName('manifest')[0].setAttribute('android:versionName', versionName)
      grunt.file.write manifestPath, doc

    if fn then fn()
