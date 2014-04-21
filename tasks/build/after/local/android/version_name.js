(function() {
  var path, versionName, xmldom;

  xmldom = require('xmldom');

  path = require('path');

  module.exports = versionName = function(grunt) {
    var helpers;
    helpers = require('../../../../helpers')(grunt);
    return {
      repair: function(fn) {
        var doc, dom, manifest, manifestPath, phonegapPath;
        dom = xmldom.DOMParser;
        versionName = helpers.config('versionName');
        if (versionName) {
          phonegapPath = helpers.config('path');
          manifestPath = path.join(phonegapPath, 'platforms', 'android', 'AndroidManifest.xml');
          manifest = grunt.file.read(manifestPath);
          grunt.log.writeln("Setting versionName to " + versionName + " in '" + manifestPath + "'");
          doc = new dom().parseFromString(manifest, 'text/xml');
          doc.getElementsByTagName('manifest')[0].setAttribute('android:versionName', versionName);
          grunt.file.write(manifestPath, doc);
        }
        if (fn) {
          return fn();
        }
      }
    };
  };

}).call(this);
