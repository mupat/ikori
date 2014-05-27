gulp = require 'gulp'
less = require 'gulp-less'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
rename = require 'gulp-rename'
notify = require 'gulp-notify'
flatten = require 'gulp-flatten'
fs = require 'fs'

handleError = (err) ->
  this.emit 'end'

source =
  coffee: './coffee/**/*.coffee'
  less: './less/'
  fonts: './fonts/**/*.{eot,svg,ttf,woff}'

dest =
  js: './public/js/'
  css: './public/css/'
  fonts: './public/fonts/'

gulp.task 'coffee', ->
  gulp.src(source.coffee)
    .pipe(coffee({bare: true}).on('error', handleError).on('error', notify.onError('<%= error.message %>')))
    .pipe gulp.dest(dest.js)

gulp.task 'less', ->
  gulp.src(source.less + 'main.less')
    .pipe(less().on('error', handleError).on('error', notify.onError('<%= error.message %>')))
    .pipe(rename({basename: 'style'}))
    .pipe gulp.dest(dest.css)

gulp.task 'watch', ->
  gulp.watch source.coffee, ['coffee']
  gulp.watch source.less + '**/*.less', ['less']

gulp.task 'font', ->
  gulp.src(source.fonts)
    .pipe(flatten())
    .pipe gulp.dest(dest.fonts)

gulp.task 'build', ['coffee', 'less', 'font']
gulp.task 'default', ['build', 'watch']