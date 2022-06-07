# Script contendo as váriaveis de ambiente necessárias para execução do Playbook
# Nota: As atualizações neste script não devem ser colocadas no seu git!
# Nota: Altere apenas os campos exigidos.

JUPYTER_PORT=8889			    # Default Jupyter Port
CONTAINER_CMD="docker"                      # Aplicação de container a ser utilizada
CONTAINER_IMAGE="mo833-clap"                # Nome da imagem
VOLUME_DIR="$(realpath $(pwd))"
WORK_DIR="$(realpath $(pwd))/CLAP"          # Diretório
CLAP="$(realpath $(pwd))/CLAP"              # CLAP implementation root dir
CLAP_PATH="$(realpath $(pwd))/clap_config"  # CLAP configs dir
