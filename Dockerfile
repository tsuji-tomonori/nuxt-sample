# Build Stage
FROM node:22-alpine AS builder

WORKDIR /app

# キャッシュを活用するため package.json と lock ファイルを先にコピー
COPY package.json package-lock.json ./
RUN npm ci

# プロジェクト全体をコピーしてビルド
COPY . .
RUN npm run build

# Run Stage
FROM node:22-alpine AS runner

WORKDIR /app

# ビルド成果物をコピー
COPY --from=builder /app/ ./

# 必要な環境変数を設定
ENV NODE_ENV=production
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000

EXPOSE 3000

# アプリケーションを起動
CMD ["node", ".output/server/index.mjs"]
