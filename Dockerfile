FROM node:16.15.1 as builder

#작업 디렉토리
RUN mkdir /usr/src/app

WORKDIR /usr/src/app

ADD . /usr/src/app

COPY package.json yarn.lock ./
RUN yarn
COPY . ./

RUN yarn build

FROM nginx

RUN rm /etc/nginx/conf.d/default.conf

COPY ./nginx.conf /etc/nginx/conf.d

COPY --from=builder /usr/src/app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx","-g","daemon off;"]