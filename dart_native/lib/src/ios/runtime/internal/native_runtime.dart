import 'dart:ffi';

import 'package:dart_native/src/ios/common/library.dart';
import 'package:ffi/ffi.dart';

typedef MethodSignature = Pointer<Void> Function(
    Pointer<Void> instance, Pointer<Void> selector);
final MethodSignature nativeMethodSignature =
    runtimeLib.lookupFunction<MethodSignature, MethodSignature>(
        'native_method_signature');

typedef SignatureEncodingListC = Void Function(Pointer<Void> signature,
    Pointer<Pointer<Utf8>> typeEncodings, Int64 decodeRetVal);
typedef SignatureEncodingListD = void Function(Pointer<Void> signature,
    Pointer<Pointer<Utf8>> typeEncodings, int decodeRetVal);
final SignatureEncodingListD nativeSignatureEncodingList =
    runtimeLib.lookupFunction<SignatureEncodingListC, SignatureEncodingListD>(
        'native_signature_encoding_list');

typedef AddMethodC = Int32 Function(
    Pointer<Void> target,
    Pointer<Void> selector,
    Pointer<Utf8> types,
    Pointer<NativeFunction<MethodIMPCallbackC>> callback,
    Int64 dartPort);
typedef AddMethodD = int Function(
    Pointer<Void> target,
    Pointer<Void> selector,
    Pointer<Utf8> types,
    Pointer<NativeFunction<MethodIMPCallbackC>> callback,
    int dartPort);
final AddMethodD nativeAddMethod =
    runtimeLib.lookupFunction<AddMethodC, AddMethodD>('native_add_method');

typedef ProtocolMethodTypes = Pointer<Utf8> Function(
    Pointer<Void> protocol, Pointer<Void> selector);
final ProtocolMethodTypes nativeProtocolMethodTypes =
    runtimeLib.lookupFunction<ProtocolMethodTypes, ProtocolMethodTypes>(
        'native_protocol_method_types');

typedef GetClassC = Pointer<Void> Function(
    Pointer<Utf8> className, Pointer<Void> baseClass);
typedef GetClassD = Pointer<Void> Function(
    Pointer<Utf8> className, Pointer<Void> baseClass);
final GetClassD nativeGetClass =
    runtimeLib.lookupFunction<GetClassC, GetClassD>('native_get_class');

/// When [queue] is not `nullptr`, method will be invoked asynchronously.
/// [callback] is ignored when queue equals to `nullptr`.
typedef InvokeMethodC = Pointer<Void> Function(
  Pointer<Void> instance,
  Pointer<Void> selector,
  Pointer<Void> signature,
  Pointer<Void> queue,
  Pointer<Pointer<Void>> args,
  Pointer<Void> callback,
  Int64 dartPort,
  Int64 stringTypeBitmask,
  Pointer<Pointer<Utf8>> retType,
);
typedef InvokeMethodD = Pointer<Void> Function(
  Pointer<Void> instance,
  Pointer<Void> selector,
  Pointer<Void> signature,
  Pointer<Void> queue,
  Pointer<Pointer<Void>> args,
  Pointer<Void> callback,
  int dartPort,
  int stringTypeBitmask,
  Pointer<Pointer<Utf8>> retType,
);
final InvokeMethodD nativeInvokeMethod = runtimeLib
    .lookupFunction<InvokeMethodC, InvokeMethodD>('native_instance_invoke');

typedef MethodIMPCallbackC = Void Function(
    Pointer<Pointer<Pointer<Void>>> argsPtrPtr,
    Pointer<Pointer<Void>> retPtr,
    Int32 argCount,
    Pointer<Pointer<Utf8>> types,
    Int32 stret);

typedef AllTypeEncodings = Pointer<Pointer<Utf8>> Function();
final AllTypeEncodings nativeAllTypeEncodings =
    runtimeLib.lookupFunction<AllTypeEncodings, AllTypeEncodings>(
        'native_all_type_encodings');

