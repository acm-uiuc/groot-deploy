#!/bin/bash

mkdir -p log/dev

# Groot API
./groot/build.sh 
cp groot/build/groot build/groot

# Groot Users Service
cd groot-users-service
npm install
cd ..

# Groot Groups Service
cd groot-groups-service
npm install
cd ..

# Groot Desktop Frontend
cd groot-desktop-frontend
npm install
cd ..

# Groot Events Service
cd groot-events-service
npm install
cd ..

# Groot Recruiters Service
cd groot-recruiters-service
bundle install
cd ..

# Groot Quotes Service
cd groot-quotes-service
bundle install
cd ..

# Groot Meme Service
cd groot-meme-service
pip install -r requirements.txt
cd ..

trap 'kill %1; kill %2; kill %3; kill %4; kill %5; kill %6; kill %7;' SIGINT

node groot-users-service/server.js  | tee log/dev/groot-users-service.log | sed -e 's/^/[groot-users-service] /' \
& node groot-groups-service/server.js  | tee log/dev/groot-groups-service.log | sed -e 's/^/[groot-groups-service] /' \
& npm --prefix ./groot-desktop-frontend start  | tee log/dev/groot-desktop-frontend.log | sed -e 's/^/[groot-desktop-frontend] /' \
& node groot-events-service/server.js  | tee log/dev/groot-events-service.log | sed -e 's/^/[groot-events-service] /' \
& ruby groot-recruiters-service/app.rb | tee log/dev/groot-recruiters-service.log | sed -e 's/^/[groot-recruiters-service] /' \
& ruby groot-quotes-service/app.rb | tee log/dev/groot-quotes-service.log | sed -e 's/^/[groot-quotes-service] /' \
& python groot-meme-service/app.py | tee log/dev/groot-meme-service.log | sed -e 's/^/[groot-meme-service] /' \
& ./build/groot -u | tee log/dev/groot.log | sed -e 's/^/[groot] /'