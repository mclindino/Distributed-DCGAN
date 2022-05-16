mkdir ../../cifar10
cd ../../cifar10
wget --no-check-certificate https://www.cs.toronto.edu/~kriz/cifar-10-python.tar.gz
tar -xvf cifar-10-python.tar.gz
cd

docker build -t dist_dcgan /home/ubuntu/Distributed-DCGAN/
