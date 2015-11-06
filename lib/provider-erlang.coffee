{BufferedProcess} = require 'atom'
PromiseModFun = require './promise-mod_fun.coffee'
RegexPatterns = require './regexp-patterns.coffee'


erlangReservedWords = ["after", "and", "andalso", "band", "begin", "bnot", "bor", "bsl", "bsr", "bxor", "case", "catch",
"cond", "div", "end", "fun", "if", "let", "not",  "of", "or", "orelse", "receive", "rem", "try", "when", "xor"]




module.exports =
  selector: '.source.erlang'

  loadProperties: ->
    {}
    # @properties = {}

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
    prefix = @isModFunDef({editor, bufferPosition, scopeDescriptor, prefix, activatedManually})

    if prefix? && prefix.length > 0
      # atom.notifications.addSuccess "prfix=" + prefix
      modulename = @getModuleName(prefix)
      functionPrefix = @getFunctionPrefix(prefix)
      if modulename.length > 0
        return PromiseModFun.getPromise(modulename, functionPrefix)


  isModFunDef: ({editor, bufferPosition}) ->
    regex = new RegExp("(" + "#{RegexPatterns.erlangNames}" + ")\:(" + "#{RegexPatterns.erlangNames}" + ")*", "g")
    # atom.notifications.addSuccess regex.toString()
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    L = line.split(new RegExp("#{RegexPatterns.erlangNameSplitter}", "g")).slice(-1)[0]
    M = line.match(regex)?.slice(-1)[0] or ''
    # atom.notifications.addError L + "|" + M.length + "=" + bufferPosition.column
    if M == L
      M
    else
      ''

  getModuleName: (prefix) ->
    # atom.notifications.addSuccess prefix.toString()
    # regex = /([a-z]+[a-zA-Z0-9_]*):/
    # prefix2 = prefix.match(regex)?[0].trim()
    # name = prefix2.split(":", 2)[0]
    name = prefix.split(":", 2)[0]
    # atom.notifications.addSuccess "@erlangReservedWords=" + erlangReservedWords
    if name in erlangReservedWords
      ''
    else
      name

  getFunctionPrefix: (prefix) ->
    # regex = /:([a-z]+[a-zA-Z0-9_]*)*/
    # prefix.match(regex)?[0].trim()
    prefix.split(":", 2)[1]
