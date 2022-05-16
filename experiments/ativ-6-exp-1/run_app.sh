cd ../..

NPROC=$1
NODES=$2
RANK=$3
IPMASTER=$4
PORT="1234"
BATCH=16
EPOCHS=1

docker run -p $PORT:$PORT --env OMP_NUM_THREADS=1 --rm --user=$(id -u):$(id -g) --network=host -v=$(pwd):/root dist_dcgan:latest python -m torch.distributed.launch \
--nproc_per_node=$NPROC --nnodes=$NODES --node_rank=$RANK --master_addr=$IPMASTER --master_port=$PORT root/dist_dcgan.py --dataset cifar10 --dataroot ./cifar10 \
--batch_size=$BATCH --num_epochs=$EPOCHS
