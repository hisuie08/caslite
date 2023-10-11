import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caslite/jma/jma_lib.dart';

final weatherProvider = FutureProvider.family<ForecastResult, String>(
    (ref, arg) async => await JMA(City.getById(arg)).get());
