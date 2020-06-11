gcloud -q compute images delete adhocvm-image --project=imperial-legacy-232115 
gcloud -q compute instances delete adhoc-vm --project=imperial-legacy-232115 --zone=us-west1-a
> ./terraform.tfstate
terraform apply -auto-approve

#########################prepare host for /etc/hosts file
cat terraform.tfstate|grep network_ip|cut -d'"' -f4|awk '{print $1" adhoc-vm"}' > host_etc
sudo bash -c 'cat host_etc > /etc/hosts'
ssh-keygen -f "/home/shukla_chandan64/.ssh/known_hosts" -R adhoc-vm
ssh -o "StrictHostKeyChecking=no" -i ./keyfiles/privatekey.pem adhoc-vm "echo Adding Keys in Host"

#########################prepare hostlist for ansible
echo -e "[adhoc-vm]\nadhoc-vm ansible_ssh_private_key_file=./keyfiles/privatekey.pem\n[runner-vm]\nrunner-vm ansible_ssh_private_key_file=./keyfiles/privatekey.pem" > ./ansible_playbooks/ansible_host
cat /etc/hosts
cat ./ansible_playbooks/ansible_host
sleep 10s
ansible-playbook ./ansible_playbooks/pipinstall.yaml -i ./ansible_playbooks/ansible_host
ansible-playbook ./ansible_playbooks/install-python-packages.yaml -i ./ansible_playbooks/ansible_host
gcloud compute instances stop adhoc-vm --zone=us-west1-a
gcloud compute images create adhocvm-image --project=imperial-legacy-232115 --source-disk=adhoc-vm --source-disk-zone=us-west1-a
> ./terraform.tfstate
terraform apply -auto-approve ./restore_from_image 
ssh-keygen -f "/home/shukla_chandan64/.ssh/known_hosts" -R runner-vm
cat terraform.tfstate|grep network_ip|cut -d'"' -f4|awk '{print $1" runner-vm"}' > host_etc
sudo bash -c 'cat host_etc >> /etc/hosts'
