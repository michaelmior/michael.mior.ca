vinylsmith = require 'vinylsmith'

ampl      = require 'ampl'
async     = require 'async'
babel     = require 'gulp-babel'
cheerio   = require 'cheerio'
escape    = require 'escape-html'
fs        = require 'fs'
imagemin  = require 'gulp-imagemin'
iso8601   = require 'iso8601'
pleeease  = require 'gulp-pleeease'
pngquant  = require 'imagemin-pngquant'
rev       = require 'gulp-rev'
sass      = require 'gulp-sass'
uglify    = require 'gulp-uglify'

module.exports = (env, callback) ->
  rawView = (env, locals, contents, templates, callback) ->
    callback null, new Buffer this.html

  env.registerView 'raw', rawView

  class AmpPage extends env.plugins.MarkdownPage
    getFilename: ->
      'amp/' + super

    getTemplate: ->
      null

    getView: ->
      'raw'

    getHtml: (base=env.config.baseUrl) ->
      @_html

  ampRender = (page, callback) ->
    ampl.parse page.markdown, '', (html) ->
      $ = cheerio.load(html)
      $('head title').text(page.title)
      $('body').prepend('<h1>' + escape(page.title) + '</h1>')
      page._html = $.html()
      callback null, page

  AmpPage.fromFile = (filepath, callback) ->
    async.waterfall [
      (callback) ->
        fs.readFile filepath.full, callback
      (buffer, callback) ->
        env.plugins.MarkdownPage.extractMetadata buffer.toString(), callback
      (result, callback) =>
        {markdown, metadata} = result
        page = new this filepath, metadata, markdown
        callback null, page
      (page, callback) => ampRender page, callback
      (page, callback) =>
        callback null, page
    ], callback

  env.registerContentPlugin 'amp', '**/*.*(markdown|mkd|md)', AmpPage

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
