var gulp = require('gulp'),
    rimraf = require('gulp-rimraf'),
    runWintersmith = require('run-wintersmith'),
    util = require('gulp-util');

// Clean the build directory
gulp.task('clean', function() {
  return gulp.src('build', { read: false }).pipe(rimraf());
});

// Build task
gulp.task('build', ['clean'], function(cb) {
  // Tell Wintersmith to build
  runWintersmith.build(function(){
    // Log on successful build
    util.log('Wintersmith has finished building!');

    // Tell gulp task has finished
    cb();
  });
});

// Preview task
gulp.task('preview', function() {
  // Tell Wintersmith to run in preview mode
  runWintersmith.preview();
});
