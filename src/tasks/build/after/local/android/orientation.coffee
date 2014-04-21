xmldom = require 'xmldom'
path = require 'path'

module.exports = orientation = (grunt) ->
  helpers = require('../../../../helpers')(grunt)

  set: (fn) ->
    dom = xmldom.DOMParser
    phonegapPath = helpers.config 'path'

    configFilePath = path.join(phonegapPath, 'www', 'config.xml');
    configFile = grunt.file.read(configFilePath);
    configDoc = new dom().parseFromString(configFile, 'text/xml');
    prefNodes = configDoc.getElementsByTagName "preference"

    manifestPath = path.join phonegapPath, 'platforms', 'android', 'AndroidManifest.xml'
    manifest = grunt.file.read manifestPath
    doc = new dom().parseFromString manifest, 'text/xml'

    for prefNode in prefNodes when prefNode.getAttribute('name').toLowerCase() is 'orientation'
      val = prefNode.getAttribute('value')
      if val
        grunt.log.writeln "Setting application orientation in '#{manifestPath}' to #{val}"
        activities = doc.getElementsByTagName('activity')
        activity.setAttribute('android:screenOrientation', val) for activity in activities

    grunt.file.write manifestPath, doc

    if fn then fn()
