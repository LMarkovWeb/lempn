# Nginx, php-fpm, mysql, nodejs, pm2, nuxt

Тестовый стенд для проектов Nuxt JS + PHP

## Установка

### Установка Nginx

```
yum install epel-release -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx
```

Подключение http://192.168.20.221/  
Стандартная страница Nginx на Centos.

### Установка nodejs, npm, pm2

```
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install -y nodejs
npm i -g pm2
```

pm2 - менеджер, который необходим чтобы управлять процессами и приложениями,
запущенными в среде Node.js, а также автоматического их запускать после
перезагрузки сервера

### Установка MySQL

...

### Установка PHP-FPM

```bash
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php74;
yum install php-mysqlnd php-fpm php-mbstring php-cli -y
systemctl start php-fpm;
systemctl enable php-fpm;
```

---

## Настройка

### 1. Nuxt.js-приложение

Создание Nuxt-проекта:

```
#mkdir -p /var/www/myProject
npx create-nuxt-app
```

Запуск через менеджер pm2

```
#cd /var/www/myProject
pm2 init
```

Конфиг для ecosystem.config.js

```
module.exports = {
  apps : [
    {
      name: "nuxt-dev",
      script: "npm",
      args: "run dev"
    },
    {
      name: "nuxt-prod",
      script: "npm",
      args: "run start"
    }
  ]
}
```

Для dev-версии

```
pm2 start ecosystem.config.js --only nuxt-dev
```

Для prod-версии:

```
npm run build && pm2 start ecosystem.config.js --only nuxt-prod
```

Автоматический запуск приложений через pm2 после перезагрузки
сервера:

```
pm2 startup && pm2 save
```

### 2. Nginx

Прокси на проект Nuxt

```bash
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

**Ошибка Nginx "502 Bad Gateway"**  
13: Permission denied в /var/log/nginx/error.log
и denied в  
cat /var/log/audit/audit.log | grep nginx | grep denied
Решение:

```
setsebool -P httpd_can_network_connect 1
```

### PHP-FPM

...

## Acknowledgements

- [Habr. Разворачиваем Node.js-проект (Nuxt.js) на базе VDS с ОС Ubuntu Server](https://habr.com/ru/post/558178/)
- [Развертывание сервера Nuxt (CentOS7 + nginx + pm2)](https://russianblogs.com/article/82881009510/)
- [How to write a Good readme](https://bulldogjob.com/news/449-how-to-write-a-good-readme-for-your-github-project)
