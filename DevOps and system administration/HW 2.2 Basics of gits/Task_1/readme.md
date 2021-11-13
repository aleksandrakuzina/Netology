bitbucket       https://bitbucketlady@bitbucket.org/bitbucketlady/devsys_dpc_2_kuzina_bitbucket.git (fetch)

bitbucket       https://bitbucketlady@bitbucket.org/bitbucketlady/devsys_dpc_2_kuzina_bitbucket.git (push)

bitbucket-ssh   git@bitbucket.org:bitbucketlady/devsys_dpc_2_kuzina_bitbucket.git (fetch)

bitbucket-ssh   git@bitbucket.org:bitbucketlady/devsys_dpc_2_kuzina_bitbucket.git (push)

gitlab  https://gitlab.com/aleksandrakuzina/devsys_dpc_2_kuzina_gitlubcreate.git (fetch)

gitlab  https://gitlab.com/aleksandrakuzina/devsys_dpc_2_kuzina_gitlubcreate.git (push)

gitlab-ssh      git@gitlab.com:aleksandrakuzina/devsys_dpc_2_kuzina_gitlubcreate.git (fetch)

gitlab-ssh      git@gitlab.com:aleksandrakuzina/devsys_dpc_2_kuzina_gitlubcreate.git (push)

origin  https://github.com/aleksandrakuzina/DevSys_DPC_2_Kuzina.git (fetch)

origin  https://github.com/aleksandrakuzina/DevSys_DPC_2_Kuzina.git (push)

origin-ssh      git@github.com:aleksandrakuzina/DevSys_DPC_2_Kuzina.git (fetch)

origin-ssh      git@github.com:aleksandrakuzina/DevSys_DPC_2_Kuzina.git (push)



## Задание №1 – Знакомимся с gitlab и bitbucket

Иногда при работе с git-репозиториями надо настроить свой локальный репозиторий так, чтобы можно было
отправлять и принимать изменения из нескольких удалённых репозиториев.
Это может понадобиться при работе над проектом с открытым исходным кодом, если автор проекта не дает права
на запись в основной репозиторий. Либо некоторые распределенные команды используют такой принцип работы, когда
каждый разработчик имеет свой репозиторий, а в основной репозиторий пушатся только конечные результаты
работы над задачами.

Так же у DevOps-специалиста должен быть хороший кругозор, поэтому давайте познакомимся с gitlab и bitbucket.

Создадим аккаунт в gitlab, если у вас его еще нет:

1. Gitlab. Страница регистрации [https://gitlab.com/users/sign_up](https://gitlab.com/users/sign_up), для регистрации можно использовать
   аккаунт google, github и другие.
2. После регистрации или авторизации в gitlab создайте новый проект, нажав на ссылку `Create a projet`.
   Желательно назвать также, как и в гитхабе `devops-netology` и `visibility level` выбрать `Public`.
3. Галочку `Initialize repository with a README` луше не ставить, чтобы не пришлось разрешать конфликты.
4. Если вы зарегистрировались при помощи аккаунта в другой системе и не указали пароль, то увидите сообщение
   `You won't be able to pull or push project code via HTTPS until you set a password on your account`.
   Тогда перейдите по ссылке из этого сообщения ([https://gitlab.com/profile/password/edit](https://gitlab.com/profile/password/edit))
   и задайте пароль.
   Если вы уже умеете пользоваться ssh ключами, то воспользуйтесь этой
   возможностью (подробнее про ssh мы поговорим в следующем учебном блоке).
5. Перейдите на страницу созданного вами репозитория, url будет примерно такой:
   [https://gitlab.com/YOUR_LOGIN/devops-netology](https://gitlab.com/YOUR_LOGIN/devops-netology) и изучите предлагаемые варианты для начала работы в репозитории в секции
   `Command line instructions`.
6. Запомните вывод команды `git remote -v`.
7. В связи с тем, что это будет наш дополнительный репозиторий, ни один вариант из перечисленных в инструкции (на странице
   вновь созданного репозитория) нам не подходит. Поэтому добавляем этот репозиторий как дополнительный `remote` к созданному
   репозиторию в рамках предыдущего домашнего задания:
   `git remote add gitlab https://gitlab.com/YOUR_LOGIN/devops-netology.git`.
8. Отправьте изменения в новый удалённый репозиторий `git push -u gitlab main`.
9. Обратите внимание как изменился результат работы команды `git remote -v`.

Теперь необходимо проделать все тоже самое с [https://bitbucket.org/](https://bitbucket.org/).

1. Обратите внимание, что репозиторий должен быть публичным, то есть отключите галочку `private repository` при создании репозитория.
2. И на вопрос `Include a README?` отвечаем отказом.
3. В отличии от гитхаба и гитлаба, в битбакете репозиторий должен принадлежать проекту, поэтому во время создания репозитория
   надо создать и проект, который можно назвать, например, `netology`.
4. Аналогично gitlab, на странице вновь созданного проекта выберите `https`, чтобы получить ссылку и добавьте этот репозиторий как
   `git remote add bitbucket ...`.
5. Обратите внимание, как изменился результат работы команды `git remote -v`.

Если все проделано правильно, то результат команды `git remote -v` должен быть следующий:

```shell position-relative overflow-auto
$ git remote -v
bitbucket https://andreyborue@bitbucket.org/andreyborue/devops-netology.git (fetch)
bitbucket https://andreyborue@bitbucket.org/andreyborue/devops-netology.git (push)
gitlab	  https://gitlab.com/andrey.borue/devops-netology.git (fetch)
gitlab	  https://gitlab.com/andrey.borue/devops-netology.git (push)
origin	  https://github.com/andrey-borue/devops-netology.git (fetch)
origin	  https://github.com/andrey-borue/devops-netology.git (push)
```

Дополнительно можете так же добавить удалённые репозитории по `ssh`, тогда результат будет примерно такой:

```shell position-relative overflow-auto
git remote -v
bitbucket	git@bitbucket.org:andreyborue/devops-netology.git (fetch)
bitbucket	git@bitbucket.org:andreyborue/devops-netology.git (push)
bitbucket-https	https://andreyborue@bitbucket.org/andreyborue/devops-netology.git (fetch)
bitbucket-https	https://andreyborue@bitbucket.org/andreyborue/devops-netology.git (push)
gitlab	git@gitlab.com:andrey.borue/devops-netology.git (fetch)
gitlab	git@gitlab.com:andrey.borue/devops-netology.git (push)
gitlab-https	https://gitlab.com/andrey.borue/devops-netology.git (fetch)
gitlab-https	https://gitlab.com/andrey.borue/devops-netology.git (push)
origin	git@github.com:andrey-borue/devops-netology.git (fetch)
origin	git@github.com:andrey-borue/devops-netology.git (push)
origin-https	https://github.com/andrey-borue/devops-netology.git (fetch)
origin-https	https://github.com/andrey-borue/devops-netology.git (push)
```

Выполните push локальной ветки `main` в новые репозитории.
Подсказка: `git push -u gitlab main`. На этом этапе история коммитов во всех трех репозиториях должна совпадать.
