import 'package:flutter_test/flutter_test.dart';
import 'package:maids.cc_test/providers/task_provider.dart';
import 'package:maids.cc_test/services/local_services.dart';
import 'package:maids.cc_test/services/remote_services.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late TaskProvider taskProvider;

  setUp(() {
    taskProvider = TaskProvider();
  });

  test("initial values are correct", () {
    expect(taskProvider.tasks, []);
    expect(taskProvider.isLoading, false);
    expect(taskProvider.page, 0);
  });

  group("get tasks", () {
    test(
      "check if service is making an http request",
      () => () async {
        await taskProvider.getTasks();
        verify(() => RemoteServices.fetchTasks()).called(1);
      },
    );
    test(
      "check if service is accessing local storage",
      () => () async {
        await taskProvider.getTasks();
        verify(() => LocalServices.replaceTasks([])).called(1);
      },
    );
  });
}
