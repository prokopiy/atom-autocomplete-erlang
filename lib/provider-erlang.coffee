# {BufferedProcess} = require 'atom'
PromiseModFun = require './promise-mod_fun.coffee'
# RegexPatterns = require './regexp-patterns.coffee'


module.exports =
  selector: '.source.erlang'

  loadProperties: ->
    {}
    # @properties = {}

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
    prefix = PromiseModFun.isModFunDef({editor, bufferPosition, scopeDescriptor, prefix, activatedManually})
    if prefix? && prefix.length > 0
      modulename = PromiseModFun.getModuleName(prefix)
      functionPrefix = PromiseModFun.getFunctionPrefix(prefix)
      if modulename.length > 0
        return PromiseModFun.getPromise(modulename, functionPrefix)
