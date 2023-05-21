FROM node:16.3-alpine3.12 as builder

# 작업 디렉토리
WORKDIR /app

# 애플리케이션 종속성 복사
COPY package.json yarn.lock ./

# 애플리케이션 종속성 설치
RUN yarn

# 애플리케이션 소스 코드 복사
COPY . ./

# 애플리케이션 빌드
RUN yarn build

FROM nginx

# 기본 nginx 설정 파일 삭제
RUN rm /etc/nginx/conf.d/default.conf

# nginx 설정 파일 복사
COPY ./nginx.conf /etc/nginx/conf.d

# 빌더 단계에서 빌드된 애플리케이션 복사
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]