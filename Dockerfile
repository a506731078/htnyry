# 第一阶段：使用 Maven 构建应用
FROM maven:3.8.8-openjdk-8-slim AS builder

# 设置工作目录
WORKDIR /app

# 复制 pom.xml 和所有子模块的 pom.xml 到工作目录
COPY pom.xml .
COPY lis-admin/pom.xml lis-admin/
COPY lis-common/pom.xml lis-common/
COPY lis-framework/pom.xml lis-framework/
COPY lis-quartz/pom.xml lis-quartz/
COPY lis-generator/pom.xml lis-generator/
COPY lis-system/pom.xml lis-system/

# 复制 Maven 设置（如果有的话）
# COPY maven/settings.xml /root/.m2/settings.xml

# 下载依赖（这一步会被缓存，除非 pom.xml 变更）
RUN mvn dependency:go-offline -B

# 复制完整源代码
COPY . .

# 构建应用（跳过测试）
RUN mvn clean package -DskipTests

# 第二阶段：运行时镜像
FROM eclipse-temurin:8-jdk-alpine

# 设置工作目录
WORKDIR /app

# 从构建阶段复制 JAR 文件
COPY --from=builder /app/lis-admin/target/lis-admin.jar .

# 复制配置文件模板
COPY config.json .

# 创建必要的目录
RUN mkdir -p /home/lis/uploadPath /home/lis/logs

# 设置环境变量（默认值，可被 .env 或 docker-compose 覆盖）
ENV JAVA_OPTS="-Xmx1024M -Xms256M"
ENV CONFIG_PORT=8808
ENV CONFIG_ADDRESS=0.0.0.0

# 复制启动脚本
COPY start.sh /app/
RUN chmod +x /app/start.sh

# 安装 netcat (用于等待 MySQL)
RUN apk add --no-cache netcat-openbsd

# 暴露端口
EXPOSE 8808

# 启动应用
ENTRYPOINT ["/app/start.sh"]