resource "null_resource" "beforestart" {

  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml -vvvv ../ansible/beforestart.yml"
  }

  depends_on = [
    local_file.inventory
  ]
}


resource "null_resource" "playbook" {

  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory.yml -vvvv ../ansible/playbook.yml"
    on_failure = continue
  }

  depends_on = [
    null_resource.beforestart
  ]
}
