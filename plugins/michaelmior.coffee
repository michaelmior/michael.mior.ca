vinylsmith = require 'vinylsmith'

async     = require 'async'
babel     = require 'gulp-babel'
fs        = require 'fs'
imagemin  = require 'gulp-imagemin'
iso8601   = require 'iso8601'
pleeease  = require 'gulp-pleeease'
pngquant  = require 'imagemin-pngquant'
rev       = require 'gulp-rev'
sass      = require 'gulp-sass'
uglify    = require 'gulp-uglify'

module.exports = (env, callback) ->
  class AmpPage extends env.plugins.MarkdownPage
    constructor: (@article, @filepath, @metadata, @markdown) ->

    getFilename: ->
      'amp/' + super

    getTemplate: ->
      'amp.jade'

  env.registerGenerator 'amp', (contents, callback) ->
    articles = env.helpers.getArticles contents
    pages = articles.map (article) ->
      page = new AmpPage article, article.filepath, article.metadata, article.markdown
    callback null, pages

  env.registerContentPlugin 'styles', '**/*.scss',
    vinylsmith(env)
      .pipe(sass)
      .pipe(pleeease)
      .pipe(rev)

  env.registerContentPlugin 'scripts', '**/*.js',
    vinylsmith(env)
      .pipe(babel, experimental: true)
      .pipe(uglify)
      .pipe(rev)

  env.registerContentPlugin 'images', '**/img/*',
    vinylsmith(env)
      .pipe(imagemin, {progressive: true, use: [pngquant()]})

  toISO8601 = (date) ->
    iso8601.fromDate(date)

  env.helpers.toISO8601 = toISO8601

  callback()
