#!/bin/bash
##请输入参数为android工程路径

function debugMove() {

    echo '\nstep 3:  Flutter: change jni/armeabi-v7 to armeabi'
    mv build/app/outputs/aar/app-debug.aar build/app/outputs/aar/flutterAndroid.aar

    echo 'done'
}

function releaseMove() {


    echo ''
    echo 'step 3:  Flutter: change jni/armeabi-v7 to armeabi'
    mv build/app/outputs/aar/app-release.aar build/app/outputs/aar/flutter-release1.aar
    unzip -q build/app/outputs/aar/flutter-release1.aar -d build/app/outputs/aar/flutter/
    mv build/app/outputs/aar/flutter/jni/armeabi-v7a build/app/outputs/aar/flutter/jni/armeabi
    cd build/app/outputs/aar/flutter
    zip -q -r ../flutterAndroid.aar ./*
    cd ..
    rm -rf flutter-release1.aar
    rm -rf flutter
    cd ../../../../
    echo 'build done'
}


echo '---------------- BUILD DUBEN ----------------'
read -p "Please Input Type For Compile (Release: r, Debug: d): " Compile_Choice

if [ $Compile_Choice == r ]
then
  releaseMove
elif [ $Compile_Choice == d ]
then
   debugMove
else
   echo '请输入正确type！\n'
fi






