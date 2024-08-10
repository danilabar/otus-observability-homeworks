# Описание ДЗ:

1. На виртуальной машине установите любую open source CMS, которая включает в себя следующие компоненты: nginx, php-fpm, database (MySQL or Postgresql)
2. На этой же виртуальной машине установите Prometheus exporters для сбора метрик со всех компонентов системы (начиная с VM и заканчивая DB, не забудьте про blackbox exporter, который будет проверять доступность вашей CMS)
3. На этой же или дополнительной виртуальной машине установите Prometheus, задачей которого будет раз в 5 секунд собирать метрики с экспортеров.

## Задание со звездочкой (повышенная сложность)
* на VM с установленной CMS слишком много “портов экспортеров торчит наружу” и они доступны всем, попробуйте настроить доступ только по одному и добавить авторизацию.

* Если вы выполнили задание со звездочкой номер 1, то - добавить SSL =)

В качестве результата ДЗ принимаются - файл конфигурации Prometheus.

---

# Решение

## Машина с CMS

Установил на машину **LEMP** и WordPress

- Nginx

![img_1.png](img/img_1.png)

- php-fpm

![img_2.png](img/img_2.png)

- MySql

![img_3.png](img/img_3.png)

- WordPress

![img_4.png](img/img_4.png)

Ссылки по теме:

- [https://www.howtoforge.com/how-to-install-joomla-on-rocky-linux/](https://www.howtoforge.com/how-to-install-joomla-on-rocky-linux/)
- [https://www.dmosk.ru/miniinstruktions.php?mini=wordpress-nginx-rpm](https://www.dmosk.ru/miniinstruktions.php?mini=wordpress-nginx-rpm)
- [https://www.tecmint.com/enable-monitor-php-fpm-status-in-nginx/](https://www.tecmint.com/enable-monitor-php-fpm-status-in-nginx/)

## Установка Prometheus exporters

Установил ansible коллекции prometheus для установки и настройки Prometheus exporters

 - nginx_exporter
 - mysqld_exporter
 - node_exporter
 - blackbox_exporter

```bash
ansible-galaxy collection install prometheus.prometheus
```

![img.png](img/img.png)

Написал простую ansible [role](ansible/roles/php_fpm_exporter) для установки **php_fpm_exporter**

Написал ansible-playbook [site.yml](ansible/site.yml) для установки exporters

Выполнил установку exporters

```bash
ansible-playbook site.yml -i inventory/prometheus.yml -u root -k
```

![img_5.png](img/img_5.png)

---

Exporters запущены и отображают метрики

 - nginx_exporter

![img_6.png](img/img_6.png)

 - mysqld_exporter

![img_7.png](img/img_7.png)

 - node_exporter

![img_8.png](img/img_8.png)

 - php_fpm_exporter

![img_9.png](img/img_9.png)

 - blackbox_exporter

![img_10.png](img/img_10.png)

![img_11.png](img/img_11.png)

---

## Установка Prometheus

Для запуска Prometheus использовал Docker [docker-compose.yml](prometheus/docker-compose.yml)

Конфигурация Prometheus писана в файле [prometheus.yml](prometheus/prometheus.yml)

Все таргеты и их метрики доступны в Prometheus с интервалом сбора в 5 секунд

![img_12.png](img/img_12.png)
![img_13.png](img/img_13.png)