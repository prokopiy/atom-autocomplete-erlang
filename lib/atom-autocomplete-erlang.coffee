provider = require './provider-erlang.coffee'

module.exports =
  activate: ->
    provider.loadProperties()

  getProvider: ->
    provider

  deactivate: ->
    @provider?.dispose()
    @provider = null
