#!/usr/bin/env bats

load "$BATS_PLUGIN_PATH/load.bash"

export BUILDKITE_REPO="test-org/test-repo"
export BUILDKITE_COMMIT="12345"

# Uncomment the following line to debug stub failures
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty
# export WHICH_STUB_DEBUG=/dev/tty

@test "builds an image with basic parameters set" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker 'build --tag foo/bar:baz -f Dockerfile . : echo basic parameters set'

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}


@test "builds an image with multiple tags set" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz1"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_1="foo/bar:baz2"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_2="foo/bar:baz3"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0 --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_1 --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_2 -f Dockerfile . : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "builds an image with a label set" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz1"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_0="label1=meow1"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0 --label $BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_0 -f Dockerfile . : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "builds an image with multiple labels set" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz1"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_0="label1=meow1"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_1="label2=value2"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_2="label3=value3"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0 --label $BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_0 --label $BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_1 --label $BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_2 -f Dockerfile . : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "builds an image with a custom Dockerfile" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_DOCKERFILE="foo/Dockerfile"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0 -f $BUILDKITE_PLUGIN_CONTAINER_BUILD_DOCKERFILE . : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "builds an image with a context path" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_CONTEXT="my/custom/path"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0 -f Dockerfile $BUILDKITE_PLUGIN_CONTAINER_BUILD_CONTEXT : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "builds an image with one tag set from docker-metadata file" {
  export DOCKER_METADATA_DIR="$(mktemp -d)"
  touch "$DOCKER_METADATA_DIR/tags"
  _TAGS_0="foo/bar:baz"
  echo "$_TAGS_0" >> "$DOCKER_METADATA_DIR/tags"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $_TAGS_0 -f Dockerfile . : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker

  rm -rf "$DOCKER_METADATA_DIR"
}

@test "builds an image with multiple tags set from docker-metadata file" {
  export DOCKER_METADATA_DIR="$(mktemp -d)"
  touch "$DOCKER_METADATA_DIR/tags"
  _TAGS_0="foo/bar:baz1"
  echo "$_TAGS_0" >> "$DOCKER_METADATA_DIR/tags"
  _TAGS_1="foo/bar:baz2"
  echo "$_TAGS_1" >> "$DOCKER_METADATA_DIR/tags"
  _TAGS_2="foo/bar:baz3"
  echo "$_TAGS_2" >> "$DOCKER_METADATA_DIR/tags"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $_TAGS_0 --tag $_TAGS_1 --tag $_TAGS_2 -f Dockerfile . : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker

  rm -rf "$DOCKER_METADATA_DIR"
}

