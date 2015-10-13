gulp = require 'gulp'
browserSync = require 'browser-sync'
runSequence = require 'run-sequence'
$    = do require "gulp-load-plugins"


# notification
plumberWithNotify = ->
  $.plumber({errorHandler: $.notify.onError("<%= error.message %>")})

###########
# BrowserSync
###########
gulp.task 'bs', ->
  browserSync.init(null, {
    server:
      baseDir: './public/'
  })

gulp.task 'bsReload', ->
  browserSync.reload()

###########
# javascript
###########
distScriptPath = './public/js/'
# distScriptName = 'main.js'
# useScriptFiles =  ['assets/js/jquery-1.8.1.min.js','assets/js/jquery.easing.1.3.js','assets/js/main.js']

# src内のファイルを対象に、webpackを通してdistディレクトリにコンパイルします
gulp.task 'webpack',->
  gulp.src 'assets/src/'
  .pipe $.webpack require "./webpack.config.coffee"
  .pipe gulp.dest distScriptPath

# coffee
# gulp.task 'compile-coffee',() ->
#   gulp.src 'assets/coffee/*.coffee'
#     .pipe plumberWithNotify()
#     .pipe $.coffee()
#     .pipe gulp.dest('assets/js/')

# # js concat
# gulp.task 'concat-js', ->
#   gulp.src useScriptFiles
#   .pipe plumberWithNotify()
#   .pipe $.concat distScriptName
#   .pipe gulp.dest distScriptPath


gulp.task 'js-opt',->
  runSequence('compile-coffee','concat-js')
  return

###########
# opt style
###########
# sass
distCssPath = 'public/css/'
distCssName = 'main.css'
useCssFiles = ['assets/css/normalize.css','assets/css/test.css']
gulp.task 'sass', ->
  gulp.src('assets/sass/**/*.scss')
  .pipe $.sass()
  .pipe gulp.dest('assets/css/')

gulp.task 'concat-css', ->
  gulp.src useCssFiles
  .pipe $.concat distCssName
  .pipe gulp.dest distCssPath

gulp.task 'css-opt',->
  runSequence('sass','concat-css')
  return

###########
# jade
###########
gulp.task 'jade',->
  gulp.src ['assets/jade/**/*.jade', '!assets/jade/**/layout.jade']
  .pipe($.data((file) ->
    require('./assets/data/')
  ))
  .pipe $.jade({pretty: true})
  .pipe gulp.dest 'public/'


###########
# default
###########
gulp.task 'default', ['bs'],->
  # $.watch 'assets/coffee/*.coffee',->
  #   gulp.start 'js-opt','bsReload'
  # ファイルの監視を設定
  $.watch "assets/src/**/*.+(coffee|js)", ->
    gulp.start 'webpack','bsReload'
  $.watch 'assets/sass/*.scss',->
    gulp.start 'css-opt','bsReload'
  $.watch 'assets/jade/**/*.jade', ->
    gulp.start 'jade','bsReload'