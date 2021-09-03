#include <dart_api_dl.h>
#include <jni.h>
#include <android/log.h>
#define TAG "projectname" // 这个是自定义的LOG的标识
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG,TAG ,__VA_ARGS__) // 定义LOGD类型
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO,TAG ,__VA_ARGS__) // 定义LOGI类型
#define FFI_EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
FFI_EXPORT Dart_Handle InvokeFuncton(Dart_Handle target,
                          Dart_Handle name,
                          int number_of_arguments,
                          Dart_Handle arguments){
                           LOGI("yaoru ++++++++++");
    if(Dart_Invoke_DL) {
    LOGI("yaoru 1++++++++++");
        return Dart_Invoke_DL(target, name, number_of_arguments, &arguments);
    }

    if (Dart_Null_DL) {
    LOGI("yaoru 2++++++++++");
        return Dart_Null_DL();
    }

    return Dart_NewApiError_DL("Dart_Invoke_DL invalid");
}