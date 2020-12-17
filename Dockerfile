# setup dependencies
FROM node:15.2.1-stretch as preinstall
ENV PORT=80
ENV PYTHON=/usr/bin/python
RUN apt-get update && \
    apt-get install -y build-essential \
    gcc \
    libc6-dev \
    make \
    python3 \
    rsync \
    rsync \
    wget
RUN npm install forever -g

# copy and install require node modules
FROM node:15.2.1-stretch as install
WORKDIR /usr/src/app
COPY [ "efusecli", "package*.json", "./" ]
COPY async/package.json ./async/
COPY backend/package.json ./backend/
COPY csgoservice/package.json ./csgoservice/
COPY external-api/package.json ./external-api/
COPY fortniteservice/package.json ./fortniteservice/
COPY graphql/package.json ./graphql/
COPY lib/package.json ./lib/
COPY lol-service/package.json ./lol-service/
COPY mailerservice/package.json ./mailerservice/
COPY packages/id-service/package.json ./packages/id-service/
COPY packages/key-store/package.json ./packages/key-store/
COPY packages/test-helpers/package.json ./packages/test-helpers/
COPY scripts/efusecli/ ./scripts/efusecli/
COPY servicelibs/package.json ./servicelibs/
RUN npm install --legacy-peer-deps --production=false --quiet
COPY . .

# reinstall flaky dependencies, build and prepare for running
FROM preinstall as final
WORKDIR /usr/src/app
COPY --from=install  /usr/src/app .
RUN npm rebuild @tensorflow/tfjs-node build-addon-from-source

RUN npm run build.all
RUN npm prune --production
EXPOSE 80

# do not run async on production BE as it is a dedicated tier
CMD ["forever", "./dist/server.js", "--no-async", "--no-redis"]
