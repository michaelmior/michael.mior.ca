ampanalytics = """<amp-analytics type="googleanalytics" id="analytics1"><script type="application/json">
{"vars": {"account": "UA-45085128-2"},"triggers": {"trackPageview": {"on": "visible","request": "pageview"}}}
</script></amp-analytics>"""

ampstyle = """
/*!
 * Based on Writ by Curtis McEnroe
 *
 * https://cmcenroe.me/writ/LICENSE (ISC)
 */dd,hr,ol ol,ol ul,ul ol,ul ul{margin:0}pre,table{overflow-x:auto}a,ins{text-decoration:none}html{font-family:Hind,sans-serif;font-size:16px;line-height:1.5rem}code,kbd,pre,samp{font-family:'Roboto Mono',monospace;font-size:.833rem;color:#000}kbd{font-weight:700}h1,h2,h3,h4,h5,h6,th{font-weight:400}h1,h2{font-family:Montserrat,serif}h1{font-size:2.488em}h2{font-size:2.074em}h3{font-size:1.728em}h4{font-size:1.44em}h5{font-size:1.2em}h6{font-size:1em}small{font-size:.833em}h1,h2,h3{line-height:3rem}blockquote,dl,h1,h2,h3,h4,h5,h6,ol,p,pre,table,ul{margin:1.5rem 0 0}pre,table{margin-bottom:-1px}hr,center{border:none;padding:1.5rem 0 0}table{line-height:calc(1.5rem - 1px);width:100%;border-collapse:collapse}pre{margin-top:calc(1.5rem - 1px)}body{color:#171717;margin:1.5rem 1ch}a,nav a:visited{color:#004b91}a:visited{color:#60b}mark{color:inherit;background-color:#fe0}code,pre,samp,tfoot,thead{background-color:rgba(0,0,0,.05)}blockquote,ins,main aside{border:rgba(0,0,0,.05) solid}blockquote,main aside{border-width:0 0 0 .5ch}code,pre,samp{border:rgba(0,0,0,.1) solid}td,th{border:solid #dbdbdb}body>header{text-align:center}body>footer,main{display:block;max-width:78ch;margin:auto}main aside,main figure{float:right;margin:1.5rem 0 0 1ch}main aside{max-width:26ch;padding:0 0 0 .5ch}blockquote{margin-right:3ch;margin-left:1.5ch;padding:0 0 0 1ch}pre{border-width:1px;border-radius:2px;padding:0 .5ch}pre code{border:none;padding:0;background-color:transparent;white-space:inherit}code,ins,samp,td,th{border-width:1px}amp-img{max-width:100%}dd,ol,ul{padding:0 0 0 3ch}ul>li{list-style-type:disc}li ul>li{list-style-type:circle}li li ul>li{list-style-type:square}ol>li{list-style-type:decimal}li ol>li{list-style-type:lower-roman}li li ol>li{list-style-type:lower-alpha}nav ul{padding:0;list-style-type:none}nav ul li{display:inline;padding-left:1ch;white-space:nowrap}nav ul li:first-child{padding-left:0}ins,mark{padding:1px}td,th{padding:0 .5ch}sub,sup{font-size:.75em;line-height:1em}code,samp{border-radius:2px;padding:.1em .2em;white-space:nowrap}"""

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

  ampRender = (page, articleUrl, callback) ->
    ampl.parse page.markdown, '', (html) ->
      $ = cheerio.load(html)

      # XXX Fix incompatible markup, should really be changed in ampl
      $('noscript').remove()
      $('style').remove()
      $('head').append('<style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}</style><noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>')
      body = $('.wrapper-main').html()
      $('.wrapper-main').remove()
      $(body).insertAfter('head')

      # Set page title and canonical URL
      $('head title').text(page.title)
      $('body').prepend('<h1>' + escape(page.title) + '</h1>')
      $('body').append('<center><a href="' + articleUrl + '#disqus_thread">View comments</a>')
      $('link[rel=canonical]').attr('href', articleUrl)
      $('head').prepend('<script async custom-element="amp-analytics" src="https://cdn.ampproject.org/v0/amp-analytics-0.1.js"></script>')
      $('body').append(ampanalytics)
      $('head').append('<style amp-custom>' + ampstyle + '</style>')
      $('head').append('<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:400,700|Hind:400,700,400italic,700italic|Roboto+Mono:400,700,400italic,700italic"')
      $('head').append('<meta name="theme-color" content="#4080c0">')
      $('head').append('<meta name="twitter:card" content="summary">')
      $('head').append('<meta name="twitter:site" content="michaelmior">')
      $('head').append('<meta name="og:title" content="' + page.title + '">')
      $('head').append('<meta name="og:description" content="' + page.metadata.summary + '">')
      $('head').append("""<script type="application/ld+json">
        {
          "@context": "http://schema.org",
          "@type": "BlogPosting",
          "headline": "#{page.metadata.title}",
          "datePublished": "#{env.helpers.toISO8601(page.date)}"
        }
      </script>""")

      page._html = $.html()
      callback null, page

  env.registerGenerator('amp', ((contents, callback) ->
    articles = env.helpers.getArticles contents
    async.map(articles, ((article, renderCallback) ->
      page = new AmpPage article.filepath, article.metadata, article.markdown
      ampRender page, article.url, renderCallback), callback)))

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
