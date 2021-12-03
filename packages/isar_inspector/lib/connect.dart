import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar_inspector/common.dart';
import 'package:isar_inspector/schema.dart';
import 'package:isar_inspector/service.dart';
import 'package:isar_inspector/app_state.dart';
import 'package:provider/provider.dart';

class ConnectPage extends StatefulWidget {
  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final _uriController = TextEditingController();
  String _message = '';

  Future<void> _connect() async {
    try {
      final service = await Service.connect(_uriController.text);
      final instances = await service.listInstances();
      final schemaJson = await service.getSchema();
      final collections = schemaJson.map((e) {
        final json = e as Map<String, dynamic>;
        return Collection.fromJson(json);
      }).toList();

      final provider = Provider.of<AppState>(context, listen: false);
      provider.service = service;
      provider.instances = instances;
      provider.collections = collections;

      service.onDone.then((value) {
        provider.service = null;
      });

      print('Connected to service $service');
    } catch (e, st) {
      print('ERROR: Unable to connect to VMService');
      print(e);
      print(st);
      setState(() {
        _message = "Can't connect to this VMService: $e";
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: IsarCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Connect to Isar',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 12),
                Text('Paste the URL to the Isar instance.'),
                SizedBox(height: 15),
                TextField(
                  controller: _uriController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'ws://127.0.0.1:41000/auth-code/',
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _connect,
                  child: Text('Connect'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
