module.exports = (env, callback) ->
  class AmpPage extends env.plugins.MarkdownPage
    constructor: (@article, @filepath, @metadata, @markdown) ->

    getFilename: ->
      'amp/' + super

    getTemplate: ->
      'amp.pug'

    getHtml: (base) ->
      super(base).replace(/<audio[^>]*src="([^"]*)"><\/audio>/g, '<amp-audio src="$1"></amp-audio>')

  env.registerGenerator 'amp', (contents, callback) ->
    articles = env.helpers.getArticles contents
    pages = articles.map (article) ->
      page = new AmpPage article, article.filepath, article.metadata, article.markdown
    callback null, pages

  callback()
