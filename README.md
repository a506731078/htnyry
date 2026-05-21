# LIS 物流系统

基于 RuoYi + Spring Boot 的物流管理系统

## 项目结构

```
java/
├── lis-admin/          # 主应用模块
├── lis-common/         # 通用工具模块
├── lis-framework/      # 框架核心模块
├── lis-quartz/         # 定时任务模块
├── lis-generator/      # 代码生成模块
├── lis-system/         # 系统管理模块
├── sql/                # 数据库脚本
├── web/                # 前端文件(PHP API)
├── bin/                # 打包脚本
├── .github/            # GitHub Actions 配置
├── config.json         # 配置文件模板
└── pom.xml            # Maven 父 POM
```

## 技术栈

- **后端**: Spring Boot 2.5.14 + Shiro 1.10.1
- **数据库**: MySQL 5.7+ / 8.0
- **缓存**: EhCache
- **定时任务**: Quartz
- **前端**: Bootstrap + Thymeleaf
- **API**: RESTful API

## 环境要求

### 开发打包环境

- JDK 1.8+ (推荐 JDK 8)
- Maven 3.6+
- MySQL 5.7+ / 8.0

详细配置请查看: [环境要求.md](环境要求.md)

## 快速开始

### 1. 本地打包

```bash
# Windows 环境
cd java
bin\package.bat

# 或使用命令行
mvn clean package -DskipTests
```

打包完成后，JAR 文件位于: `lis-admin/target/lis-admin.jar`

### 2. 配置文件

在 jar 包同目录下创建 `config.json` 配置文件：

```json
{
    "数据库名": "hhhh",
    "数据库账号": "hhhh",
    "数据库密码": "hhhh123",
    "主页端口": "8808"
}
```

### 3. 数据库初始化

1. 创建数据库 `hhhh` (字符集: utf8mb4)
2. 导入数据库脚本: `sql/htny_complete.sql`

### 4. 启动应用

```bash
java -jar -Xmx1024M -Xms256M lis-admin.jar
```

访问地址: `http://localhost:8808`

默认管理员账号: admin / admin123

## 宝塔面板部署

详细部署教程请查看: [宝塔部署指南.md](宝塔部署指南.md)

### 部署步骤

1. 安装宝塔面板和 Java 项目管理器
2. 创建数据库并导入 `sql/htny_complete.sql`
3. 上传 `lis-admin.jar` 和 `config.json` 到服务器
4. 在 Java 项目管理器中添加项目
5. 配置 Nginx 反向代理
6. 放行端口并测试访问

## API 接口

### 物流查询 API

```
GET /api.php?dh=物流单号
```

**无需登录，直接访问**

返回示例:
```json
{
    "code": 0,
    "msg": "查询成功",
    "data": [
        {
            "orderNumber": "LP123456789",
            "basic_info": {...},
            "location_details": {...}
        }
    ]
}
```

## GitHub Actions 自动构建

### 功能说明

项目已配置 GitHub Actions，支持自动构建和部署：

- **build.yml**: 推送到 main 分支时自动构建，生成 lis-admin.jar
- **deploy.yml**: 可手动触发，自动部署到服务器

### 配置 secrets

在 GitHub 仓库设置中添加以下 secrets：

| Name | Description |
|------|-------------|
| SERVER_HOST | 服务器 IP 地址 |
| SERVER_USER | 服务器用户名 |
| SERVER_PASSWORD | 服务器密码 |
| SERVER_PORT | SSH 端口 (默认 22) |
| SERVER_DEPLOY_PATH | 部署路径 (如 /www/wwwroot/lis) |

详细使用请查看: [GitHub构建指南.md](GitHub构建指南.md)

## 目录结构说明

| 目录 | 说明 |
|------|------|
| lis-admin | 主应用，包含启动类和控制器 |
| lis-common | 通用工具类 |
| lis-framework | 框架配置(Shiro、Druid等) |
| lis-system | 系统管理(用户、角色、菜单等) |
| lis-quartz | 定时任务管理 |
| lis-generator | 代码生成器 |
| sql | 数据库脚本 |
| web | 前端 PHP API 文件 |

## 注意事项

1. **config.json** 必须与 lis-admin.jar 在同一目录
2. 数据库配置优先使用环境变量，其次是 config.json
3. API 接口 `/api.php` 无需登录认证
4. 部署前请确保服务器端口已开放

## 许可证

本项目基于 RuoYi 开源协议
