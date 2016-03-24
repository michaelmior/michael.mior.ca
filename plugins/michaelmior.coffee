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

      # XXX Fix incompatible markup, should really be changed in ampl
      $('noscript').remove()
      $('style').remove()
      $('head').append('<style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}</style><noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>')
      body = $('.wrapper-main').html()
      $('.wrapper-main').remove()
      $(body).insertAfter('head')

      # Set page title
      $('head title').text(page.title)
      $('body').prepend('<h1>' + escape(page.title) + '</h1>')

      page._html = $.html()
      callback null, page

  env.registerGenerator('amp', ((contents, callback) ->
    articles = env.helpers.getArticles contents
    async.map(articles, ((article, renderCallback) ->
      page = new AmpPage article.filepath, article.metadata, article.markdown
      ampRender page, renderCallback), callback)))

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
