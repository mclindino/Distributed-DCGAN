## ATIVIDADE 6 - Executando aplicações na nuvem computacional (AWS)
Todos os seguintes passos utilizam o painel EC2 Management Console da AWS: 

#### PASSO 1: Configuração da rede de interconexão

- Acessar Security groups na aba Redes e Segurança;
- Criar um grupo de segurança:
  - Adicionar um nome e descrição do grupo;
  - Adicionar regra de entrada:
    - Tipo SSH;
    - Porta 22;
    - Origem qualquer lugar - 0.0.0.0/0.
- Editar o grupo recém criado para adicionar uma nova regra de entrada:
  - Tipo: Todo o tráfego;
  - Origem: o próprio grupo de segurança.

#### PASSO 2: Criando instâncias das máquinas virtuais
- Acessar Executar Instância no painel Instâncias;
- Criar 2 novas instâncias com as seguintes especificações:
  - Imagem: Ubuntu Server 20.04 LTS;
  - Tipo: t2.medium;
  - Editar configurações de rede para utilizar o grupo de segurança criado anteriormente;
  - Armazenamento: 32 GiB
  - Adicionar nos dados do usuário o seguinte código bash para a instalação do docker nas instâncias:
    ```
    #!/bin/bash
    sudo apt update && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt update
    sudo apt install docker-ce -y && sudo usermod -aG docker ubuntu
    ```
    
#### PASSO 3: Build e Run da aplicação (GAN)
- Acessar as duas instâncias via SSH utilzando o IP Público;
- Clonar o repositório https://github.com/mclindino/Distributed-DCGAN/;
- Ir para a branch ativ-6-exp-1;
- Rodar o script build_app.sh;
- Rodar o script run_app.sh, no qual possui os seguintes parâmetros:
  - NPROC = quantidade de processos para cada nodo da rede;
  - NODES = quantidade de nodos na rede;
  - RANK = rank do nodo (master = 0 e slave > 0);
  - IPMASTER = IP da máquina mestre.

_Modifiar os parâmetros como mostrado no exemplo desse repositório_
_Também é possível mudar o batch_size e epochs mudando manualmente no script run_app.sh_
