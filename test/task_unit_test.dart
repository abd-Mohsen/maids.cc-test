import 'package:flutter_test/flutter_test.dart';
import 'package:maids.cc_test/providers/task_provider.dart';

void main() {
  late TaskProvider taskProvider;

  setUp(() {
    taskProvider = TaskProvider();
  });

  test("initial values are correct", () {
    expect(taskProvider.tasks, []);
    expect(taskProvider.isLoading, false);
  });

  group("get tasks", () {
    test(
        "check if service is making an http request",
        () => () {
              //
            });
  });
}
