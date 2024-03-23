[![Build status](https://badge.buildkite.com/82cb3983db2dfb76450d7bba710cbde9ba6554fe09d24f9f84.svg)](https://buildkite.com/datum/container-build-buildkite-plugin)

# container-build

This Buildkite plugin will build a container, today supporting Dockerfiles; you pass the plugin a context path and a tag or a set of tags

## Example

Modify your `pipeline.yml` and add:

```yml
steps:
  - command: ls
    plugins:
      - datumforge/container-build#v1.0.0:
          tags:
          - 'datumforgeg/datum:latest'
```

The default settings will:

1. Build a container with the `[]tags` in the pipeline step
1. Use the `.` directory as the context path
1. Use Dockerfile as the specified file name to build from

## Configuration

### `dockerfile` (Optional, string)

Path to the Dockerfile to use. If not specified, the plugin will look for a `Dockerfile` file at the git repository root

### `context` (Optional, string)

Path to the context directory to use. If not specified, the plugin will use the `.` directory as the context path

### `secret-file` (Optional, string)

A string like 'id=mysecret,src=secret-file' where <secret-file> is the path in the build

### `tags` (Optional, array of strings)

Tags to use when building the container

### `labels` (Optional, array of strings)

Labels to use when building the container

### `build-args` (Optional, array of strings)

Build arguments to use when building the container

e.g. `build-args: ['MEOW=kitty', 'WIZBANG=shazam']`

### `push` (Optional, boolean)

If `true`, the plugin will push the container to a registry. Defaults to `false`

## Developing

Requires [taskfile](https://taskfile.dev/installation/) - `task lint` and `task test` to validate updates to the plugin