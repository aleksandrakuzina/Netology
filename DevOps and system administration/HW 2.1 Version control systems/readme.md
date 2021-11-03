тест 1

terraform:
как файлы будут игнорированы в будущем:

игнорируются файлы со следующим расширением:
*.tfvars

игнорируются файлы:
override.tf
override.tf.json
.terraformrc

игнорируются с любым началом названия файла _override.tf и _override.tf.json
*_override.tf
*_override.tf.json