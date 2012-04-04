#!/bin/sh
#read -p "Enter locale [default is 'ru']: " LOCALE
#if [ $LOCALE=='' ]
#then
#	LOCALE='ru'
#fi
D:/QtSDK/Desktop/Qt/4.8.0/mingw/bin/lupdate.exe -recursive *.qml *.js -ts translations/bombs-qml_ru.ts
D:/QtSDK/Desktop/Qt/4.8.0/mingw/bin/lrelease.exe translations/*.ts
