#!/bin/sh

# 等待 MySQL 服务就绪
echo "等待 MySQL 服务就绪..."
while ! nc -z $CONFIG_DB_HOST $CONFIG_DB_PORT; do
  sleep 2
  echo "等待 MySQL 连接..."
done

echo "MySQL 服务已就绪，启动应用..."

# 启动应用
exec java $JAVA_OPTS -jar lis-admin.jar
