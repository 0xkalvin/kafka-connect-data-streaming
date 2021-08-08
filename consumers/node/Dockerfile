FROM node:alpine

WORKDIR /consumer

COPY package*.json ./

RUN npm install

COPY . .

CMD [ "npm", "start" ]
