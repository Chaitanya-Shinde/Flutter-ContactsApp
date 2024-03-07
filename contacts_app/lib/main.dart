import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    title: 'ContactsApp',
    theme: ThemeData(primarySwatch: Colors.blue),
    debugShowCheckedModeBanner: false,
    home: const MyApp(),
    routes: {
      '/new-contact': (context) => const NewContactView(),
    },
  ));
}

class Contact {
  final String id;
  final String name;
  Contact({required this.name}) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook shared = ContactBook._sharedInstance();
  factory ContactBook() => shared;

  int get contactsLength => value.length;

  void addContact({required Contact contact}) {
    final _contacts = value;
    _contacts.add(contact);
    notifyListeners();
  }

  void removeContact({required Contact contact}) {
    final _contacts = value;
    if (_contacts.contains(contact)) {
      _contacts.remove(contact);
      value = _contacts;
      notifyListeners();
    }
  }

  //function retrieves a contact at the desired atIndex inside the contacts list and returns the contact
  //return type Contact optional
  Contact? retrieveContact({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactBook contactBook = ContactBook();

    return Scaffold(
      appBar: AppBar(
        title: const Text('homepage'),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          final contacts = value as List<Contact>;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int index) {
              final contact = contacts[index];
              return Dismissible(
                onDismissed: (direction) {
                  //contacts.remove(contact);
                  ContactBook().removeContact(contact: contact);
                },
                key: ValueKey(contact.id),
                child: Material(
                  color: Colors.white,
                  elevation: 5,
                  child: ListTile(
                    title: Text(contact.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/new-contact');
        },
        backgroundColor: Colors.blue[200],
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

//TODO: move this NewContactView to another file
class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Enter contact name"),
          ),
          TextButton(
              onPressed: () {
                if (textController.text.trim().isEmpty == false) {
                  final contact = Contact(name: textController.text);
                  ContactBook().addContact(contact: contact);
                  Navigator.of(context).pop();
                } else {
                  debugPrint("empty");
                  const snackBar = SnackBar(
                    content: Text('Please enter something!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text('Add Contact')),
        ],
      ),
    );
  }
}
