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
  }

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
      child: Scaffold(
        backgroundColor: cs.background,
        appBar: AppBar(
          title: Text(
            "all tasks",
          ),
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
                          child:
                              userProvider.currentUser == null ? null : Image.network(userProvider.currentUser!.image),
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
                        child: Text("ok"),
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
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => AddTaskBottomSheet(),
            );
          },
        ),
        body: Consumer<TaskProvider>(builder: (_, taskProvider, child) {
          return taskProvider.isLoading
              ? Center(child: CircularProgressIndicator(color: cs.onBackground))
              : ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, i) {
                    TaskModel task = taskProvider.tasks[i];
                    return TaskCard(task: task);
                  },
                );
        }),
      ),
    );
  }
}
