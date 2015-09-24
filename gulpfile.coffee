gulp = require 'gulp'
coffee = require 'gulp-coffee'
browserSync = require 'browser-sync'
watch = require 'gulp-watch'
sass = require 'gulp-sass'
data = require 'gulp-data'
jade = require 'gulp-jade'
runSequence = require 'run-sequence'
concat = require 'gulp-concat'
uglify = require 'uglify-js'
rename = require 'gulp-rename'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'



# notification
plumberWithNotify = ->
  plumber({errorHandler: notify.onError("<%= error.message %>")})

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
# opt javascript
###########
distScriptPath = './public/js/'
distScriptName = 'main.js'
useScriptFiles =  ['assets/js/jquery-1.8.1.min.js','assets/js/jquery.easing.1.3.js','assets/js/test.js']
# coffee
gulp.task 'compile-coffee',() ->
  gulp.src 'assets/coffee/*.coffee'
    .pipe plumberWithNotify()
    .pipe coffee()
    .pipe gulp.dest('assets/js/')

# js concat
gulp.task 'concat-js', ->
  gulp.src useScriptFiles
  .pipe plumberWithNotify()
  .pipe concat distScriptName
  .pipe gulp.dest distScriptPath

# js minify
gulp.task 'minify-js', ->
  gulp.src distScriptPath+distScriptName
  .pipe plumberWithNotify()
  .pipe uglify()
  .pipe rename({extname:'.min.js'})
  .pipe gulp.dest distScriptPath


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
  .pipe sass()
  .pipe gulp.dest('assets/css/')

gulp.task 'concat-css', ->
  gulp.src useCssFiles
  .pipe concat distCssName
  .pipe gulp.dest distCssPath

gulp.task 'css-opt',->
  runSequence('sass','concat-css')
  return

###########
# jade
###########
gulp.task 'jade',->
  gulp.src ['assets/jade/**/*.jade', '!assets/jade/**/layout.jade']
  .pipe(data((file) ->
    require('./assets/data/')
  ))
  .pipe jade({pretty: true})
  .pipe gulp.dest 'public/'


###########
# default
###########
gulp.task 'default', ['bs'],->
  watch 'assets/coffee/*.coffee',->
    gulp.start 'js-opt','bsReload'
  watch 'assets/sass/*.scss',->
    gulp.start 'css-opt','bsReload'
  watch 'assets/jade/**/*.jade', ->
    gulp.start 'jade','bsReload'