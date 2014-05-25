gulp = require 'gulp'
less = require 'gulp-less'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
rename = require 'gulp-rename'
gulpif = require 'gulp-if'
notify = require 'gulp-notify'
fs = require 'fs'

handleError = (err) ->
  this.emit 'end'

paths =
  source: {
    coffee: './coffee/**/*.coffee'
    less: './less/'
  },
  dest: {
    js: './public/js/'
    css: './public/css/'
  }

gulp.task 'coffee', ->
  gulp.src(paths.source.coffee)
    .pipe(coffee({bare: true}).on('error', handleError).on('error', notify.onError('<%= error.message %>')))
    .pipe gulp.dest(paths.dest.js)

gulp.task 'less', ->
  gulp.src(paths.source.less + 'main.less')
    .pipe(less().on('error', handleError).on('error', notify.onError('<%= error.message %>')))
    .pipe(rename({basename: 'style'}))
    .pipe gulp.dest(paths.dest.css)

gulp.task 'watch', ->
  gulp.watch paths.source.coffee, ['coffee']
  gulp.watch paths.source.less + '**/*.less', ['less']
  notify( -> console.log('test'); return 'test'; )

gulp.task 'copyConfig', ->
  gulp.src('./config/config.example')
    .pipe(gulpif(!fs.existsSync('./config/user.json'), rename({basename: 'user', extname: '.json'})))
    .pipe gulp.dest('./config/')

gulp.task 'build', ['coffee', 'less', 'copyConfig']
gulp.task 'default', ['build', 'watch']