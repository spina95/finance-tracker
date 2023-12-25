FROM node:lts-alpine

# set the working direction
WORKDIR /app

# install app dependencies
COPY . ./

# Fix permissions for packages
# RUN npm config set unsafe-perm true

RUN npm install
RUN npm install -g serve

# Bundle app source

RUN chown -R node:node /app/node_modules

EXPOSE 8080

RUN npm run build

# start app
CMD [ "npm", "run", "dev" ]