FROM python:3.9
# Install apt default packages
RUN apt update && apt install -y gcc g++ git libc6-dev libffi-dev libssl-dev rsync

# Bypass clap installation
COPY ./CLAP/requirements.txt /home
RUN pip install jupyterlab -r /home/requirements.txt && rm /home/requirements.txt
