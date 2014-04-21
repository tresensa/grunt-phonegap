fluid = require 'fluid'

module.exports = android = (grunt) ->
  tasks =
    repairVersionCode: require('./android/version_code')(grunt).repair
    repairVersionName: require('./android/version_name')(grunt).repair
    buildIcons: require('./android/icons')(grunt).build
    buildScreens: require('./android/screens')(grunt).build
    setMinSdkVersion: require('./android/sdk_version')(grunt).setMin
    setTargetSdkVersion: require('./android/sdk_version')(grunt).setTarget
    setPermissions: require('./android/permissions')(grunt).set
    setAndroidApplicationName: require('./android/application_name')(grunt).set
    setOrientation: require('./android/orientation')(grunt).set

  run: (fn) ->
    fluid(tasks)
      .repairVersionCode()
      .repairVersionName()
      .setMinSdkVersion()
      .setTargetSdkVersion()
      .setPermissions()
      .setAndroidApplicationName()
      .setOrientation()
      .buildIcons()
      .buildScreens()
      .go (err, result) ->
        if err then grunt.fatal err
        if fn then fn()
