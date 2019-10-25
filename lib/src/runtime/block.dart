import 'dart:ffi';

import 'package:dart_objc/runtime.dart';
import 'package:dart_objc/src/common/channel_dispatch.dart';
import 'package:dart_objc/src/common/library.dart';
import 'package:dart_objc/src/common/native_types.dart';
import 'package:dart_objc/src/common/pointer_encoding.dart';
import 'package:dart_objc/src/runtime/id.dart';
import 'package:dart_objc/src/runtime/message.dart';
import 'package:dart_objc/src/runtime/selector.dart';
import 'package:ffi/ffi.dart';

typedef BlockCreateC = Pointer<Void> Function(
    Pointer<Utf8> typeEncodings, Pointer<NativeFunction<_CallbackC>> callback);
typedef BlockCreateD = Pointer<Void> Function(
    Pointer<Utf8> typeEncodings, Pointer<NativeFunction<_CallbackC>> callback);

final BlockCreateD blockCreate =
    nativeRuntimeLib.lookupFunction<BlockCreateC, BlockCreateD>('block_create');

Map<int, Block> _blockForAddress = {};

class Block extends id {
  Function function;
  NSObject _wrapper;
  List<String> types = [];

  factory Block(Function function) {
    // dart:ffi only supports calling static Dart functions from native code.
    // I choose libffi, Flutter channel and ObjC runtime.
    List<String> types = _typeStringForFunction(function);
    Pointer<Utf8> typeStringPtr = Utf8.toUtf8(types.join(', '));
    NSObject blockWrapper =
        NSObject.fromPointer(blockCreate(typeStringPtr, _callbackPtr));
    Block result =
        Block._internal(blockWrapper.perform(Selector('block')).pointer);
    typeStringPtr.free();
    result.types = types;
    result._wrapper = blockWrapper;
    result.function = function;
    _blockForAddress[result.pointer.address] = result;
    return result;
  }

  factory Block.fromPointer(Pointer<Void> ptr) {
    return Block._internal(ptr);
  }

  Block._internal(Pointer<Void> ptr) : super(ptr) {
    ChannelDispatch().registerChannelCallback('block_invoke', _asyncCallback);
  }

  Block copy() {
    Pointer<Void> newPtr = Block_copy(this.pointer);
    Block result = Block._internal(newPtr);
    result._wrapper = _wrapper;
    if (function != null) {
      result.function = function;
      _blockForAddress[newPtr.address] = result;
    }
    result.types = types;
    return result;
  }

  dealloc() {
    _wrapper.release();
    super.dealloc();
  }

  dynamic invoke([List args]) {
    // TODO: invoke native block
  }
}

typedef _CallbackC = Void Function(
    Pointer<Void> blockPtr,
    Pointer<Pointer<Pointer<Void>>> argsPtrPtr,
    Pointer<Pointer<Void>> retPtr,
    Int32 argCount);

Pointer<NativeFunction<_CallbackC>> _callbackPtr =
    Pointer.fromFunction(_syncCallback);

_callback(Pointer<Void> blockPtr, Pointer<Pointer<Pointer<Void>>> argsPtrPtr,
    Pointer<Pointer<Void>> retPtr, int argCount) {
  Block block = _blockForAddress[blockPtr.address];
  List args = [];
  Pointer pointer = block._wrapper.perform(Selector('typeEncodings'));
  Pointer<Pointer<Utf8>> typesPtrPtr = pointer.cast();
  for (var i = 0; i < argCount; i++) {
    // Get block args encoding. First is return type.
    String encoding = nativeTypeEncoding(typesPtrPtr.elementAt(i + 1).load())
        .load()
        .toString();
    dynamic value =
        loadStructFromPointer(argsPtrPtr.elementAt(i).load(), encoding);
    if (value == null) {
      value =
          loadValueFromPointer(argsPtrPtr.elementAt(i).load().load(), encoding);
    }
    dynamic arg = loadValueForNativeType(block.types[i + 1], value);
    args.add(arg);
  }
  dynamic result = Function.apply(block.function, args);

  if (retPtr != null) {
    String encoding =
        nativeTypeEncoding(typesPtrPtr.elementAt(0).load()).load().toString();
    storeValueToPointer(result, retPtr, encoding);
  }

  _blockForAddress.remove(blockPtr.address);
  block.release();
  return result;
}

_syncCallback(
    Pointer<Void> blockPtr,
    Pointer<Pointer<Pointer<Void>>> argsPtrPtr,
    Pointer<Pointer<Void>> retPtr,
    int argCount) {
  _callback(blockPtr, argsPtrPtr, retPtr, argCount);
}

dynamic _asyncCallback(int blockAddr, int argsAddr, int argCount) {
  Pointer<Void> blockPtr = Pointer.fromAddress(blockAddr);
  Pointer<Pointer<Pointer<Void>>> argsPtrPtr = Pointer.fromAddress(argsAddr);
  return _callback(blockPtr, argsPtrPtr, null, argCount);
}

Map<String, String> _nativeTypeNameMap = {
  'unsigned_short': 'unsigned short',
  'unsigned_int': 'unsigned int',
  'unsigned_long': 'unsigned long',
  'long_long': 'long long',
  'unsigned_long_long': 'unsigned long long',
};

List<String> _nativeTypeNames = [
  'id',
  'BOOL',
  'int',
  'void',
  'char',
  'char',
  'short',
  'unsigned short',
  'unsigned int',
  'long',
  'unsigned long',
  'long long',
  'unsigned long long',
  'float',
  'double',
  'bool',
  'size_t',
  'CGFloat',
  'CGSize',
  'CGRect',
  'CGPoint',
  'CGVector',
  'NSRange',
  'NSInteger',
  'NSUInteger',
  'Class',
  'SEL',
  'Selector'
];

List<String> _typeStringForFunction(Function function) {
  String typeString = function.runtimeType.toString();
  List<String> argsAndRet = typeString.split(' => ');
  if (argsAndRet.length == 2) {
    String args = argsAndRet.first;
    String ret = argsAndRet.last.replaceAll('Null', 'void');
    if (args.length > 2) {
      args = args.substring(1, args.length - 1);
      _nativeTypeNameMap.forEach((String dartTypeName, String nativeTypeName) {
        args = args.replaceAll(dartTypeName, nativeTypeName);
      });
      return '$ret, $args'.split(', ').map((String s) {
        // TODO: handle NSObject **
        if (s.contains('Pointer')) {
          return 'ptr';
        } else if (s.contains('Function')) {
          return 'block';
        } else if (!_nativeTypeNames.contains(s)) {
          return 'NSObject';
        }
        return s;
      }).toList();
    } else {
      return [ret];
    }
  }
  return [];
}
