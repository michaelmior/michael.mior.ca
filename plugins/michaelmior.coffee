vinylsmith = require 'vinylsmith'
 
babel     = require 'gulp-babel'
pleeease  = require 'gulp-pleeease'
rev       = require 'gulp-rev'
uglify    = require 'gulp-uglify'

module.exports = (env, callback) ->

  env.registerContentPlugin 'styles', '**/*.css',
    vinylsmith(env)
      .pipe(pleeease)
      .pipe(rev)

  env.registerContentPlugin 'scripts', '**/*.js',
    vinylsmith(env)
      .pipe(babel, experimental: true)
      .pipe(uglify)
      .pipe(rev)

  callback()
