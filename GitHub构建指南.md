# LIS 物流系统 - GitHub Actions 自动构建指南

## 1. Fork 项目

1. 访问 GitHub 项目页面
2. 点击右上角「Fork」按钮
3. 选择你的 GitHub 账号

## 2. 配置 Secrets

在 Fork 后的仓库中进行以下操作：

1. 进入仓库 → Settings → Secrets → Actions
2. 点击「New repository secret」添加以下配置：

| Secret Name | Description | Example |
|------------|-------------|---------|
| SERVER_HOST | 服务器IP地址 | 192.168.10.203 |
| SERVER_USER | 服务器用户名 | root |
| SERVER_PASSWORD | 服务器密码 | your_password |
| SERVER_PORT | SSH端口 | 22 |
| SERVER_DEPLOY_PATH | 部署路径 | /www/wwwroot/lis |

## 3. 自动构建

### 触发条件

- **push 到 main 分支**: 自动执行构建，生成 lis-admin.jar
- **手动触发**: 可以手动执行部署到服务器

### 构建流程

1. 代码推送到 main 分支
2. GitHub Actions 自动检测并执行 `build.yml`
3. 构建成功后，JAR 包作为 artifact 保存
4. 可下载 lis-admin.jar 使用

### 手动部署流程

1. 进入仓库 → Actions 页面
2. 选择「Build and Deploy to Server」
3. 点击「Run workflow」
4. 选择 main 分支执行
5. 自动部署到服务器并重启应用

## 4. 查看构建结果

1. 进入仓库 → Actions 页面
2. 点击对应的 workflow 运行记录
3. 查看构建日志
4. 如有 artifact，可点击下载 lis-admin.jar

## 5. 常见问题

### Q: 构建失败
- 检查 pom.xml 依赖是否完整
- 检查 Maven 配置
- 查看构建日志定位问题

### Q: 部署失败
- 检查服务器连接信息是否正确
- 检查服务器 SSH 端口是否正确
- 确认部署路径是否存在

### Q: 服务启动失败
- 登录服务器查看日志
- 检查 config.json 配置
- 检查数据库连接
- 确认端口未被占用

### 日志查看命令
```bash
# 查看应用日志
tail -f /www/wwwroot/lis/logs/sys-error.log

# 查看应用进程
ps -ef | grep lis-admin.jar

# 查看端口占用
netstat -tlnp | grep 8808
```
