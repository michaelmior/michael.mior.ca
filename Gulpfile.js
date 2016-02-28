var checkPages = require('check-pages'),
    extender = require('gulp-html-extend'),
    favicons = require('gulp-favicons'),
    fs = require('fs'),
    gulp = require('gulp'),
    htmlmin = require('gulp-htmlmin'),
    rimraf = require('gulp-rimraf'),
    runSequence = require('run-sequence'),
    surge = require('gulp-surge'),
    runWintersmith = require('run-wintersmith'),
    url = require('url'),
    util = require('gulp-util');

var locals = JSON.parse(fs.readFileSync('config.json')).locals;

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
      twitter: false,
      yandex: false
    }
  }))
  .on('error', util.log)
  .pipe(gulp.dest('build/favicons'));
});

gulp.task('include-html', [], function() {
  gulp.src('build/**/*.html')
    .pipe(extender({annotations: false, root: 'build'}))
    .pipe(htmlmin({collapseWhitespace: true}))
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

gulp.task('checklinks', [], function(callback) {
  var options = {
    pageUrls: [locals.url],
    checkLinks: true,
    onlySameDomain: true,
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
