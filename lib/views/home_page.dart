import 'package:flutter/material.dart';
import 'package:maids.cc_test/models/task_model.dart';
import 'package:maids.cc_test/providers/user_provider.dart';
import 'package:maids.cc_test/views/widgets/add_task_bottom_sheet.dart';
import 'package:maids.cc_test/views/widgets/task_card.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/task_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).getTasks();
      Provider.of<UserProvider>(context, listen: false).getAuthUser();
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        Provider.of<TaskProvider>(context, listen: false).getTasks();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  ScrollController scrollController = ScrollController();

  void logout() {
    prefs.remove("token");
    prefs.remove("refreshToken");
    navigatorKey.currentState!.pushNamedAndRemoveUntil("/login", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    ColorScheme cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: Provider.of<TaskProvider>(context, listen: false).refreshTasks,
        child: Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            title: const Text("all tasks"),
            backgroundColor: cs.surface,
          ),
          drawer: Drawer(
            child: Column(
              children: [
                Consumer<UserProvider>(
                  builder: (_, userProvider, child) => userProvider.isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator(color: cs.onBackground)),
                        )
                      : UserAccountsDrawerHeader(
                          accountName: Text(userProvider.currentUser?.firstName ?? ""),
                          accountEmail: Text(userProvider.currentUser?.email ?? ""),
                          currentAccountPicture: CircleAvatar(
                            child: userProvider.currentUser == null
                                ? null
                                : Image.network(userProvider.currentUser!.image),
                          ),
                        ),
                ),
                //todo: make light mode if there is time
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                  ),
                  title: Text(
                    "about app",
                    style: tt.titleLarge,
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Flutter developer test"),
                      content: const Text("test project that demonstrates proficiency in Flutter development. The test "
                          "project will focus on various aspects, including clean code & architecture, "
                          "state management patterns, performance optimization, handling local storage, "
                          "and writing unit tests\n\ntest is offered by: maids.cc company\n\n"
                          "developed by: Abdulrahman Mohsen."),
                      actions: [
                        TextButton(
                          onPressed: () => navigatorKey.currentState!.pop(),
                          child: const Text("ok"),
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    "logout",
                    style: tt.titleLarge,
                  ),
                  onTap: () => logout(),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const AddTaskBottomSheet(),
              );
            },
          ),
          body: Consumer<TaskProvider>(builder: (_, taskProvider, child) {
            return taskProvider.isLoading
                ? Center(child: CircularProgressIndicator(color: cs.onBackground))
                : ListView.builder(
                    controller: scrollController,
                    itemCount: taskProvider.tasks.length + 1,
                    itemBuilder: (context, i) {
                      if (i < taskProvider.tasks.length) {
                        TaskModel task = taskProvider.tasks[i];
                        return TaskCard(task: task);
                      }
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: taskProvider.hasMore
                              ? CircularProgressIndicator(color: cs.primary)
                              : CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Colors.grey.withOpacity(0.7),
                                ),
                        ),
                      );
                    },
                  );
          }),
        ),
      ),
    );
  }
}
