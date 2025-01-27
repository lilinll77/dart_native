import 'dart:ffi';

import 'package:dart_native/src/ios/runtime.dart';
import 'package:dart_native/src/ios/runtime/internal/functions.dart';
import 'package:dart_native/src/ios/runtime/id.dart';
import 'package:dart_native/src/ios/runtime/internal/native_runtime.dart';
import 'package:ffi/ffi.dart';
import 'package:dart_native/src/ios/common/library.dart';

/// Stands for `Class` in iOS.
///
/// An opaque type that represents an Objective-C class.
class Class extends id {
  String name;

  static final Map<int, Class> _cache = <int, Class>{};

  /// Create a class for Objective-C.
  ///
  /// Obtain an existing class by [name], or creating a new class using [name] and
  /// its [superclass].
  factory Class(String name, [Class superclass]) {
    Pointer<Void> ptr = _getClass(name, superclass);
    if (ptr == nullptr) {
      throw 'class $name is not exists!';
    }
    if (_cache.containsKey(ptr.address)) {
      return _cache[ptr.address];
    } else {
      return Class._internal(name, ptr);
    }
  }

  factory Class.fromPointer(Pointer<Void> ptr) {
    if (ptr == nullptr) {
      return null;
    }
    int key = ptr.address;
    if (_cache.containsKey(key)) {
      return _cache[key];
    } else {
      if (object_isClass(ptr) != 0) {
        String name = Utf8.fromUtf8(class_getName(ptr));
        return Class._internal(name, ptr);
      } else {
        throw 'Pointer $ptr is not for Class!';
      }
    }
  }

  Class._internal(this.name, Pointer ptr) : super(ptr) {
    _cache[ptr.address] = this;
  }

  @override
  String toString() {
    return name;
  }
}

Pointer<Void> _getClass(String className, [Class superclass]) {
  if (className == null) {
    className = 'NSObject';
  }
  final classNamePtr = Utf8.toUtf8(className);
  Pointer<Void> basePtr = superclass?.pointer;
  Pointer<Void> result;
  if (superclass == null) {
    result = objc_getClass(classNamePtr);
  } else {
    result = nativeGetClass(classNamePtr, basePtr);
  }
  free(classNamePtr);
  return result;
}

Object invokeDartMethord(Object target, String name, int argCount, List args) {
  dynamic result = '';
  if (initDartAPISuccess) {
    result = invokeDart(target, name, argCount, args);
  }

  return result;
}

Object InvokeDartNew(Object type, String constructor_name,
    int number_of_arguments, List arguments) {
  dynamic result = '';
  if (initDartAPISuccess) {
    result =
        invokeDartNew(type, constructor_name, number_of_arguments, arguments);
  }

  return result;
}

Object InvokeDartGetType(Object library, String class_name,
    int number_of_type_arguments, List type_arguments) {
  dynamic result = '';
  if (initDartAPISuccess) {
    result = invokeDartGetType(
        library, class_name, number_of_type_arguments, type_arguments);
  }

  return result;
}

Object InvokeDartRootLibrary() {
  dynamic result = null;
  if (initDartAPISuccess) {
    result = invokeDartRootLibrary();
  }

  return result;
}

Object InvokeDartGetLoadedLibraries() {
  dynamic result = null;
  if (initDartAPISuccess) {
    result = invokeDartGetLoadedLibraries();
  }

  return result;
}
