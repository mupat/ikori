var gulp = require('gulp');
var less = require('gulp-less');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');
var rename = require('gulp-rename');

var paths = {
  source: {
    coffee: './coffee/**/*.coffee',
    less: './less/'
  },
  dest: {
    js: './public/js/',
    css: './public/css/'
  }
}

gulp.task('coffee', function() {
  gulp.src(paths.source.coffee)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest(paths.dest.js));
});

gulp.task('less', function() {
  gulp.src(paths.source.less + 'main.less')
    .pipe(less())
    .pipe(rename({basename: 'style'}))
    .pipe(gulp.dest(paths.dest.css));
});

gulp.task('watch', function() {
  gulp.watch(paths.source.coffee, ['coffee']);
  gulp.watch(paths.source.less + '**/*.less', ['less']);
});

gulp.task('build', ['coffee', 'less']);
gulp.task('default', ['build', 'watch']);