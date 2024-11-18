FROM node:latest AS build

WORKDIR /app

ARG ATLAS_DB_USERNAME
ARG ATLAS_CLUSTER
ARG ATLAS_DB
ARG ATLAS_DB_PASSWORD
ARG ACCESS_TOKEN_SECRET
ARG REFRESH_TOKEN_SECRET

ENV ATLAS_DB_USERNAME=${ATLAS_DB_USERNAME}    
ENV ATLAS_CLUSTER=${ATLAS_CLUSTER}
ENV ATLAS_DB=${ATLAS_DB}
ENV ATLAS_DB_PASSWORD=${ATLAS_DB_PASSWORD}
ENV ACCESS_TOKEN_SECRET=${ACCESS_TOKEN_SECRET}
ENV REFRESH_TOKEN_SECRET=${REFRESH_TOKEN_SECRET}

COPY package.json .
COPY pnpm-lock.yaml .
COPY tsconfig.json .
COPY src ./src

RUN echo "ATLAS_DB_PASSWORD=${ATLAS_DB_PASSWORD}" >> .env
RUN echo "ATLAS_DB_USERNAME=${ATLAS_DB_USERNAME}" >> .env
RUN echo "ATLAS_CLUSTER=${ATLAS_CLUSTER}" >> .env
RUN echo "ATLAS_DB=${ATLAS_DB}" >> .env
RUN echo "ACCESS_TOKEN_SECRET=${ACCESS_TOKEN_SECRET}" >> .env
RUN echo "REFRESH_TOKEN_SECRET=${REFRESH_TOKEN_SECRET}" >> .env

RUN npm install -g pnpm typescript
RUN pnpm install

COPY . .
EXPOSE 5050
CMD ["pnpm", "start"]