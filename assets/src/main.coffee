$  = require "jquery"
sample = require './sample'
$ ->
  $('body').css {background:'yellow'}
  sample()
  console.log 'main!dayo!!'