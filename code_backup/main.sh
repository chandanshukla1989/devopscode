terraform init /home/shukla_chandan64/gitpush
gcloud -q compute images delete adhocvm-image --project=imperial-legacy-232115 
gcloud -q compute instances delete adhoc-vm --project=imperial-legacy-232115 --zone=us-west1-a
> /home/shukla_chandan64/gitpush/terraform.tfstate
terraform apply -auto-approve /home/shukla_chandan64/gitpush

#########################prepare host for /etc/hosts file
cat terraform.tfstate|grep network_ip|cut -d'"' -f4|awk '{print $1" adhoc-vm"}' > host_etc
sudo bash -c 'cat host_etc > /etc/hosts'
ssh-keygen -f "/home/shukla_chandan64/.ssh/known_hosts" -R adhoc-vm
chmod 400 /home/shukla_chandan64/keyfiles/privatekey.pem
ssh -o "StrictHostKeyChecking=no" -i /home/shukla_chandan64/keyfiles/privatekey.pem adhoc-vm "echo Adding Keys in Host"

#########################prepare hostlist for ansible
#echo -e "[adhoc-vm]\nadhoc-vm ansible_ssh_private_key_file=/home/shukla_chandan64/gitpush/keyfiles/privatekey.pem\n[runner-vm]\nrunner-vm ansible_ssh_private_key_file=/home/shukla_chandan64/gitpush/keyfiles/privatekey.pem" > /home/shukla_chandan64/gitpush/ansible_playbooks/ansible_host
cat /etc/hosts
cat /home/shukla_chandan64/gitpush/ansible_playbooks/ansible_host
sleep 10s
ansible-playbook /home/shukla_chandan64/gitpush/ansible_playbooks/pipinstall.yaml -i /home/shukla_chandan64/gitpush/ansible_playbooks/ansible_host
ansible-playbook /home/shukla_chandan64/gitpush/ansible_playbooks/install-python-packages.yaml -i /home/shukla_chandan64/gitpush/ansible_playbooks/ansible_host
gcloud compute instances stop adhoc-vm --zone=us-west1-a
gcloud compute images create adhocvm-image --project=imperial-legacy-232115 --source-disk=adhoc-vm --source-disk-zone=us-west1-a
> ./terraform.tfstate
gcloud -q compute instances delete runner-vm --project=imperial-legacy-232115 --zone=us-west1-a
terraform apply -auto-approve /home/shukla_chandan64/gitpush/restore_from_image 
ssh-keygen -f "/home/shukla_chandan64/.ssh/known_hosts" -R runner-vm
cat terraform.tfstate|grep network_ip|cut -d'"' -f4|awk '{print $1" runner-vm"}' > host_etc
sudo bash -c 'cat host_etc >> /etc/hosts'
