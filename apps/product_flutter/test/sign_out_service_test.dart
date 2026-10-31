import 'package:flutter_test/flutter_test.dart';
import 'package:scoutlink_product/features/auth/application/sign_out_service.dart';

void main() {
  test('logout ends the session and clears device-only account data', () async {
    var sessionEnded = false;
    var deviceDataCleared = false;
    final service = SignOutService(
      endSession: () async => sessionEnded = true,
      clearDeviceData: () async => deviceDataCleared = true,
    );

    await service.signOut();

    expect(sessionEnded, isTrue);
    expect(deviceDataCleared, isTrue);
  });

  test('device-only account data is cleared if session logout fails', () async {
    var deviceDataCleared = false;
    final service = SignOutService(
      endSession: () async => throw StateError('network unavailable'),
      clearDeviceData: () async => deviceDataCleared = true,
    );

    await expectLater(service.signOut(), throwsStateError);
    expect(deviceDataCleared, isTrue);
  });
}
