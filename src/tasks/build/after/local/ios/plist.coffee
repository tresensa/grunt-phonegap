xmldom = require 'xmldom'
path = require 'path'

module.exports = plist = (grunt) ->
  helpers = require('../../../../helpers')(grunt)

  updatePlist: (fn) ->
    dom = xmldom.DOMParser
    phonegapPath = helpers.config 'path'
    appName = helpers.config 'name'

    plistFile = path.join phonegapPath, 'platforms', 'ios', appName, "#{appName}-Info.plist"
    plist = grunt.file.read plistFile
    doc = new dom().parseFromString plist, 'text/xml'

    statusBar = helpers.config 'iosStatusBar'
    if statusBar == 'WhiteAndTransparent'
      grunt.log.writeln "Adding ios white status bar configuration to plist"

      newNodes = new dom().parseFromString('<key>UIStatusBarStyle</key>
      <string>UIStatusBarStyleBlackTranslucent</string>
      <key>UIViewControllerBasedStatusBarAppearance</key>
      <false/>', 'text/xml')

      doc.getElementsByTagName('dict')[0].appendChild(newNodes)

    # apply gap:config-file changes in config.xml
    configFilePath = path.join(phonegapPath, 'www', 'config.xml');
    configFile = grunt.file.read(configFilePath);
    configDoc = new dom().parseFromString(configFile, 'text/xml');
    configNodes = configDoc.getElementsByTagNameNS('http://phonegap.com/ns/1.0', 'config-file');
    keyNodes = doc.getElementsByTagName('key');

    # This whole thing is very ugly
    for configNode in configNodes
      configNode.normalize();
      if configNode.getAttribute('platform') is 'ios'
        if configNode.getAttribute('overwrite') is 'true'
          keyName = configNode.getAttribute('parent')
          for keyNode in keyNodes
            if keyNode.firstChild.nodeValue is keyName
              valueNode = keyNode.nextSibling.nextSibling
              for childNode in configNode.childNodes
                valueNode.parentNode.insertBefore(doc.importNode(childNode,true), valueNode);
              valueNode.parentNode.removeChild(valueNode);
        else
          # handle appending config updates

    grunt.file.write plistFile, doc

    if fn then fn()
