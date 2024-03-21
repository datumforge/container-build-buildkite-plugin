[![Build status](https://badge.buildkite.com/df549c652f77fa3660f4d7f975fd3bb5744e12fb4066719553.svg?branch=main)](https://buildkite.com/datum/template-buildkite-plugin)

# Template Buildkite Plugin

Check the [buildkite organization](https://github.com/buildkite-plugins) or [website](https://buildkite.com/plugins) to see if your plugin already exists or we can contribute to it !

Be sure to update this readme with your plugin information after using the template repository - for more info checkout Buildkite's documentation [here](https://buildkite.com/docs/plugins)

## Example

Provide an example of using this plugin, like so:

Add the following to your `pipeline.yml`:

```yml
steps:
  - command: ls
    plugins:
      - a-github-user/template#v1.0.0:
          pattern: '*.md'
```

## Developing

Provide examples on how to modify and test, e.g.:

To run the linter:
```shell
task lint
```

To run the tests:

```shell
task test
```