(function() {
  var orientation, path, xmldom;

  xmldom = require('xmldom');

  path = require('path');

  module.exports = orientation = function(grunt) {
    var helpers;
    helpers = require('../../../../helpers')(grunt);
    return {
      set: function(fn) {
        var activities, activity, configDoc, configFile, configFilePath, doc, dom, manifest, manifestPath, phonegapPath, prefNode, prefNodes, val, _i, _j, _len, _len1;
        dom = xmldom.DOMParser;
        phonegapPath = helpers.config('path');
        configFilePath = path.join(phonegapPath, 'www', 'config.xml');
        configFile = grunt.file.read(configFilePath);
        configDoc = new dom().parseFromString(configFile, 'text/xml');
        prefNodes = configDoc.getElementsByTagName("preference");
        manifestPath = path.join(phonegapPath, 'platforms', 'android', 'AndroidManifest.xml');
        manifest = grunt.file.read(manifestPath);
        doc = new dom().parseFromString(manifest, 'text/xml');
        for (_i = 0, _len = prefNodes.length; _i < _len; _i++) {
          prefNode = prefNodes[_i];
          if (!(prefNode.getAttribute('name').toLowerCase() === 'orientation')) {
            continue;
          }
          val = prefNode.getAttribute('value');
          if (val) {
            grunt.log.writeln("Setting application orientation in '" + manifestPath + "' to " + val);
            activities = doc.getElementsByTagName('activity');
            for (_j = 0, _len1 = activities.length; _j < _len1; _j++) {
              activity = activities[_j];
              activity.setAttribute('android:screenOrientation', val);
            }
          }
        }
        grunt.file.write(manifestPath, doc);
        if (fn) {
          return fn();
        }
      }
    };
  };

}).call(this);
