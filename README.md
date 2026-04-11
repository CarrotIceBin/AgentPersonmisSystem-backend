# 人事管理系统

## 项目简介

人事管理系统是一个基于Spring Boot和Vue 3的企业级人力资源管理系统，旨在帮助企业高效管理员工信息、部门结构、岗位调动等人力资源相关业务。

## 技术栈

### 后端
- **框架**: Spring Boot 2.7.17
- **ORM**: MyBatis
- **数据库**: MySQL 8.0
- **语言**: Java 15

### 前端
- **框架**: Vue 3
- **UI库**: Element Plus
- **路由**: Vue Router 4
- **状态管理**: Vuex 4
- **HTTP客户端**: Axios

## 项目结构

```
├── 人事管理系统源代码/
│   ├── personmis/            # 后端Spring Boot项目
│   │   ├── src/main/java/com/ch/personmis/  # 后端代码
│   │   │   ├── controller/   # 控制器
│   │   │   ├── entity/       # 实体类
│   │   │   ├── repository/   # 数据访问层
│   │   │   ├── service/      # 业务逻辑层
│   │   │   └── PersonmisApplication.java  # 应用启动类
│   │   ├── src/main/resources/  # 资源文件
│   │   │   ├── mappers/      # MyBatis映射文件
│   │   │   └── application.properties  # 配置文件
│   │   └── pom.xml           # Maven依赖配置
│   └── personmis-vue/        # 前端Vue项目
│       ├── src/              # 前端源代码
│       │   ├── components/    # 组件
│       │   ├── views/         # 页面
│       │   ├── router/        # 路由配置
│       │   ├── store/         # 状态管理
│       │   └── main.js        # 入口文件
│       ├── public/            # 静态资源
│       └── package.json       # npm依赖配置
└── personmis.sql             # 数据库初始化脚本
```

## 功能模块

### 1. 部门管理
- 部门信息的增删改查
- 部门类型管理
- 部门层级关系管理

### 2. 员工管理
- 员工基本信息管理
- 员工入职、离职管理
- 员工状态跟踪

### 3. 岗位管理
- 岗位信息管理
- 岗位类型设置

### 4. 调动管理
- 员工岗位调动记录
- 调动类型管理
- 调动审批流程

### 5. 报表管理
- 新员工入职报表
- 员工离职报表
- 岗位调动报表

## 快速开始

### 环境要求
- JDK 15+
- MySQL 8.0+
- Node.js 14+
- npm 6+

### 1. 数据库配置

1. 创建数据库：
   ```sql
   CREATE DATABASE personmis CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

2. 导入数据库结构：
   ```bash
   mysql -u root -p personmis < personmis.sql
   ```

3. 修改后端配置文件 `personmis/src/main/resources/application.properties`：
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/personmis?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=UTC
   spring.datasource.username=root
   spring.datasource.password=your_password
   ```

### 2. 后端项目运行

1. 进入后端项目目录：
   ```bash
   cd 人事管理系统源代码/personmis
   ```

2. 构建项目：
   ```bash
   mvn clean install
   ```

3. 运行项目：
   ```bash
   mvn spring-boot:run
   ```

   后端服务将在 `http://localhost:8080` 启动。

### 3. 前端项目运行

1. 进入前端项目目录：
   ```bash
   cd 人事管理系统源代码/personmis-vue
   ```

2. 安装依赖：
   ```bash
   npm install
   ```

3. 启动开发服务器：
   ```bash
   npm run serve
   ```

   前端服务将在 `http://localhost:8081` 启动。

## 项目特点

1. **前后端分离架构**：采用Spring Boot + Vue 3的前后端分离架构，提高开发效率和系统可维护性。

2. **响应式设计**：前端使用Element Plus组件库，实现了响应式布局，适配不同屏幕尺寸。

3. **完整的人力资源管理功能**：涵盖了部门、员工、岗位、调动等核心人力资源管理模块。

4. **数据可视化**：提供了多种报表功能，帮助企业分析人力资源数据。

5. **安全性**：实现了基本的权限控制和数据验证。

## 注意事项

1. **数据库配置**：请确保MySQL服务已启动，并且数据库连接信息正确。

2. **端口冲突**：默认后端使用8080端口，前端使用8081端口，请确保这些端口未被占用。

3. **依赖安装**：前端项目依赖安装可能需要较长时间，请耐心等待。

4. **数据初始化**：首次运行时，请确保已导入数据库结构和基础数据。

5. **浏览器兼容性**：推荐使用Chrome、Firefox等现代浏览器访问系统。

## 联系方式

如有问题或建议，欢迎联系项目维护者。
