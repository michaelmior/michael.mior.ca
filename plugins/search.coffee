fs = require 'fs'

module.exports = (env, callback) ->
  class SearchJson extends env.plugins.StaticFile
    constructor: (@articles) ->

    getFilename: ->
      'search_index.json'

    getView: ->
      return (args..., callback) ->
        callback null, Buffer(JSON.stringify(@articles.map (article) ->
          {
            title: article.metadata.title,
            category: article.metadata.category,
            summary: article.metadata.summary,
            uri: article.url
          }
        ))

  SearchJson.fromFile

  env.registerGenerator 'search_json', (contents, callback) ->
    articles = env.helpers.getArticles contents
    callback null, [(new SearchJson articles)]

  callback()
