Домашнее задание к занятию «2.4. Инструменты Git»

Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом терраформа

https://github.com/hashicorp/terraform

В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены.

# Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.

PS C:\Users\PycharmProjects\terraform> git show aefea

commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545

Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>

Date:   Thu Jun 18 10:29:58 2020 -0400

Update CHANGELOG.md
# Какому тегу соответствует коммит 85024d3?

PS C:\Users\PycharmProjects\terraform> git show 85024d3

commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

Author: tf-release-bot <terraform@hashicorp.com>

Date:   Thu Mar 5 20:56:10 2020 +0000

v0.12.23
# Сколько родителей у коммита b8d720? Напишите их хеши.

git show --pretty=format:' %P' b8d720

56cd7859e05c36c06b56d013b55a252d0bb7e158

9ea88f22fc6269854151c571162c5bcf958bee2b

# Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

git log  v0.12.23..v0.12.24  --oneline

33ff1c03b (tag: v0.12.24) v0.12.24

b14b74c49 [Website] vmc provider links

3f235065b Update CHANGELOG.md

6ae64e247 registry: Fix panic when server is unreachable

5c619ca1b website: Remove links to the getting started guide's old location

06275647e Update CHANGELOG.md

d5f9411f5 command: Fix bug when using terraform login on Windows

4b6d06cc5 Update CHANGELOG.md

dd01a3507 Update CHANGELOG.md

225466bc3 Cleanup after v0.12.23 release

# Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

git log -S'func providerSource' --oneline

5af1e6234 main: Honor explicit provider_installation CLI config when present

8c928e835 main: Consult local directories as potential mirrors of providers

# Найдите все коммиты в которых была изменена функция globalPluginDirs.


git log -S globalPluginDirs

**commit 35a058fb3ddfae9cfee0b3893822c9a95b920f4c`

Author: Martin Atkins <mart@degeneration.co.uk>

Date:   Thu Oct 19 17:40:20 2017 -0700

main: configure credentials from the CLI config file


**commit c0b17610965450a89598da491ce9b6b5cbd6393f**``

Author: James Bardin <j.bardin@gmail.com>

Date:   Mon Jun 12 15:04:40 2017 -0400

prevent log output during init

The extra output shouldn't be seen by the user, and is causing TFE to
fail.


commit 8364383c359a6b738a436d1b7745ccdce178df47

Author: Martin Atkins <mart@degeneration.co.uk>

Date:   Thu Apr 13 18:05:58 2017 -0700

Push plugin discovery down into command package



Previously we did plugin discovery in the main package, but as we move

towards versioned plugins we need more information available in order to

resolve plugins, so we move this responsibility into the command package

itself.



For the moment this is just preserving the existing behavior as long as

there are only internal and unversioned plugins present. This is the

final state for provisioners in 0.10, since we don't want to support

versioned provisioners yet. For providers this is just a checkpoint along

the way, since further work is required to apply version constraints from

configuration and support additional plugin search directories.



The automatic plugin discovery behavior is not desirable for tests because

we want to mock the plugins there, so we add a new backdoor for the tests

to use to skip the plugin discovery and just provide their own mock

implementations. Most of this diff is thus noisy rework of the tests to

use this new mechanism.

# Кто автор функции synchronizedWriters?

git log -S'func synchronizedWriters' --pretty=format:'%h - %an %ae'

bdfea50cc - James Bardin j.bardin@gmail.com

5ac311e2a - Martin Atkins mart@degeneration.co.uk
