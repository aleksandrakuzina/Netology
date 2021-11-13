# легковесный тэг

> git tag
> v0.0
> v0.1

# аннотированный тэг

> git show v0.1
> tag v0.1
> Tagger: Aleksandra_Kuzina <alleksandra.kuzina@gmail.com>
> Date:   Sat Nov 13 15:45:42 2021 +0300

annotirovanny tag

commit 50b14422784c163894d52543914a3053b7043735 (HEAD -> master, tag: v0.1, origin/master, origin/HEAD, origin-ssh/master, gitlab/master, gitlab-ssh/master)
Author: Aleksandra_Kuzina <alleksandra.kuzina@gmail.com>
Date:   Sat Nov 6 11:25:00 2021 +0300

уточнены комментарии в файле readme.md для HW.2.1 (.gitignore расшифровка)
diff --git a/DevOps and system administration/HW 2.1 Version control systems/readme.md b/DevOps and system administration/HW 2.1 Version control systems/readme.md
index 09e24f2..ae62e86 100644
--- a/DevOps and system administration/HW 2.1 Version control systems/readme.md
+++ b/DevOps and system administration/HW 2.1 Version control systems/readme.md
@@ -1,16 +1,35 @@
-тест 1

-terraform:
-как файлы будут игнорированы в будущем:
+##файл .gitignore. Как файлы будут игнорированы в будущем?

-игнорируются файлы со следующим расширением:
-*.tfvars

-игнорируются файлы:
-override.tf
-override.tf.json
-.terraformrc
+## * */.terraform/ *
+игнорировать все файлы или катологи перед каталогом /.terraform/ и все внутри каталога

+#*.tfstate
+игнорировать все варианты файла с расширением .tfstate
+
+# * *.tfstate.* *
+игнорировать все файлы или каталоги, перед скрытым файлом или каталогом .tfstate и все файлы или подкаталоги после него
+
+# crash.log
+игнорировать всеlog-файлы (все события что регистрируются и все что поисходит с моим устройством в момент аварии программного обеспечения)
+
+# *.tfvars
+файлы c расширением .tfvars игнорируются
+
+# override.tf
+файл override.tf игнорируется
+
+# override.tf.json
+файл override с расширением .tf и .json игнорируется
tag v0.1
Tagger: Aleksandra_Kuzina <alleksandra.kuzina@gmail.com>
Date:   Sat Nov 13 15:45:42 2021 +0300

annotirovanny tag

commit 50b14422784c163894d52543914a3053b7043735 (HEAD -> master, tag: v0.1, origin/master, origin/HEAD, origin-ssh/master, gitlab/master, gitlab-ssh/master)
Author: Aleksandra_Kuzina <alleksandra.kuzina@gmail.com>
Date:   Sat Nov 6 11:25:00 2021 +0300

уточнены комментарии в файле readme.md для HW.2.1 (.gitignore расшифровка)++

--- a/DevOps and system administration/HW 2.1 Version control systems/terraform/.gitignore

+++ b/DevOps and system administration/HW 2.1 Version control systems/terraform/.gitignore



## Задание №2 – Теги

Представьте ситуацию, когда в коде была обнаружена ошибка - надо вернуться на предыдущую версию кода,
исправить ее и выложить исправленный код в продакшн. Мы никуда код выкладывать не будем, но пометим некоторые коммиты тегами и
создадим от них ветки.

1. Создайте легковестный тег `v0.0` на HEAD коммите и запуште его во все три добавленных на предыдущем этапе `upstream`.
2. Аналогично создайте аннотированный тег `v0.1`.
3. Перейдите на страницу просмотра тегов в гитхабе (и в других репозиториях) и посмотрите, чем отличаются созданные теги.
   * В гитхабе – [https://github.com/YOUR_ACCOUNT/devops-netology/releases](https://github.com/YOUR_ACCOUNT/devops-netology/releases)
   * В гитлабе – [https://gitlab.com/YOUR_ACCOUNT/devops-netology/-/tags](https://gitlab.com/YOUR_ACCOUNT/devops-netology/-/tags)
   * В битбакете – список тегов расположен в выпадающем меню веток на отдельной вкладке.
