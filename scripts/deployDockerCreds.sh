#!/bin/bash
set -x
#
# This script is intended to be a helper to distribute the docker configuration file that includes docker hub credentials to the linux nodes.
# It assumes the ~/docker.tar.gz has been created per the following instructions and is in the same directory as this script.
# How to capture docker repo credentials for non-enterprise DC\OS deployments > https://docs.mesosphere.com/1.11/deploying-services/private-docker-registry/
# Set the key path and file name 
KEY="$HOME/.ssh/NAME_OF_KEYFILE"
KEYF="NAME_OF_KEYFILE"
USERNAME="AZURE_DEPLOYED_USERNAME"
# >>> MASTER_IP1 is extracted from Public IP resource prefixed "dcos-master-ip-" in Azure portal
# In a new RG the rest of the IP should match below configured assumptions
MASTER_IP1="40.114.72.22"
MASTER_IP2="192.168.255.6"
MASTER_IP3="192.168.255.7"
LINPUB_IP1="10.0.0.5"
LINPUB_IP2="10.1.0.5"
LINPUB_IP3="10.2.0.5"
LINPUB_IP4="10.3.0.5"
#
# SCP SSH key to master 1, and chmod it to make is usable
scp -i $KEY -P 2200 ${KEY} ${USERNAME}@${MASTER_IP1}:/home/${USERNAME}/.ssh/${KEYF}
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "chmod 600 /home/${USERNAME}/.ssh/${KEYF}"
# SCP docker auth file to master 1 and chmod it, then move it to /etc/.
scp -i $KEY -P 2200 docker.tar.gz ${USERNAME}@${MASTER_IP1}:/home/${USERNAME}/.
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "sudo chmod 766 ~/docker.tar.gz"
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "sudo cp ~/docker.tar.gz /etc/."
# SCP docker auth file to other master servers and chmod it
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "scp -o StrictHostKeyChecking=no -i /home/$USERNAME/.ssh/$KEYF ./docker.tar.gz ${USERNAME}@${MASTER_IP2}:/home/${USERNAME}/."
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${MASTER_IP2} "chmod 766 /home/${USERNAME}/docker.tar.gz""
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${MASTER_IP2} "sudo cp /home/$USERNAME/docker.tar.gz /etc/.""
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "scp -o StrictHostKeyChecking=no -i /home/$USERNAME/.ssh/$KEYF ./docker.tar.gz ${USERNAME}@${MASTER_IP3}:/home/${USERNAME}/."
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${MASTER_IP3} "chmod 766 /home/${USERNAME}/docker.tar.gz""
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${MASTER_IP3} "sudo cp /home/$USERNAME/docker.tar.gz /etc/.""
# SCP docker auth file to linux web nodes - 
# ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "scp -o StrictHostKeyChecking=no -i /home/$USERNAME/.ssh/$KEYF ./docker.tar.gz ${USERNAME}@${LINPUB_IP1}:/home/${USERNAME}/."
# ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${LINPUB_IP1} "chmod 600 /home/${USERNAME}/docker.tar.gz""
# ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${LINPUB_IP1} "sudo cp /home/$USERNAME/docker.tar.gz /etc/.""
# ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "scp -o StrictHostKeyChecking=no -i /home/$USERNAME/.ssh/$KEYF ./docker.tar.gz ${USERNAME}@${LINPUB_IP2}:/home/${USERNAME}/."
# ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${LINPUB_IP2} "chmod 600 /home/${USERNAME}/docker.tar.gz""
# ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${LINPUB_IP2} "sudo cp /home/$USERNAME/docker.tar.gz /etc/.""
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "scp -o StrictHostKeyChecking=no -i /home/$USERNAME/.ssh/$KEYF ./docker.tar.gz ${USERNAME}@${LINPUB_IP3}:/home/${USERNAME}/."
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${LINPUB_IP3} "chmod 766 /home/${USERNAME}/docker.tar.gz""
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${LINPUB_IP3} "sudo cp /home/$USERNAME/docker.tar.gz /etc/.""
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "scp -o StrictHostKeyChecking=no -i /home/$USERNAME/.ssh/$KEYF ./docker.tar.gz ${USERNAME}@${LINPUB_IP4}:/home/${USERNAME}/."
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${LINPUB_IP4} "chmod 766 /home/${USERNAME}/docker.tar.gz""
ssh -i $KEY -p 2200 -t ${USERNAME}@${MASTER_IP1} "ssh -i /home/$USERNAME/.ssh/$KEYF -t ${USERNAME}@${LINPUB_IP4} "sudo cp /home/$USERNAME/docker.tar.gz /etc/.""
