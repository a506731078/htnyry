# 飞牛NAS Docker 部署指南

本指南详细介绍如何在飞牛NAS上使用Docker部署LIS物流系统。

## 前置准备

### 1. 确保NAS已安装Docker

- 登录飞牛NAS管理界面
- 进入「应用中心」或「Docker」管理页面
- 确认Docker服务已安装并运行

### 2. 准备部署文件

你需要以下文件（可从GitHub仓库下载）：

```
docker-compose.yml    # Docker Compose配置
.env.example         # 环境变量模板（复制为.env）
```

## 部署步骤

### 方法一：使用飞牛NAS的Docker管理界面（推荐）

#### 步骤1：创建共享文件夹

1. 登录飞牛NAS管理界面
2. 进入「文件管理」或「共享文件夹」
3. 创建以下文件夹结构：
   ```
   /docker/lis/
   ├── data/          # 数据持久化目录
   │   ├── mysql/    # MySQL数据
   │   ├── upload/   # 上传文件
   │   └── logs/     # 应用日志
   └── config/       # 配置文件目录
   ```

#### 步骤2：创建docker-compose.yml

1. 进入「Docker」→「堆栈」或「Compose」
2. 点击「添加堆栈」或「新建」
3. 填写堆栈名称（如：`lis`）
4. 复制以下内容到配置编辑器：

```yaml
version: '3.8'

services:
  # MySQL 数据库
  mysql:
    image: mysql:8.0
    container_name: lis-mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: hhhh
      MYSQL_USER: hhhh
      MYSQL_PASSWORD: hhhh123
      TZ: Asia/Shanghai
    volumes:
      - /docker/lis/data/mysql:/var/lib/mysql
      - /docker/lis/sql:/docker-entrypoint-initdb.d
    ports:
      - "3306:3306"
    networks:
      - lis-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-proot123"]
      interval: 10s
      timeout: 5s
      retries: 5

  # LIS 应用
  lis:
    image: ghcr.io/a506731078/htnyry:latest
    container_name: lis-app
    restart: unless-stopped
    depends_on:
      mysql:
        condition: service_healthy
    environment:
      CONFIG_DB_HOST: mysql
      CONFIG_DB_PORT: 3306
      CONFIG_DB_NAME: hhhh
      CONFIG_DB_USER: hhhh
      CONFIG_DB_PASSWORD: hhhh123
      CONFIG_PORT: 8808
      CONFIG_ADDRESS: 0.0.0.0
      JAVA_OPTS: -Xmx1024M -Xms256M
      TZ: Asia/Shanghai
    volumes:
      - /docker/lis/data/upload:/home/lis/uploadPath
      - /docker/lis/data/logs:/home/lis/logs
    ports:
      - "8808:8808"
    networks:
      - lis-network

networks:
  lis-network:
    driver: bridge
```

#### 步骤3：配置环境变量（可选）

在堆栈配置中，你可以修改环境变量：

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `MYSQL_ROOT_PASSWORD` | MySQL root密码 | root123 |
| `MYSQL_DATABASE` | 数据库名 | hhhh |
| `MYSQL_USER` | 数据库用户 | hhhh |
| `MYSQL_PASSWORD` | 数据库密码 | hhhh123 |
| `CONFIG_PORT` | 应用端口 | 8808 |
| `JAVA_OPTS` | JVM参数 | -Xmx1024M -Xms256M |

#### 步骤4：部署数据库脚本

1. 将GitHub仓库中的 `sql/htny_complete.sql` 文件上传到NAS
2. 放置在 `/docker/lis/sql/` 目录下
3. 这样MySQL容器启动时会自动初始化数据库

#### 步骤5：启动堆栈

1. 点击「部署」或「启动」
2. 等待所有容器启动（可能需要1-2分钟）
3. 查看容器状态，确保都显示为「运行中」

---

### 方法二：使用SSH命令行（进阶用户）

#### 步骤1：连接到NAS

```bash
ssh admin@你的NAS_IP地址
```

#### 步骤2：创建目录结构

```bash
mkdir -p /docker/lis/{config,data/{mysql,upload,logs},sql}
cd /docker/lis
```

#### 步骤3：创建docker-compose.yml

```bash
vi docker-compose.yml
```

粘贴上面的配置内容，保存并退出。

#### 步骤4：上传数据库脚本

将 `sql/htny_complete.sql` 上传到 `/docker/lis/sql/` 目录。

#### 步骤5：启动服务

```bash
# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

---

## 验证部署

### 1. 检查容器状态

在飞牛NAS的Docker管理界面，查看：
- `lis-mysql` 容器状态应为「运行中」
- `lis-app` 容器状态应为「运行中」

### 2. 访问系统

打开浏览器，访问：

```
http://你的NAS_IP地址:8808
```

### 3. 登录系统

- **默认账号**: `admin`
- **默认密码**: `admin123`

---

## 常用操作

### 在飞牛NAS界面中

#### 查看日志

1. 进入「Docker」→「容器」
2. 点击对应容器
3. 选择「日志」标签页

#### 进入容器终端

1. 进入「Docker」→「容器」
2. 点击对应容器
3. 选择「终端」或「控制台」

#### 重启服务

1. 进入「Docker」→「堆栈」
2. 选择 `lis` 堆栈
3. 点击「重启」或「停止」→「启动」

### 使用命令行

```bash
# 进入LIS容器
docker exec -it lis-app sh

