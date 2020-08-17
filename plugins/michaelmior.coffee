vinylsmith = require 'vinylsmith'

babel     = require 'gulp-babel'
imagemin  = require 'gulp-imagemin'
imageSize = require 'image-size'
path      = require 'path'
rev       = require 'gulp-rev'
sass      = require 'gulp-dart-sass'
uglify    = require 'gulp-uglify'

module.exports = (env, callback) ->
  env.registerContentPlugin 'styles', '**/*.scss',
    vinylsmith(env)
      .pipe(sass)
      .pipe(rev)

  env.registerContentPlugin 'scripts', '**/*.js',
    vinylsmith(env)
      .pipe(babel, experimental: true)
      .pipe(uglify)
      .pipe(rev)

  env.registerContentPlugin 'images', '**/img/*',
    vinylsmith(env)
      .pipe(imagemin, {progressive: true})

  env.registerContentPlugin 'images', 'blog/*/*.png',
    vinylsmith(env)
      .pipe(imagemin, {progressive: true})

  blogImageObject = (page) ->
    url = path.dirname(page.filepath.relative) + '/' + page.metadata.image
    image = path.dirname(page.filepath.full) + '/' + page.metadata.image
    size = imageSize(image)
    {
      'url': env.locals.url + '/' + url,
      'height': size.height,
      'width': size.width
    }

  env.helpers.blogImageObject = blogImageObject

  callback()
