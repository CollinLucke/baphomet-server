FROM node:alpine3.20
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
EXPOSE 5050
CMD [ "pnpm", "run", "start" ]