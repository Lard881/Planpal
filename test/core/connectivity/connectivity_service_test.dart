import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/connectivity/connectivity_service.dart';
import 'package:planpal/core/widgets/empty_state.dart';

void main() {
  group('classifyReachability', () {
    test('classifies a disconnected device as offline', () {
      expect(
        classifyReachability(
          hasNetwork: false,
          hasInternet: false,
          backendReachable: false,
        ),
        ConnectivityState.offline,
      );
    });

    test('classifies Wi-Fi without internet as offline', () {
      expect(
        classifyReachability(
          hasNetwork: true,
          hasInternet: false,
          backendReachable: false,
        ),
        ConnectivityState.offline,
      );
    });

    test('distinguishes an API outage from lost internet', () {
      expect(
        classifyReachability(
          hasNetwork: true,
          hasInternet: true,
          backendReachable: false,
        ),
        ConnectivityState.serverUnreachable,
      );
    });

    test('reports online when the API responds', () {
      expect(
        classifyReachability(
          hasNetwork: true,
          hasInternet: true,
          backendReachable: true,
        ),
        ConnectivityState.online,
      );
    });
  });
}
