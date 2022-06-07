# Atividade 9: Semana 30/05

## Objetivo

O objetivo desta atividade é aprender a criar um aglomerado computacional e implamentar uma aplicação utilizando APIs programáticas.

## Descrição

Nesta atividade, você deve utilizar o [CLAP](https://github.com/lmcad-unicamp/CLAP) para levantar um aglomerado computacional e criar ações para instalar, executar e coletar resultados da [DCGAN](https://github.com/eborin/Distributed-DCGAN.git).
Em suma, você deve implementar um papel denominado `dcgan` que contenha 3 ações:

- `setup`: Esta ação instala as aplicações necessárias para execução da [DCGAN](https://github.com/eborin/Distributed-DCGAN.git), monta um sistema de arquivos compartilhado e cria a imagem docker. 
Esta ação é executada sempre que este papel é atribuido a um nó;
- `run`: Executa a DCGAN nos nós; e
- `results`: Copia os resultados

O código deve ser realizado utilizando a API do [CLAP](https://github.com/lmcad-unicamp/CLAP), em Python, utilizando Jupyter Notebooks. 
Para tanto, uma infraestrutura básica é disponibilizada e os detalhes são descritos na seção seguinte.

## Infraestrutura para execução do CLAP

Esta seção descreve a infraestrutura disponibilizada e sua forma de uso.
Utilizaremos o termo "máquina local" para designar a máquina que será utilizada para realização da atividade e execução do Ansible e o termo "máquina remota" para designar a máquina virtual na nuvem computacional em que a aplicação será executada. 

### Requisitos

Para execução da atividade, você precisará:
- Possuir seu identificador da chave de acesso e identificador da chave de acesso secreta (`Access Key ID` e `Secret access key`, respectivamente) consigo. 
Estes foram enviados por e-mail;
- Possuir um par de chaves (pública e privada) registrados na AWS, bem como o nome deste par de chaves (`KEYPAIR_NAME`). Este par de chaves é o mesmo utilizado para acessar uma máquina virtual por SSH.
- Possuir a aplicação Docker instalada na máquina local para execução do CLAP.


### Infraestrutura

O presente repositório deve ser clonado e executado apenas na máquina local. 
O clone deve ser realizado com o comando abaixo:

```
git clone --recurse-submodules https://github.com/eborin/mo833-atividade9.git
```


Este diretório conta com a seguinte estrutura principal:
- ``atividade9.ipynb``: *Jupyter notebook* onde a atividade deve ser testada.
- ``build_docker.sh``: *Script* para gerar a imagem Docker, que contém o CLAP. A imagem gerada é chamada `mo833-clap`. Este arquivo não deve ser alterado;
- ``Dockerfile.dev``: Arquivo de descrição da imagem Docker, utilizado pelo *script* `build_docker.sh`. Este arquivo não deve ser alterado;
- ``run_jupyter.sh``: *Script* para executar o jupyter-lab. Ao executar o script um servidor jupyer-lab estará executando e escutando na porta 8888 (que pode ser alterada no arquivo `vars.sh`, caso deseja) e poderá ser acessado a partir do endereço `localhost:8888`.
- ``vars.sh``: *Script* contendo variáveis globais de ambiente utilizadas para diversas finalidades. Nota: as alterações neste *script* **NÃO** devem ser submetidas ao git;
- ``CLAP/``: diretório contendo a implementação do CLAP; e
- ``clap_config``: Diretório contendo os arquivos de configuração do CLAP (equivalente ao `~/.clap`)

Dois *templates* de máquinas virtuais são disponibilizados: `type-t2.small` e `type-t2.medium`. Estes estão definidos no arquivo `clap_config/config/instances.yaml`.

### Preparação do ambiente para execução

Para preparação do ambiente, os seguintes passos devem ser realizados:

1. Instale o Docker na máquina local e gere a imagem Docker executando o *script* `build_docker.sh`. Este passo pode ser realizado apenas uma vez.

2. Escreva o seu `Access Key ID` em um arquivo denominado `ec2_access_key.pub` e o seu `Secret access key` em um arquivo chamado `ec2_access_key.pem`. Estes arquivos devem ser salvos dentro do diretório `clap_config/private/`.

3. Copie sua chave privada, utilizada para acessar as máquinas da AWS, para o diretorio `clap_config/private` e renomei-a para `key.pem`. Copie também sua chave pública para o diretorio `clap_config/private` e renomei-a para `key.pub`. Vale ressaltar que a chave pública pode ser gerada a partir da chave privada, utilizando o seguinte comando: `ssh-keygen -y -f key.pem > key.pub`. Além disso, o campo `keypair_name` do arquivo `clap_config/config/logins.yaml` deve ser alterado para o respectivoe seu `KEYPAIR_NAME`.

4. Execute o *script* `run_jupyter.sh` que irá iniciar um servidor jupyter-lab na máquina local. Este pode ser acessado através do endereço `localhost:8888` por um navegador de sua preferência.

5. Uma vez iniciado, o notebook `atividade9.ipynb` pode ser utilizado.

Vale ressaltar que o jupyter-lab também permite a instanciação de um terminal, ao clicar no icone `+`, no canto superior esquerdo e selecionando a opção `terminal`. 
Os comandos do CLAP podem ser executados em linha de comando diretamente por este terminal. 
Por exemplo, para listar os templates de máquinas, o comando `clapp node list-templates` pode ser executado. Este exibe a seguinte informação.

```
* name: type-t2.small
    provider config id:` aws-config-us-east-1`
    login config id: `login-ubuntu`

* name: type-t2.medium
    provider config id:` aws-config-us-east-1`
    login config id: `login-ubuntu`

Listed 2 instance configs
```

### Implementação do papel DCGAN

Para esta atividade, você deve criar um papel chamado `dcgan` que contenha as ações `setup`, `run` e `results`. Por simplicidade, a definição deste papel já foi criada e se encontra em `clap_config/roles/actions.d/dcgan.yml` e pode ser alterada, caso deseje. As ações a serem implementadas são:

- A ação `setup` deve ser implementada pelo *playbook* `clap_config/roles/roles/dcgan_setup.yaml`. Esta ação deve instalar a [DCGAN](https://github.com/eborin/Distributed-DCGAN.git), montar um sistema de arquivos compartilhado e criar a imagem docker. **Nota**: assuma que o repositório da [DCGAN](https://github.com/eborin/Distributed-DCGAN.git) e os dados já se encontram no sistema de arquivos compartilhado, no diretório do seu usuário.

- A ação `run` deve é implementada pelo *playbook* `clap_config/roles/roles/dcgan_run.yaml` e deve executar o aprendizado distribuído da DCGAN por 2 épocas, utilizando todos os nós do aglomerado e utilizando como entrada os dados de teste do CIFAR-10, disponível em um diretório identificado pela variável `cifar_data_dir`, e produzindo a saída no diretório identificado pela variável `results_dir`. Note que cada nó deve executar a aplicação com parametros diferentes em sua execução. 
Cada nó deve utilizar um valor de `node_rank` distinto para o parâmetro `--node_rank` e o parametro `master_addr` da aplicação deve ser preenchido com o endereço do nó com nome `master_hostname`. 
Além disso, a saída da aplicação deve ser redirecionada e guardada um arquivo `output-XXX.txt`, onde `XXX` corresponde ao `node_rank` do nó que está executando a aplicação. 

- A ação `results` deve é implementada pelo *playbook* `clap_config/roles/roles/dcgan_results.yaml` e deve coletar os resultados das máquinas remotas para um diretorio indicado por uma váriavel denominada `results_dir`, na máquina local.


### Condução de Experimentos

Para esta atividade, você deve utilizar o *notebook* `atividade9.ipynb`. 
Este *notebook* instancia dois nós do tipo `type-t2.medium` na nuvem computacional e retorna seus respectivos `node_ids` que podem ser utilizados pelo CLAP. 
Este notebook também:
1. Adiciona o papel `dcgan` aos nós recém-criados utilizando o método `add_role` do objeto `role_manager` da classe `RoleManager`. 
Note que a ação `setup` será implicitamente invocada ao executar este método.
2. Executa a ação `run` do papel `dcgan` nos nós recém-criados utilizando o método `perform_action` do objeto `role_manager` da classe `RoleManager`.
3. Executa a ação `results` do papel `dcgan` nos nós recém-criados utilizando o método `perform_action` do objeto `role_manager` da classe `RoleManager`.

Ao final, os nós são destruídos, utilizando o método `stop_nodes`, do objeto `node_manager` da classe `NodeManager`.

## Entrega e Avaliação

Para entrega, os arquivos `clap_config/roles/actions.d/dcgan.yml`, `clap_config/roles/roles/dcgan_setup.yaml`, `clap_config/roles/roles/dcgan_run.yaml`, `clap_config/roles/roles/dcgan_results.yaml` e `atividade9.ipynb` devem ser submetidos.
A submissão deve ser realizada até o dia 07/06/2021 às 13h59min, horário de Brasilia.

## Dicas e Observações
- **NÃO** submeta nenhum arquivo adicional.

- Seus arquivos não devem depender de arquivos externos. Além disso, nenhuma outra alteração deve ser realizada nos arquivos que não foram mencionados.

- Todas as *tasks* devem ser nomeadas.

- Você pode ir montando e executando seu *playbook* gradualmente e testar, sempre que possível.

- É mais fácil (e menos custoso) iniciar com um aglomerado pequeno, em vez de um grande

- Você pode, paralelamente, efetuar *login* na máquina remota para observar os efeitos realizados pelas *tasks* executadas.

- Você pode utilizar qualquer módulo embutido na instalação do Ansible, mas não deve instalar nenhum módulo adicional.

- Lembre-se de criar o direrório onde será montado o sistema de arquivos compartilhado EFS (`efs_mount_point`) antes de montá-lo. 
Talvez seja conveniente alterar as permissões do diretório, após montado para aberto (0777), utilizando o módulo `file` (com `recurse: True`).

- Antes de instalar pacotes, lembre-se de atualizar a lista de pacotes (veja a opção `update_cache` do módulo `apt`).

- A chave `become` com valor `true` (*e.g.* `become: true`) pode ser adicionada a uma *task* (ou *play*) para que ela seja executada como super usuário (*e.g.* *root*). 
Isto é util para *tasks* que necessitam de permissões elevadas (como instalação de pacotes, por exemplo).

- A chave `run_once` com valor `true` (*e.g.* `run_once: true`) pode ser adicionada a uma *task* para ela seja executada apenas um único *host* qualquer.

- Para longas tarefas (execução da aplicação ou construção da imagem Docker, por exemplo), o Ansible fornece as chaves [`pool`](https://docs.ansible.com/ansible/latest/user_guide/playbooks_async.html#asynchronous-playbook-tasks) e [`async`](https://docs.ansible.com/ansible/latest/user_guide/playbooks_async.html#asynchronous-playbook-tasks) para evitar desconexões SSH ao executar as tarefas. Valores como `pool: 30` e `async: 1200` podem ser razoáveis para as tarefas de execução daaplicação e criação da imagem Docker, caso necessite.

- Mais exemplos sobre o uso da API e da linha de comando podem ser encontrados no diretório `examples` do CLAP
