#include <dart/dart_api_dl.h>
FFI_EXPORT Dart_Handle InvokeFuncton(Dart_Handle target,
                          Dart_Handle name,
                          int number_of_arguments,
                          Dart_Handle arguments){
    if(Dart_Invoke_DL) {
        return Dart_Invoke_DL(target, name, number_of_arguments, &arguments);
    }

    if (Dart_Null_DL) {
        return Dart_Null_DL();
    }

    return Dart_NewApiError_DL("Dart_Invoke_DL invalid");
}