module.exports = function(env, callback) {
  class AmpPage extends env.plugins.MarkdownPage {
    constructor(article, filepath, metadata, markdown) {
      super(filepath, metadata, markdown);
      this.article = article;
    }

    getFilename() {
      return 'amp/' + super.getFilename();
    }

    getTemplate() {
      return 'amp.pug';
    }

    getHtml(base) {
      return super.getHtml(base).replace(/<audio[^>]*src="([^"]*)"><\/audio>/g, '<amp-audio src="$1"></amp-audio>');
    }
  }

  env.registerGenerator('amp', function(contents, cb) {
    const articles = env.helpers.getArticles(contents);
    const pages = articles.map(function(article) {
      return new AmpPage(article, article.filepath, article.metadata, article.markdown);
    });
    cb(null, pages);
  });

  callback();
};
