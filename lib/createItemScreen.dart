import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class CreateItemScreen extends StatefulWidget {

  const CreateItemScreen({super.key, required this.location});

  final GeoPoint location;

  @override
  State<CreateItemScreen> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItemScreen> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create location memory'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter title',
                  hintText: 'Enter title',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                minLines: 2,//Normal textInputField will be displayed
                maxLines: 5,// when user presses enter it will adapt to it
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter description',
                  hintText: 'Enter description',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      setState(() {
                        // save
                      });
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}