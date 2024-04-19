#wsl --update
#https://blog.csdn.net/qq_35764295/article/details/129907447

# docker build -t alseambusher/crontab-ui .
# docker run -d -p 8000:8000 alseambusher/crontab-ui
# 指定容器名称启动
#docker run --name "myrunname"  -d -p 8000:8000 "alseambusher/crontab-ui"
# 查看容器名称
# docker ps -a --format '{{.Names}}'
#停止容器 运行
#docker stop myrunname
#docker copy 宿主文件到 容器
#docker cp . myrunname:crontab-ui
FROM alpine:3.15.3

ENV   CRON_PATH /etc/crontabs

RUN   mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root

WORKDIR /crontab-ui

LABEL maintainer "@alseambusher"
LABEL description "Crontab-UI docker"

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      supervisor \
      tzdata

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

RUN   npm install

ENV   HOST 0.0.0.0

ENV   PORT 8000

ENV   CRON_IN_DOCKER true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
