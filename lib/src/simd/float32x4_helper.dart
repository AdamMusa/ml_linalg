import 'dart:math' as math;
import 'dart:typed_data';

import 'package:linalg/src/simd/simd_helper.dart';

class Float32x4Helper implements SIMDHelper<Float32x4List, Float32List, Float32x4> {

  @override
  final bucketSize = 4;

  const Float32x4Helper();

  @override
  Float32x4 createSIMDFilled(double value) => Float32x4.splat(value);

  @override
  Float32x4 createSIMDFromSimpleList(List<double> list) {
    final x = list.isNotEmpty ? list[0] ?? 0.0 : 0.0;
    final y = list.length > 1 ? list[1] ?? 0.0 : 0.0;
    final z = list.length > 2 ? list[2] ?? 0.0 : 0.0;
    final w = list.length > 3 ? list[3] ?? 0.0 : 0.0;
    return Float32x4(x, y, z, w);
  }

  @override
  Float32x4 simdSum(Float32x4 a, Float32x4 b) => a + b;

  @override
  Float32x4 simdSub(Float32x4 a, Float32x4 b) => a - b;

  @override
  Float32x4 simdMul(Float32x4 a, Float32x4 b) => a * b;

  @override
  Float32x4 simdDiv(Float32x4 a, Float32x4 b) => a / b;

  @override
  Float32x4 simdAbs(Float32x4 a) => a.abs();

  @override
  double singleSIMDSum(Float32x4 a) => (a.x.isNaN ? 0.0 : a.x) + (a.y.isNaN ? 0.0 : a.y) + (a.z.isNaN ? 0.0 : a.z) +
    (a.w.isNaN ? 0.0 : a.w);

  @override
  Float32x4List createSIMDList(int length) => Float32x4List(length);

  @override
  Float32List createTypedList(int length) => Float32List(length);

  @override
  Float32List createTypedListFromList(List<double> list) => Float32List.fromList(list);

  @override
  Float32List createTypedListFromByteBuffer(ByteBuffer buffer, [List<double> residuals]) {
    final collection = <double>[];
    for (double el in buffer.asFloat32List()) {
      collection.add(el);
    }
    collection.addAll(residuals ?? []);
    buffer.asByteData();
    return Float32List.fromList(collection);
  }

  @override
  double getScalarByOffsetIndex(Float32x4 value, int offset) {
    switch (offset) {
      case 0:
        return value.x;
      case 1:
        return value.y;
      case 2:
        return value.z;
      case 3:
        return value.w;
      default:
        throw RangeError('wrong offset');
    }
  }

  @override
  Float32x4 selectMax(Float32x4 a, Float32x4 b) => a.max(b);

  @override
  double getMaxLane(Float32x4 a) => math.max(math.max(a.x, a.y), math.max(a.z, a.w));

  @override
  Float32x4 selectMin(Float32x4 a, Float32x4 b) => a.min(b);

  @override
  double getMinLane(Float32x4 a) => math.min(math.min(a.x, a.y), math.min(a.z, a.w));

  @override
  List<double> simdToList(Float32x4 a) => <double>[a.x, a.y, a.z, a.w];

  @override
  List<double> takeFirstNLanes(Float32x4 a, int n) => simdToList(a)
      .take(n)
      .toList();

  @override
  ByteData addDataToByteData(ByteData byteData, List<double> data) {
    for (double value in data) {
      byteData.setFloat32(byteData.lengthInBytes, value);
    }
    return byteData;
  }

  @override
  Float32x4List sublist(Float32x4List list, int start, [int end]) =>
      list.buffer.asFloat32x4List(start, end);
}
