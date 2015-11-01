provider = require './provider'

module.exports =
  activate: -> provider.loadProperties()

  getProvider: -> provider

# AtomAutocompleteErlangView = require './atom-autocomplete-erlang-view'
# {CompositeDisposable} = require 'atom'
#
# module.exports = AtomAutocompleteErlang =
#   atomAutocompleteErlangView: null
#   modalPanel: null
#   subscriptions: null
#
#   activate: (state) ->
#     @atomAutocompleteErlangView = new AtomAutocompleteErlangView(state.atomAutocompleteErlangViewState)
#     @modalPanel = atom.workspace.addModalPanel(item: @atomAutocompleteErlangView.getElement(), visible: false)
#
#     # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
#     @subscriptions = new CompositeDisposable
#
#     # Register command that toggles this view
#     @subscriptions.add atom.commands.add 'atom-workspace', 'atom-autocomplete-erlang:toggle': => @toggle()
#
#   deactivate: ->
#     @modalPanel.destroy()
#     @subscriptions.dispose()
#     @atomAutocompleteErlangView.destroy()
#
#   serialize: ->
#     atomAutocompleteErlangViewState: @atomAutocompleteErlangView.serialize()
#
#   toggle: ->
#     console.log 'AtomAutocompleteErlang was toggled!'
#
#     if @modalPanel.isVisible()
#       @modalPanel.hide()
#     else
#       @modalPanel.show()
