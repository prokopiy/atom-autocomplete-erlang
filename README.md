# atom-autocomplete-erlang
[![Build Status](https://travis-ci.org/prokopiy/atom-autocomplete-erlang.svg?branch=master)](https://travis-ci.org/prokopiy/atom-autocomplete-erlang)
[![Package version!](https://img.shields.io/apm/v/atom-autocomplete-erlang.svg?)](https://atom.io/packages/atom-autocomplete-erlang)
[![Dependencies!](https://img.shields.io/david/prokopiy/atom-autocomplete-erlang.svg?)](https://david-dm.org/prokopiy/atom-autocomplete-erlang)

## Features
  - Autocompletion of global module functions
  - Autocompletion of local project module functions (those which compile successfully)
  - Adds snippets to Erlang files.

![A screencast](http://g.recordit.co/w2jPCRJlL4.gif)

## Requirements
  Must be installed Erlang/OTP and path to 'erl' executable file must be defined in OS.

  Recommended that your project has a standard directory structure with the design principles of OTP applications.

### Required packages
  [language-erlang](https://atom.io/packages/language-erlang)
  [autocomplete-plus](https://atom.io/packages/autocomplete-plus)
  [autocomplete-snippets](https://atom.io/packages/autocomplete-snippets)

apm publish patch
