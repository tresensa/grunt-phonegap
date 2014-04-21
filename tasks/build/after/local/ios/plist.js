(function() {
  var path, plist, xmldom;

  xmldom = require('xmldom');

  path = require('path');

  module.exports = plist = function(grunt) {
    var helpers;
    helpers = require('../../../../helpers')(grunt);
    return {
      updatePlist: function(fn) {
        var appName, childNode, configDoc, configFile, configFilePath, configNode, configNodes, doc, dom, keyName, keyNode, keyNodes, newNodes, phonegapPath, plistFile, statusBar, valueNode, _i, _j, _k, _len, _len1, _len2, _ref;
        dom = xmldom.DOMParser;
        phonegapPath = helpers.config('path');
        appName = helpers.config('name');
        plistFile = path.join(phonegapPath, 'platforms', 'ios', appName, "" + appName + "-Info.plist");
        plist = grunt.file.read(plistFile);
        doc = new dom().parseFromString(plist, 'text/xml');
        statusBar = helpers.config('iosStatusBar');
        if (statusBar === 'WhiteAndTransparent') {
          grunt.log.writeln("Adding ios white status bar configuration to plist");
          newNodes = new dom().parseFromString('<key>UIStatusBarStyle</key> <string>UIStatusBarStyleBlackTranslucent</string> <key>UIViewControllerBasedStatusBarAppearance</key> <false/>', 'text/xml');
          doc.getElementsByTagName('dict')[0].appendChild(newNodes);
        }
        configFilePath = path.join(phonegapPath, 'www', 'config.xml');
        configFile = grunt.file.read(configFilePath);
        configDoc = new dom().parseFromString(configFile, 'text/xml');
        configNodes = configDoc.getElementsByTagNameNS('http://phonegap.com/ns/1.0', 'config-file');
        keyNodes = doc.getElementsByTagName('key');
        for (_i = 0, _len = configNodes.length; _i < _len; _i++) {
          configNode = configNodes[_i];
          configNode.normalize();
          if (configNode.getAttribute('platform') === 'ios') {
            if (configNode.getAttribute('overwrite') === 'true') {
              keyName = configNode.getAttribute('parent');
              for (_j = 0, _len1 = keyNodes.length; _j < _len1; _j++) {
                keyNode = keyNodes[_j];
                if (keyNode.firstChild.nodeValue === keyName) {
                  valueNode = keyNode.nextSibling.nextSibling;
                  _ref = configNode.childNodes;
                  for (_k = 0, _len2 = _ref.length; _k < _len2; _k++) {
                    childNode = _ref[_k];
                    valueNode.parentNode.insertBefore(doc.importNode(childNode, true), valueNode);
                  }
                  valueNode.parentNode.removeChild(valueNode);
                }
              }
            } else {

            }
          }
        }
        grunt.file.write(plistFile, doc);
        if (fn) {
          return fn();
        }
      }
    };
  };

}).call(this);
