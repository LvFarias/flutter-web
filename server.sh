#!/bin/bash
PORT=8080
cd ../app/
flutter pub get
flutter build web
cd ./build/web/
echo 'Starting server on port' $PORT '...'
python3 -m http.server $PORT
echo 'Server exited...'