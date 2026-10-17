import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/config/env.dart';

void main() {
  test('uses the deployed PlanPal API URL by default', () {
    expect(Env.apiBaseUrl, 'https://planpalbackend.onrender.com/api/v1');
  });
}
