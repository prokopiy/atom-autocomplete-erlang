{BufferedProcess, CompositeDisposable} = require 'atom'
fs = require 'fs'
path = require 'path'

erlangReservedWords = ["after", "and", "andalso", "band", "begin", "bnot", "bor", "bsl",
  "bsr", "bxor", "case", "catch", "cond", "div", "end", "fun", "if", "let", "not",
  "of", "or", "orelse", "receive", "rem", "try", "when", "xor"]




module.exports =
  selector: '.source.erlang'

  loadProperties: ->
    {}
    # @properties = {}

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
    prefix = @getPrefix({editor, bufferPosition, scopeDescriptor, prefix, activatedManually})

    if prefix? and prefix.length > 0
      # atom.notifications.addSuccess "prfix=" + prefix
      # atom.notifications.addSuccess @genFunctionSnippetArg("myFunction", 4)
      modulename = @getModuleName(prefix)
      functionPrefix = @getFunctionPrefix(prefix)
      if modulename.length > 0
        # atom.notifications.addSuccess "modulename=" + modulename + "  functionPrefix=" + functionPrefix
        return @execute_erl_module_info(modulename, functionPrefix)


  getPrefix: ({editor, bufferPosition}) ->
    regex = /// (^|\s|\[|\(|\,)                  #begin of line
      ([a-z]+[a-zA-Z0-9_]*)        #first lowcase letters them one or more letters, numbers and _
      :                          #followed by an : sign
      (([a-z]+[a-zA-Z0-9_]*)|(\'([a-zA-Z0-9_\-\/\$\^]*)\'))*
      $ ///
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(regex)?[0] or ''

  getModuleName: (prefix) ->
    regex = /([a-z]+[a-zA-Z0-9_]*):/
    prefix2 = prefix.match(regex)?[0].trim()
    name = prefix2.split(":", 2)[0]
    # atom.notifications.addSuccess "@erlangReservedWords=" + erlangReservedWords
    if name in erlangReservedWords
      ''
    else
      name

  getFunctionPrefix: (prefix) ->
    # regex = /:([a-z]+[a-zA-Z0-9_]*)*/
    # prefix.match(regex)?[0].trim()
    prefix.split(":", 2)[1]


  execute_erl_module_info: (moduleName, functionPrefix) ->
    return new Promise (resolve) =>
      executablePath = 'erl'
      project_path = atom.project.getPaths()
      paPaths = []

      findDirSlash = (text) ->
        # atom.notifications.addError "text:" + text + text.indexOf("/").toString()
        if text.indexOf("/") >= 0
          "/"
        else
          "\\"

      addAllPaths = (top) ->
        ds = findDirSlash(project_path.toString())
        # atom.notifications.addError "1:" + top
        fl1 = fs.statSync top
        if fl1.isDirectory()
          # atom.notifications.addError "2:" + top + " is directory."
          paPaths.push top
          fs.readdirSync(top).filter(
            (item) ->
              # atom.notifications.addInfo "item  =" + top+ds+item.toString()
              addAllPaths(top+ds+item.toString())
          )

      addAllPaths(project_path.toString())

      erlc_args = []
      erlc_args.push "-pa", x for x in paPaths
      erlc_args.push '-noshell', '-eval', "io:format('~w~n', [#{moduleName}:module_info(exports)])", '-s', 'init', 'stop'


      # erl_args = ['-pa', project_path.toString(), '-noshell', '-eval', "io:format('~w~n', [#{module}:module_info(functions)])", '-s', 'init', 'stop']
      # atom.notifications.addInfo "#{erl_args}"
      atom.notifications.addInfo "#{erlc_args}"

      suggestion_stack = []
      compile_result = ""


      parse_erl_module_info = (text) ->
        object_stack = []
        # atom.notifications.addInfo "#{text}"
        res_pattern = /// (^)*
          \[
            \{
            (([a-z]+[a-zA-Z0-9_]*)|(\'([a-zA-Z0-9_\-\/\$\^]*)\'))
            \,
            ([0-9]+[0-9]*)*
            \}
            (
            \,
            \{
            (([a-z]+[a-zA-Z0-9_]*)|(\'([a-zA-Z0-9_\-\/\$\^]*)\'))
            \,
            ([0-9]+[0-9]*)
            \}
            )*
          \]
          $ ///g

        tupple_pattern = ///
          \{
          (([a-z]+[a-zA-Z0-9_]*)|(\'([a-zA-Z0-9_\-\/\$\^]*)\'))
          \,
          ([0-9]+[0-9]*)
          \}
          ///g

        tupple_to_object = (tupple) ->
          obj =
            name: "#{tupple.match(/[a-z]+[a-zA-Z0-9_]*/)}"
            arity: parseInt(tupple.match(/[0-9]+[0-9]*/), 10)
          # if obj.name.indexOf("#{functionPrefix}", 0) == 0
          #   atom.notifications.addError functionPrefix + " in " + obj.name + " = " + obj.name.indexOf "#{functionPrefix}", 0

        # sFilter = (x) ->
        genFunctionSnippetArg= (functionName, arg) ->
          args = ""
          if arg > 0
            args += "${1:arg1}"
            if arg > 1
              args += ", ${#{x}:arg#{x}}" for x in [2..arg]
          functionName + "(" + args + ")"

        object_to_suggestion = (aObj) ->
          # atom.notifications.addInfo "object_to_suggestion=" + aObj.name + "/" + aObj.arity
          suggestion =
            snippet: genFunctionSnippetArg(aObj.name, aObj.arity)
            replacementPrefix: "#{functionPrefix}"
            type: 'function'



        if (text.length > 0 && text.indexOf('[{') == 0) && true# text.match(res_pattern)?
          # atom.notifications.addInfo "VALID PATTERN"
          tupples = text.match(tupple_pattern)
          # atom.notifications.addInfo "tupples=" + tupples.toString()
          object_stack.push tupple_to_object(x) for x in tupples
          if "#{functionPrefix}".length > 0
            filtered_object_stack = object_stack.filter (x) -> x.name.indexOf("#{functionPrefix}", 0) == 0
          else
            filtered_object_stack = object_stack

          # atom.notifications.addInfo "filtered_object_stack=" + x.name + "/" + x.arity for x in filtered_object_stack
          suggestion_stack.push object_to_suggestion(x) for x in filtered_object_stack

        # else
        #   atom.notifications.addInfo "INVALID PATTERN"

        suggestion_stack


      process = new BufferedProcess
        command: executablePath
        args: erlc_args
        options:
          cwd: project_path[0] # Should use better folder perhaps
        stdout: (data) ->
          atom.notifications.addInfo('Test stdout:', detail: data, dismissable: {})
          compile_result += data.replace(/(\r\n|\n|\r)/gm,"");
        exit: (code) ->
          # atom.notifications.addError "On exit to run #{compile_result}"
          parse_erl_module_info("#{compile_result}")
          resolve suggestion_stack
      process.onWillThrowError ({error,handle}) ->
        atom.notifications.addError "Failed to run #{@executablePath}",
          detail: "#{error.message}"
          dismissable: true
        handle()
        resolve []
