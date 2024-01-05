import 'package:flutter/material.dart';

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
  final String name;
  const Contact({required this.name});
}

class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook shared = ContactBook._sharedInstance();
  factory ContactBook() => shared;

  final List<Contact> contacts = [];
  int get contactsLength => contacts.length;

  void addContact({required Contact contact}) {
    contacts.add(contact);
  }

  void removeContact({required Contact contact}) {
    contacts.remove(contact);
  }

  //function retrieves a contact at the desired atIndex inside the contacts list and returns the contact
  //return type Contact optional
  Contact? retrieveContact({required int atIndex}) =>
      contacts.length > atIndex ? contacts[atIndex] : null;
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
      body: ListView.builder(
        itemCount: contactBook.contactsLength,
        itemBuilder: (BuildContext context, int index) {
          final contact = contactBook.retrieveContact(atIndex: index)!;
          return ListTile(
            title: Text(contact.name),
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
                final contact = Contact(name: textController.text);
                ContactBook().addContact(contact: contact);
                Navigator.of(context).pop();
              },
              child: const Text('Add Contact')),
        ],
      ),
    );
  }
}