# 进入MySQL容器
docker exec -it lis-mysql mysql -u hhhh -phhhh123 hhhh

# 查看应用日志
docker logs -f lis-app

# 查看MySQL日志
docker logs -f lis-mysql

# 停止所有服务
docker-compose stop

# 启动所有服务
docker-compose start

# 重启所有服务
docker-compose restart

# 删除服务（保留数据）
docker-compose down

# 删除服务和数据（谨慎使用）
docker-compose down -v
```

---

## 数据持久化说明

飞牛NAS上的数据存储在以下位置：

| 主机路径 | 容器路径 | 说明 |
|----------|----------|------|
| `/docker/lis/data/mysql` | `/var/lib/mysql` | MySQL数据库 |
| `/docker/lis/data/upload` | `/home/lis/uploadPath` | 上传文件 |
| `/docker/lis/data/logs` | `/home/lis/logs` | 应用日志 |

**即使容器被删除，这些数据也不会丢失！**

---

## 网络配置

### 端口映射

| 主机端口 | 容器端口 | 服务 |
|----------|----------|------|
| 8808 | 8808 | LIS应用 |
| 3306 | 3306 | MySQL数据库（可选暴露） |

### 防火墙配置

确保飞牛NAS的防火墙已开放以下端口：
- **8808** - LIS应用访问端口
- **3306** - MySQL数据库端口（如果需要远程访问）

---

## 更新镜像

### 方法一：通过飞牛NAS界面

1. 进入「Docker」→「镜像」
2. 搜索或找到 `ghcr.io/a506731078/htnyry` 镜像
3. 点击「拉取」或「更新」
4. 进入「堆栈」，选择 `lis` 堆栈
5. 点击「重新部署」

### 方法二：通过命令行

```bash
cd /docker/lis

# 拉取最新镜像
docker-compose pull

# 重新启动服务
docker-compose up -d
```

---

## 备份与恢复

### 备份数据

```bash
# 备份MySQL数据
tar -czf lis-mysql-backup-$(date +%Y%m%d).tar.gz /docker/lis/data/mysql

# 备份上传文件
tar -czf lis-upload-backup-$(date +%Y%m%d).tar.gz /docker/lis/data/upload
```

### 恢复数据

```bash
# 停止服务
docker-compose down

# 恢复MySQL数据
tar -xzf lis-mysql-backup-YYYYMMDD.tar.gz -C /

# 恢复上传文件
tar -xzf lis-upload-backup-YYYYMMDD.tar.gz -C /

# 启动服务
docker-compose up -d
```

---

## 故障排查

### 问题1：应用无法访问

**检查清单：**
1. 容器状态是否为「运行中」
2. 端口8808是否被占用
3. NAS防火墙是否开放8808端口
4. 查看应用日志

**查看日志：**
```bash
docker logs lis-app
```

### 问题2：数据库连接失败

**检查清单：**
1. MySQL容器是否正常运行
2. 查看MySQL日志
3. 确认环境变量配置正确

**查看MySQL日志：**
```bash
docker logs lis-mysql
```

### 问题3：文件上传失败

**检查清单：**
1. `/docker/lis/data/upload` 目录是否存在
2. 目录权限是否正确（建议755或777）
3. 查看应用日志

---

## 安全建议

1. **修改默认密码**：首次登录后立即修改admin密码
2. **配置HTTPS**：使用NAS的反向代理功能配置SSL证书
3. **限制访问**：在路由器或NAS防火墙中限制IP访问
4. **定期备份**：设置定时任务自动备份数据
5. **更新镜像**：定期更新Docker镜像获取安全修复

---

## 技术支持

如遇到问题，请：
1. 查看本指南的「故障排查」部分
2. 检查容器日志
3. 访问GitHub仓库提交Issue

---

## 附录：完整的docker-compose.yml

```yaml
version: '3.8'

services:
  # MySQL 数据库
  mysql:
    image: mysql:8.0
    container_name: lis-mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: hhhh
      MYSQL_USER: hhhh
      MYSQL_PASSWORD: hhhh123
      TZ: Asia/Shanghai
    volumes:
      - /docker/lis/data/mysql:/var/lib/mysql
      - /docker/lis/sql:/docker-entrypoint-initdb.d
    ports:
      - "3306:3306"
    networks:
      - lis-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-proot123"]
      interval: 10s
      timeout: 5s
      retries: 5

  # LIS 应用
  lis:
    image: ghcr.io/a506731078/htnyry:latest
    container_name: lis-app
    restart: unless-stopped
    depends_on:
      mysql:
        condition: service_healthy
    environment:
      CONFIG_DB_HOST: mysql
      CONFIG_DB_PORT: 3306
      CONFIG_DB_NAME: hhhh
      CONFIG_DB_USER: hhhh
      CONFIG_DB_PASSWORD: hhhh123
      CONFIG_PORT: 8808
      CONFIG_ADDRESS: 0.0.0.0
      JAVA_OPTS: -Xmx1024M -Xms256M
      TZ: Asia/Shanghai
    volumes:
      - /docker/lis/data/upload:/home/lis/uploadPath
      - /docker/lis/data/logs:/home/lis/logs
    ports:
      - "8808:8808"
    networks:
      - lis-network

networks:
  lis-network:
    driver: bridge
```

---

**祝你部署顺利！** 🎉
