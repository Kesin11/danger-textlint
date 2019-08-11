# danger-textlint
[![Gem Version](https://badge.fury.io/rb/danger-textlint.svg)](https://badge.fury.io/rb/danger-textlint)
[![Build Status](https://travis-ci.org/Kesin11/danger-textlint.svg?branch=master)](https://travis-ci.org/Kesin11/danger-textlint)
[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2FKesin11%2Fdanger-textlint%2Fbadge&style=flat)](https://actions-badge.atrox.dev/Kesin11/danger-textlint/goto)


[Danger](http://danger.systems/ruby/) plugin for [textlint](https://textlint.github.io/).

## Installation

    $ gem install danger-textlint

`danger-textlint` needs `textlint` to lint your files. Please check the [installation guide](https://github.com/textlint/textlint#installation) and install it before you run Danger.

`danger-textlint` will first try local `node_modules/.bin/textlint` then the global `textlint`.  
My recommend is installing `textlint` in local. Create package.json (`npm init`) and then install (`npm i textlint`).

## Usage

<blockquote>Run textlint and send violations as inline comment.
<pre>
# Lint added and modified files only
textlint.lint
</pre>
</blockquote>

<blockquote>Keep severity until warning. It allows merging pull request if there are violations remaining.
<pre>
textlint.max_severity = "warn"
textlint.lint
</pre>
</blockquote>

#### Attributes

`config_file` - .textlintrc path

`max_severity` - Set max danger reporting severity
choice: nil or "warn"

#### Methods

`lint` - Execute textlint and send comment

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
