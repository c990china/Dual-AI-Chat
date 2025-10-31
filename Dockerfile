# 阶段1：构建前端应用
FROM node:20-alpine AS build-stage
WORKDIR /app
# 复制依赖文件
COPY dual-ai-chat/package.json dual-ai-chat/package-lock.json ./
# 安装依赖
RUN npm ci
# 复制源代码
COPY dual-ai-chat/ ./
# 构建项目（生成静态文件）
RUN npm run build

# 阶段2：使用 Nginx 部署
FROM nginx:alpine AS production-stage
# 从构建阶段复制产物到 Nginx 静态文件目录
COPY --from=build-stage /app/dist /usr/share/nginx/html
# 可选：替换 Nginx 配置（如需自定义端口或路由）
# COPY nginx.conf /etc/nginx/conf.d/default.conf
# 暴露 80 端口
EXPOSE 80
# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
