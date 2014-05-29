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
  templates: './templates/**/*.html'

dest =
  js: './public/js/'
  css: './public/css/'
  fonts: './public/fonts/'
  templates: './public/templates'

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
  gulp.watch source.fonts, ['font']
  gulp.watch source.templates, ['template']

gulp.task 'font', ->
  gulp.src(source.fonts)
    .pipe(flatten())
    .pipe gulp.dest(dest.fonts)

gulp.task 'template', ->
  gulp.src(source.templates)
    .pipe gulp.dest(dest.templates)

gulp.task 'build', ['coffee', 'less', 'font', 'template']
gulp.task 'default', ['build', 'watch']