@test "builds an image with a label set from docker-metadata file" {
  export DOCKER_METADATA_DIR="$(mktemp -d)"
  touch "$DOCKER_METADATA_DIR/tags"
  _TAGS_0="foo/bar:baz1"
  echo "$_TAGS_0" >> "$DOCKER_METADATA_DIR/tags"

  touch "$DOCKER_METADATA_DIR/labels"
  _LABELS_0="label1=meow1"
  echo "$_LABELS_0" >> "$DOCKER_METADATA_DIR/labels"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $_TAGS_0 --label $_LABELS_0 -f Dockerfile . : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "builds an image with multiple labels set from docker-metadata file" {
  export DOCKER_METADATA_DIR="$(mktemp -d)"
  touch "$DOCKER_METADATA_DIR/tags"
  _TAGS_0="foo/bar:baz1"
  echo "$_TAGS_0" >> "$DOCKER_METADATA_DIR/tags"

  touch "$DOCKER_METADATA_DIR/labels"
  _LABELS_0="label1=meow1"
  echo "$_LABELS_0" >> "$DOCKER_METADATA_DIR/labels"
  _LABELS_1="label2=value2"
  echo "$_LABELS_1" >> "$DOCKER_METADATA_DIR/labels"
  _LABELS_2="label3=value3"
  echo "$_LABELS_2" >> "$DOCKER_METADATA_DIR/labels"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $_TAGS_0 --label $_LABELS_0 --label $_LABELS_1 --label $_LABELS_2 -f Dockerfile . : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "builds an image with tags and labels set from environment and docker-metadata file" {
  export DOCKER_METADATA_DIR="$(mktemp -d)"
  touch "$DOCKER_METADATA_DIR/tags"
  _TAGS_0="foo/bar:baz1"
  echo "$_TAGS_0" >> "$DOCKER_METADATA_DIR/tags"
  _TAGS_1="foo/bar:baz2"
  echo "$_TAGS_1" >> "$DOCKER_METADATA_DIR/tags"
  _TAGS_2="foo/bar:baz3"
  echo "$_TAGS_2" >> "$DOCKER_METADATA_DIR/tags"

  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz4"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_1="foo/bar:baz4"

  touch "$DOCKER_METADATA_DIR/labels"
  _LABELS_0="label1=meow1"
  echo "$_LABELS_0" >> "$DOCKER_METADATA_DIR/labels"
  _LABELS_1="label2=value2"
  echo "$_LABELS_1" >> "$DOCKER_METADATA_DIR/labels"
  _LABELS_2="label3=value3"
  echo "$_LABELS_2" >> "$DOCKER_METADATA_DIR/labels"

  export BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_0="label4=value4"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_1="label5=value5"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker "build --tag $_TAGS_0 --tag $_TAGS_1 --tag $_TAGS_2 --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0 --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_1 --label $_LABELS_0 --label $_LABELS_1 --label $_LABELS_2 --label $BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_0 --label $BUILDKITE_PLUGIN_CONTAINER_BUILD_LABELS_1 -f Dockerfile . : echo basic parameters set"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "no docker in environment" {
  stub which 'docker : exit 1'
  stub buildkite-agent 'annotate --style error "Docker is not installed. Please install it first.<br />" --context publish --append : echo pushed buildkite agent message'

  run "$PWD/hooks/post-command"

  assert_failure
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
}

@test "no tags were found" {
  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style error "No tags were given either as a parameter or via the docker-metadata-buildkite-plugin<br />" --context publish --append : echo pushed buildkite agent message'

  run "$PWD/hooks/post-command"

  assert_failure
  assert_output --partial "No tags were given either as a parameter or via the docker-metadata-buildkite-plugin"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
}

@test "pushes an image with basic parameters set" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_PUSH=true
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message' \
    "annotate --style success 'Docker push succeeded for tag \`foo/bar:baz\`<br />' --context publish --append : echo pushed buildkite agent message for push"
  stub docker 'build --tag foo/bar:baz -f Dockerfile . : echo basic parameters set' \
    'push foo/bar:baz : echo pushed image'

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"
  assert_output --partial "pushed image"
  assert_output --partial "pushed buildkite agent message for push"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "pushes an image with multiple tags set" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_PUSH=true
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz1"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_1="foo/bar:baz2"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_2="foo/bar:baz3"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message' \
    "annotate --style success 'Docker push succeeded for tag \`foo/bar:baz1\`<br />' --context publish --append : echo pushed buildkite agent message for push 1" \
    "annotate --style success 'Docker push succeeded for tag \`foo/bar:baz2\`<br />' --context publish --append : echo pushed buildkite agent message for push 2" \
    "annotate --style success 'Docker push succeeded for tag \`foo/bar:baz3\`<br />' --context publish --append : echo pushed buildkite agent message for push 3"
  stub docker "build --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0 --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_1 --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_2 -f Dockerfile . : echo basic parameters set" \
    'push foo/bar:baz1 : echo pushed image 1' \
    'push foo/bar:baz2 : echo pushed image 2' \
    'push foo/bar:baz3 : echo pushed image 3'

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"
  assert_output --partial "pushed image 1"
  assert_output --partial "pushed image 2"
  assert_output --partial "pushed image 3"
  assert_output --partial "pushed buildkite agent message for push 1"
  assert_output --partial "pushed buildkite agent message for push 2"
  assert_output --partial "pushed buildkite agent message for push 3"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "builds image with multiple build arguments set" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_BUILD_ARGS_0="foo=bar"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_BUILD_ARGS_1="baz=qux"

  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message'
  stub docker 'build --tag foo/bar:baz --build-arg foo=bar --build-arg baz=qux -f Dockerfile . : echo basic parameters set'

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"

  unstub which
  unstub buildkite-agent
  unstub docker
}

@test "build with secret" {
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_PUSH=true
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0="foo/bar:baz1"
  export BUILDKITE_PLUGIN_CONTAINER_BUILD_SECRET_FILE="id=mysecret,src=secret-file"


  stub which 'docker : echo /usr/bin/docker'
  stub buildkite-agent 'annotate --style success "Docker build succeeded<br />" --context publish --append : echo pushed buildkite agent message' \
    "annotate --style success 'Docker push succeeded for tag \`foo/bar:baz1\`<br />' --context publish --append : echo pushed buildkite agent message for push 1"
  stub docker "build --tag $BUILDKITE_PLUGIN_CONTAINER_BUILD_TAGS_0 --secret $BUILDKITE_PLUGIN_CONTAINER_BUILD_SECRET_FILE -f Dockerfile . : echo basic parameters set" \
    'push foo/bar:baz1 : echo pushed image 1'

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "basic parameters set"
  assert_output --partial "Docker build succeeded"
  assert_output --partial "pushed buildkite agent message"
  assert_output --partial "pushed image 1"
  assert_output --partial "pushed buildkite agent message for push 1"


  unstub which
  unstub buildkite-agent
  unstub docker
}
