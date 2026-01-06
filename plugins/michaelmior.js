const vinylsmith = require('vinylsmith');

const babel = require('gulp-babel');
const imagemin = require('gulp-imagemin');
const imageSize = require('image-size');
const path = require('path');
const rev = require('gulp-rev');
const sass = require('gulp-sass')(require('node-sass'));
const uglify = require('gulp-uglify');

module.exports = function(env, callback) {
  env.registerContentPlugin('styles', '**/*.scss',
    vinylsmith(env)
      .pipe(sass)
      .pipe(rev)
  );

  env.registerContentPlugin('scripts', '**/*.js',
    vinylsmith(env)
      .pipe(babel, { experimental: true })
      .pipe(uglify)
      .pipe(rev)
  );

  env.registerContentPlugin('images', '**/img/*',
    vinylsmith(env)
      .pipe(imagemin, { progressive: true })
  );

  env.registerContentPlugin('images', 'blog/*/*.png',
    vinylsmith(env)
      .pipe(imagemin, { progressive: true })
  );

  const blogImageObject = function(page) {
    const url = path.dirname(page.filepath.relative) + '/' + page.metadata.image;
    const image = path.dirname(page.filepath.full) + '/' + page.metadata.image;
    const size = imageSize(image);
    return {
      url: env.locals.url + '/' + url,
      height: size.height,
      width: size.width
    };
  };

  env.helpers.blogImageObject = blogImageObject;

  callback();
};
