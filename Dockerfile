# ---------- STAGE 1: build ----------
FROM node:24-alpine AS builder
WORKDIR /app

# Копіюємо package.json і lock-файл
COPY package.json yarn.lock ./

# Встановлюємо залежності
RUN yarn install --frozen-lockfile

# Копіюємо весь код проєкту
COPY . .

# Будуємо production Next.js застосунок
RUN yarn build

# ---------- STAGE 2: production ----------
FROM node:24-alpine
WORKDIR /app
ENV NODE_ENV=production

# Копіюємо тільки необхідні файли
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public

# Порт
EXPOSE 3000

# Запуск сервера
CMD ["yarn", "start"]
