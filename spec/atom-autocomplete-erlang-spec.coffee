AtomAutocompleteErlang = require '../lib/atom-autocomplete-erlang'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomAutocompleteErlang", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('atom-autocomplete-erlang')

  describe "when the atom-autocomplete-erlang:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.atom-autocomplete-erlang')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'atom-autocomplete-erlang:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.atom-autocomplete-erlang')).toExist()

        atomAutocompleteErlangElement = workspaceElement.querySelector('.atom-autocomplete-erlang')
        expect(atomAutocompleteErlangElement).toExist()

        atomAutocompleteErlangPanel = atom.workspace.panelForItem(atomAutocompleteErlangElement)
        expect(atomAutocompleteErlangPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'atom-autocomplete-erlang:toggle'
        expect(atomAutocompleteErlangPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.atom-autocomplete-erlang')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'atom-autocomplete-erlang:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        atomAutocompleteErlangElement = workspaceElement.querySelector('.atom-autocomplete-erlang')
        expect(atomAutocompleteErlangElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'atom-autocomplete-erlang:toggle'
        expect(atomAutocompleteErlangElement).not.toBeVisible()
