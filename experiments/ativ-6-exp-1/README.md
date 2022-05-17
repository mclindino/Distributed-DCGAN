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
- Criar N novas instâncias com as seguintes especificações:
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
- Acessar as N instâncias via SSH utilzando o IP Público;
- Clonar o repositório https://github.com/mclindino/Distributed-DCGAN/;
- Ir para a branch ativ-6-exp-1;
- Rodar o script build_app.sh;
- Rodar o script run_app.sh, no qual possui os seguintes parâmetros:
  - NPROC = quantidade de processos para cada nodo da rede;
  - NODES = quantidade de nodos na rede;
  - RANK = rank do nodo (master = 0 e slave > 0);
  - IPMASTER = IP Privado da máquina mestre.
 
 - Exemplo de aplicação:
    - Criação de duas instâncias no mesmo grupo de segurança;
    - Comando utilizado na instância 1:
      ```
      ./build_app.sh
      ./run_app.sh 1 2 0 172.31.82.2
      ```
    - Comando utilizado na instância 2:
      ```
      ./build_app.sh
      ./run_app.sh 1 2 1 172.31.91.201
      ```
    - Resultados obtidos:
      - node_0.out
      ```
      Rank: 0, Epoch: 0, Training ...
      [epoch: 0/1][iteration: 0/1563][rank: 0] Loss_D: 1.4761, Loss_G: 4.8173, D(x): 0.6078, D(G(z)): 0.6129 / 0.0084, iteration time: 1.4091s
      [epoch: 0/1][iteration: 1/1563][rank: 0] Loss_D: 0.8462, Loss_G: 3.4368, D(x): 0.5805, D(G(z)): 0.2374 / 0.0329, iteration time: 1.2433s
      ```
      - node_1.out
      ```
      Rank: 1, Epoch: 0, Training ...
      [epoch: 0/1][iteration: 0/1563][rank: 1] Loss_D: 1.5063, Loss_G: 4.8173, D(x): 0.5865, D(G(z)): 0.6129 / 0.0084, iteration time: 1.4221s
      [epoch: 0/1][iteration: 1/1563][rank: 1] Loss_D: 0.9642, Loss_G: 3.4368, D(x): 0.5177, D(G(z)): 0.2374 / 0.0329, iteration time: 1.2336s
      ```

_Modifiar os parâmetros como mostrado no exemplo desse repositório_

_Também é possível mudar o batch_size e epochs mudando manualmente no script run_app.sh_