typedef TypeEncodingC = Pointer<Utf8> Function(Pointer<Utf8> str);
typedef TypeEncodingD = Pointer<Utf8> Function(Pointer<Utf8> str);
final TypeEncodingD nativeTypeEncoding = runtimeLib
    .lookupFunction<TypeEncodingC, TypeEncodingD>('native_type_encoding');

typedef TypesEncodingC = Pointer<Pointer<Utf8>> Function(
    Pointer<Utf8> str, Pointer<Int32> count, Int32 startIndex);
typedef TypesEncodingD = Pointer<Pointer<Utf8>> Function(
    Pointer<Utf8> str, Pointer<Int32> count, int startIndex);
final TypesEncodingD nativeTypesEncoding = runtimeLib
    .lookupFunction<TypesEncodingC, TypesEncodingD>('native_types_encoding');

typedef BlockCallbackC = Void Function(
    Pointer<Pointer<Pointer<Void>>> argsPtrPtrPtr,
    Pointer<Pointer<Void>> retPtrPtr,
    Int32 argCount,
    Int32 stret,
    Int64 seq);
typedef BlockCreateC = Pointer<Void> Function(Pointer<Utf8> typeEncodings,
    Pointer<NativeFunction<BlockCallbackC>> callback, Int64 dartPort);
typedef BlockCreateD = Pointer<Void> Function(Pointer<Utf8> typeEncodings,
    Pointer<NativeFunction<BlockCallbackC>> callback, int dartPort);
final BlockCreateD blockCreate = runtimeLib
    .lookupFunction<BlockCreateC, BlockCreateD>('native_block_create');

typedef BlockInvokeC = Pointer<Void> Function(
  Pointer<Void> block,
  Pointer<Pointer<Void>> args,
  Int64 dartPort,
  Int64 stringTypeBitmask,
  Pointer<Pointer<Utf8>> retType,
);
typedef BlockInvokeD = Pointer<Void> Function(
  Pointer<Void> block,
  Pointer<Pointer<Void>> args,
  int dartPort,
  int stringTypeBitmask,
  Pointer<Pointer<Utf8>> retType,
);
final BlockInvokeD blockInvoke = runtimeLib
    .lookupFunction<BlockInvokeC, BlockInvokeD>('native_block_invoke');

final void Function(Pointer<Void>) retainObject = nativeDylib
    .lookup<NativeFunction<Void Function(Pointer<Void>)>>(
        'native_retain_object')
    .asFunction();

typedef ConvertNSStringToUTF16 = Pointer<Void> Function(
    Pointer<Void>, Pointer<Uint64>);
final ConvertNSStringToUTF16 convertNSStringToUTF16 =
    nativeDylib.lookupFunction<ConvertNSStringToUTF16, ConvertNSStringToUTF16>(
        'native_convert_nsstring_to_utf16');

final int Function(Object, Pointer<Void>) passObjectToC = nativeDylib
    .lookup<NativeFunction<Int32 Function(Handle, Pointer<Void>)>>(
        "PassObjectToCUseDynamicLinking")
    .asFunction();

final Object Function(Object, Object, int, Object) invokeDart = nativeDylib
    .lookup<NativeFunction<Handle Function(Handle, Handle, Int32, Handle)>>(
        "InvokeFuncton")
    .asFunction();

final Object Function(Object, Object, int, Object) invokeDartNew = nativeDylib
    .lookup<NativeFunction<Handle Function(Handle, Handle, Int32, Handle)>>(
        "InvokeDartNew")
    .asFunction();

final Object Function(Object, Object, int, Object) invokeDartGetType = nativeDylib
    .lookup<NativeFunction<Handle Function(Handle, Handle, Int32, Handle)>>(
        "InvokeDartGetType")
    .asFunction();

final Object Function() invokeDartRootLibrary = nativeDylib
    .lookup<NativeFunction<Handle Function()>>(
        "InvokeDartRootLibrary")
    .asFunction();

final Object Function() invokeDartGetLoadedLibraries = nativeDylib
    .lookup<NativeFunction<Handle Function()>>(
        "InvokeDartGetLoadedLibraries")
    .asFunction();


