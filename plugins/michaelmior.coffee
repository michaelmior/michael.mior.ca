ampstyle = """
/*!
 * Based on Writ by Curtis McEnroe
 *
 * https://cmcenroe.me/writ/LICENSE (ISC)
 */dd,hr,ol ol,ol ul,ul ol,ul ul{margin:0}pre,table{overflow-x:auto}a,ins{text-decoration:none}html{font-family:Hind,sans-serif;font-size:16px;line-height:1.5rem}code,kbd,pre,samp{font-family:'Roboto Mono',monospace;font-size:.833rem;color:#000}kbd{font-weight:700}h1,h2,h3,h4,h5,h6,th{font-weight:400}h1,h2{font-family:Montserrat,serif}h1{font-size:2.488em}h2{font-size:2.074em}h3{font-size:1.728em}h4{font-size:1.44em}h5{font-size:1.2em}h6{font-size:1em}small{font-size:.833em}h1,h2,h3{line-height:3rem}blockquote,dl,h1,h2,h3,h4,h5,h6,ol,p,pre,table,ul{margin:1.5rem 0 0}pre,table{margin-bottom:-1px}hr,center{border:none;padding:1.5rem 0 0}table{line-height:calc(1.5rem - 1px);width:100%;border-collapse:collapse}pre{margin-top:calc(1.5rem - 1px)}body{color:#171717;margin:1.5rem 1ch}a,nav a:visited{color:#004b91}a:visited{color:#60b}mark{color:inherit;background-color:#fe0}code,pre,samp,tfoot,thead{background-color:rgba(0,0,0,.05)}blockquote,ins,main aside{border:rgba(0,0,0,.05) solid}blockquote,main aside{border-width:0 0 0 .5ch}code,pre,samp{border:rgba(0,0,0,.1) solid}td,th{border:solid #dbdbdb}body>header{text-align:center}body>footer,main{display:block;max-width:78ch;margin:auto}main aside,main figure{float:right;margin:1.5rem 0 0 1ch}main aside{max-width:26ch;padding:0 0 0 .5ch}blockquote{margin-right:3ch;margin-left:1.5ch;padding:0 0 0 1ch}pre{border-width:1px;border-radius:2px;padding:0 .5ch}pre code{border:none;padding:0;background-color:transparent;white-space:inherit}code,ins,samp,td,th{border-width:1px}amp-img{max-width:100%}dd,ol,ul{padding:0 0 0 3ch}ul>li{list-style-type:disc}li ul>li{list-style-type:circle}li li ul>li{list-style-type:square}ol>li{list-style-type:decimal}li ol>li{list-style-type:lower-roman}li li ol>li{list-style-type:lower-alpha}nav ul{padding:0;list-style-type:none}nav ul li{display:inline;padding-left:1ch;white-space:nowrap}nav ul li:first-child{padding-left:0}ins,mark{padding:1px}td,th{padding:0 .5ch}sub,sup{font-size:.75em;line-height:1em}code,samp{border-radius:2px;padding:.1em .2em;white-space:nowrap}"""

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
