import 'package:flutter_test/flutter_test.dart';
import 'package:maids.cc_test/providers/login_provider.dart';
import 'package:maids.cc_test/services/remote_services.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late LoginProvider loginProvider;

  setUp(() {
    loginProvider = LoginProvider();
  });

  test("initial values are correct", () {
    expect(loginProvider.isLoading, false);
    expect(loginProvider.passwordVisible, false);
    expect(loginProvider.userName.text, "");
    expect(loginProvider.password.text, "");
  });

  test(
    "check if service is making an http request",
    () => () async {
      await loginProvider.login();
      verify(() => RemoteServices.login("", "")).called(1);
    },
  );
}
