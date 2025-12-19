## Тестовое задание № А1

### Dockerfile

```yaml
FROM nginx:alpine
COPY ./data/* /usr/share/nginx/html/.
```
Официалы сообщают, что порт 80 is already exposed. 

Билд:
```bash
docker build -t my-web-app:latest .
```
Запуск: 
```bash
docker run -d --name testapp -p 8080:80 my-web-app:latest
```
### Размышления
Два способа, bind mount тома, либо копирование в контейнер:
```bash
docker run -d -p 8080:80 -v $(pwd)/data/:/usr/share/nginx/html/:ro my-web-app:latest
docker cp index.html my-web-app:/usr/share/nginx/html/index.html
```

### Docker Compose
Кроме Dockerfile создано три compose файла, отличающиеся по способу запуска (доставки).<br>
Запуск и остановка:<br>
```bash
docker compose -f docker-compose1.yml  up -d
docker compose -f docker-compose1.yml  down
```
Описание файла: Запустит контейнеры в любом случае, было выполнено build или нет, если образ имеется в системе, пройдет быстро. При желании инструкцию build можно закомментировать.
```yaml
services:
  web:
    build: .
    image: my-web-app:latest
    container_name: my-web-app
    ports:
      - "8080:80"
```

```bash
docker compose -f docker-compose.yml  up -d
docker compose -f docker-compose.yml  down
```
Описание файла: Здесь то же самое, только попытка доставить index.html и другие файлы до контейнера на лету, bind mount позволяет этол делать, но кривовато, то, что в контейнере "затирается".
```yaml
services:
  web:
    build: .
    image: my-web-app:latest
    container_name: my-web-app
    ports:
      - "8080:80"
    volumes:
      - ./data/:/usr/share/nginx/html/:ro
```

```bash
docker compose -f docker-compose.yml  up -d
docker compose -f docker-compose.yml  down
```
Описание файла: Здесь решил вообще не трогать ни Dockerfile, ни образ, docker compose выполняет почти все, что и Dockerfile. Ес-но выполнить копирование не умеет, поэтому bind mount vulumes. 
```yaml
services:
  web:
    image: nginx:alpine
    container_name: my-web-app
    ports:
      - "8080:80"
    volumes:
      - ./data/:/usr/share/nginx/html/:ro

```


## Задание  № В1
### Скрипт для чистки от логов

```sh
#!/bin/bash

read -p "Введите путь к логам: " LOG_PATH           --> вводим путь с клавиатуры
read -p "Введите количество дней: " D_QTY           --> так же количнство дней
#rm $(find $LOG_PATH -name *.log -mtime $D_QTY)     --> rm удаляет на большинстве OS без подтверждения
find "$LOG_PATH" -name "*.log" -mtime +$D_QTY -delete-> кавычки, чтобы исключить затора на пробелах, +$D_QTY = больше N дней.
```

Аргументы можно передать во время запуска скрипта.
```bash
./clean_old_logs.sh "/path/to/logs" 8
```
тогда
```bash
#!/bin/bash
find "$1" -name "*.log" -mtime +$2 -delete
```



## Задание № В2

> [!TIP]
> git stash
> git stash pop
> git checkout <branch>
> git commit --amend

Коротко:

```bash
git st
On branch feature/junior-task
git stash / git stash push -m "WIP on feature/junior-task saved"
git checkout main
git add .
git commit -m "critical bug fixed"
git checkout feature/junior-task
git stash pop
git commit --amend

```

Длинно:

```bash
[root@Kuber-Rocky test-project]# git st
On branch feature/junior-task
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   README.md

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        Dockerfile
        clean_old_logs.sh
        data/
        docker-compose1.yml
        docker-compose2.yml
        docker-compose3.yml

no changes added to commit (use "git add" and/or "git commit -a")
[root@Kuber-Rocky test-project]# git stash
Saved working directory and index state WIP on feature/junior-task: 4d48db7 Repo created
[root@Kuber-Rocky test-project]# git stash push -m "WIP on feature/junior-task saved"
No local changes to save
[root@Kuber-Rocky test-project]# git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
[root@Kuber-Rocky test-project]#
[root@Kuber-Rocky test-project]# vim README.md
[root@Kuber-Rocky test-project]# ls -la
total 24
drwxr-xr-x. 5 root root 186 Dec 19 03:33 .
drwxr-xr-x. 3 root root  47 Dec 19 03:22 ..
-rw-r--r--. 1 root root 237 Dec 19 03:22 clean_old_logs.sh
drwxr-xr-x. 2 root root  44 Dec 19 03:22 data
-rw-r--r--. 1 root root 121 Dec 19 03:22 docker-compose1.yml
-rw-r--r--. 1 root root 174 Dec 19 03:22 docker-compose2.yml
-rw-r--r--. 1 root root 156 Dec 19 03:22 docker-compose3.yml
-rw-r--r--. 1 root root 116 Dec 19 03:22 Dockerfile
drwxr-xr-x. 8 root root 183 Dec 19 03:33 .git
-rw-r--r--. 1 root root  19 Dec 19 03:31 README.md
drwxr-xr-x. 2 root root   6 Dec 19 03:22 scripts
[root@Kuber-Rocky test-project]# git add .
[root@Kuber-Rocky test-project]# git commit -m "critical bug fixed"
[main 34cfc23] critical bug fixed
 7 files changed, 79 insertions(+)
 create mode 100644 Dockerfile
 create mode 100644 clean_old_logs.sh
 create mode 100644 data/ASYT4311.JPG
 create mode 100644 data/index.html
 create mode 100644 docker-compose1.yml
 create mode 100644 docker-compose2.yml
 create mode 100644 docker-compose3.yml
[root@Kuber-Rocky test-project]# git checkout feature/junior-task
Switched to branch 'feature/junior-task'
[root@Kuber-Rocky test-project]# git stash pop
On branch feature/junior-task
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
Dropped refs/stash@{0} (0ca71c4341c424793dc548fd18e34ccbdece1ae6)
[root@Kuber-Rocky test-project]# git commit --amend
[feature/junior-task 6fc2f96] git commit amended
 Date: Fri Dec 19 03:21:28 2025 +0300
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
[root@Kuber-Rocky test-project]# git lol
* 34cfc23 (HEAD -> main) critical bug fixed
* 4d48db7 (origin/main) Repo created
[root@Kuber-Rocky test-project]# git checkout feature/junior-task
M       README.md
Switched to branch 'feature/junior-task'
[root@Kuber-Rocky test-project]#
[root@Kuber-Rocky test-project]#
[root@Kuber-Rocky test-project]# git lol
* 6fc2f96 (HEAD -> feature/junior-task) git commit amended
```

## Задание № В2

### Блок схема

> [!NOTE]
> См. schema.png

```
========================
|       Developer      |
========================
     v
=============================================
| Push code to branch main (GitHub / GitLab)|
|    v                                      | 
| CI/CD (GitHub Actions / GitLab CI)        |
|    v                                      |
| Pulling or Cloning repo                   |
=============================================
     v
========================
|        Tests         |
========================
    |--- Not passed
    |        v
    |    Telegram
    |        v
    |      STOP
    v
========================
|      Image build     |
========================
    |--- Failed
    |        v
    |    Telegram
    |        v
    |      STOP
    v
========================
|       Image push      |
========================
    |--- Failed
    |        v
    |    Telegram
    |        v
    |      STOP
    v
========================
|    Telegram msg      |
========================
```
