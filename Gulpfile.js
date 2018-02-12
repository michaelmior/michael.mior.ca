var a11y = require('gulp-a11y'),
    checkPages = require('check-pages'),
    cheerio = require('gulp-cheerio'),
    extender = require('gulp-html-extend'),
    favicons = require('gulp-favicons'),
    fs = require('fs'),
    gulp = require('gulp'),
    htmllint = require('gulp-htmllint'),
    htmlmin = require('gulp-htmlmin'),
    mdlint = require('gulp-remark-lint-dko'),
    path = require('path'),
    rimraf = require('gulp-rimraf'),
    runSequence = require('run-sequence'),
    sassLint = require('gulp-sass-lint'),
    sizeOf = require('image-size'),
    surge = require('gulp-surge'),
    runWintersmith = require('run-wintersmith'),
    url = require('url'),
    util = require('gulp-util');

var locals = JSON.parse(fs.readFileSync('config.json')).locals;

// Lint
gulp.task('lint-markdown', function() {
  return gulp.src('contents/**/*.md')
    .pipe(mdlint({rules: {
      'first-heading-level': false, // XXX Should really be 2 if possible
      'list-item-indent': false,
      'maximum-line-length': false,
      'no-file-name-mixed-case': false,
      'no-multiple-toplevel-headings': false
    }}))
    .pipe(mdlint.report());
});

gulp.task('lint-sass', function() {
  gulp.src('contents/styles/**/*\.s+(a|c)ss')
    .pipe(sassLint())
    .pipe(sassLint.format())
    .pipe(sassLint.failOnError())
});

gulp.task('lint', ['lint-markdown', 'lint-sass']);

// Clean the build directory
gulp.task('clean', function() {
  return gulp.src('build', { read: false }).pipe(rimraf());
});

// Helper tasks for favicons
gulp.task('favicons', function () {
  return gulp.src('contents/img/logo.png').pipe(favicons({
    appName: locals.name,
    appDescription: locals.description,
    developerName: locals.owner,
    developerURL: locals.url,
    background: '#FFF',
    path: '/favicons/',
    url: locals.url,
    display: 'standalone',
    orientation: 'portrait',
    version: 1.0,
    logging: false,
    online: false,
    html: 'index.html',
    pipeHTML: true,
    replace: true,
    icons: {
      appleStartup: false,
      coast: false,
      facebook: false,
      twitter: false,
      yandex: false
    }
  }))
  .on('error', util.log)
  .pipe(gulp.dest('build/favicons'));
});

function htmllintReporter(filepath, issues) {
  if (issues.length > 0) {
    issues.forEach(function (issue) {
      util.log(util.colors.cyan('[gulp-htmllint] ') +
               util.colors.white(filepath +
                 ' [' + issue.line + ',' + issue.column + ']: ') +
               util.colors.red('(' + issue.code + ') ' + issue.msg));
    });

    process.exitCode = 1;
  }
}

gulp.task('include-html', [], function() {
  gulp.src(['build/**/*.html',
            '!build/4914eddbc3a49e00fa7bcd5cc44991efa7e9a179e8cb00fb69091f77c4c59635.html',
            '!build/mywot*.html',
            '!build/pinterest-*.html',
            '!build/projects/NoSE/rubis.html'])
    .pipe(extender({annotations: false, root: 'build'}))
    .pipe(cheerio(function ($, file) {
      $('img').replaceWith(function() {
        if (this.attribs.src[0] != '/') {
          return $(this);
        }

        var img = $(/\/amp\//.test(file.path) ? '<amp-img>' : '<img>');
        img.attr('alt', this.attribs.alt);
        img.attr('src', this.attribs.src.replace(/^\/amp/, ''));
        var dimensions = sizeOf(path.join('./build', img.attr('src')));
        img.attr('width', dimensions.width);
        img.attr('height', dimensions.height);

        return img;
      })
    }))
    .pipe(htmlmin({
      collapseBooleanAttributes: true,
      collapseWhitespace: true,
      removeComments: true,
      removeRedundantAttributes: true,
      removeScriptTypeAttributes: true,
      useShortDoctype: true
    }))
    .pipe(htmllint({}, htmllintReporter))
    .pipe(gulp.dest('build'))
});

// Build task
gulp.task('compile', [], function(cb) {
  // Tell Wintersmith to build
  runWintersmith.build(function(){
    // Log on successful build
    util.log('Wintersmith has finished building!');

    // Tell gulp task has finished
    cb();
  });
});
gulp.task('build', function(cb) {
  runSequence(
    'clean',
    ['compile', 'favicons'],
    'include-html',
    cb);
});

// Preview task
gulp.task('preview', function() {
  // Tell Wintersmith to run in preview mode
  runWintersmith.preview();
});

gulp.task('deploy', ['build'], function () {
  return surge({
    project: 'build',
    domain: url.parse(locals.url).host
  })
})

gulp.task('checklinks', function(callback) {
  var options = {
    pageUrls: [locals.url],
    checkLinks: true,
    onlySameDomain: false,
    queryHashes: true,
    noRedirects: true,
    noLocalLinks: true,
    noEmptyFragments: true,
    checkCaching: true,
    checkCompression: true,
    summary: true
  };
  checkPages(console, options, callback);
});

gulp.task('a11y', ['build'], function () {
  return gulp.src(['build/**/*.html',
                   '!build/4914eddbc3a49e00fa7bcd5cc44991efa7e9a179e8cb00fb69091f77c4c59635.html',
                   '!build/favicons/index.html',
                   '!build/mywot*.html',
                   '!build/pinterest-*.html'])
    .pipe(a11y())
    .pipe(a11y.reporter());
});
