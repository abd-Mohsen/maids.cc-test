import 'package:flutter/material.dart';
import 'package:maids.cc_test/providers/user_provider.dart';
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
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(
                  "logout",
                  style: tt.titleLarge,
                ),
                onTap: () => navigatorKey.currentState!.pushNamedAndRemoveUntil("/login", (route) => false),
                //todo: delete tokens when logging put
              )
            ],
          ),
        ),
        body: Consumer<TaskProvider>(builder: (_, taskProvider, child) {
          return taskProvider.isLoading
              ? Center(child: CircularProgressIndicator(color: cs.onBackground))
              : ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, i) {
                    var task = taskProvider.tasks[i];
                    return ListTile(
                      title: Text(task.todo),
                      //subtitle: Text(task.a),
                      leading: Icon(Icons.task_alt),
                    );
                  });
        }),
      ),
    );
  }
}
