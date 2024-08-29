import 'package:fetch_apis/model/user.dart';
import 'package:fetch_apis/provider/user_provider.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:fetch_apis/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Userprovider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Api',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Splash(),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Userprovider())
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Center(
                child: Text(context.watch<Userprovider>().name.toString())),
            // title: Center(child: Text(widget.title)),
          ),
          body: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final email = user.email;
                final name = user.name;
                return ListTile(
                  leading: CircleAvatar(
                    // child: Image.network(image),
                    child: Text("${index + 1}"),
                  ),
                  subtitle: Text(email!),
                  title: Text(name!),
                );
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: fetchUser,
            child: const Text('\$'),
          ),
          // floatingActionButton: FloatingActionButton(onPressed: fetchUser),
        ));
  }

  void fetchUser() async {
    var response = await UserApi.fetchUsers();
    if (response != null) {
      setState(() {
        users = response;
      });
    } else {
      UserApi.dialogBox(context, 'Api didn\'t respond! ');
    }
  }
}
