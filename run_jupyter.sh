#!/bin/bash

# Script utilizado para execução do playbook configure.yaml nas máquinas do inventorio.
# Este script não deve ser alterado

source ./vars.sh

$CONTAINER_CMD run --interactive --tty --rm \
  --env "CLAP=$CLAP" \
  --env "CLAP_PATH=$CLAP_PATH" \
  --env "HOME=$VOLUME_DIR" \
  --env "SHELL=/bin/bash" \
  --publish $JUPYTER_PORT:$JUPYTER_PORT \
  --workdir $VOLUME_DIR \
  --volume $VOLUME_DIR:$VOLUME_DIR \
  $CONTAINER_IMAGE bash -c 'export PATH=$CLAP:$PATH; jupyter-lab --allow-root '"--port $JUPYTER_PORT "'--no-browser --ip="0.0.0.0" --NotebookApp.token="" --NotebookApp.password=""'
