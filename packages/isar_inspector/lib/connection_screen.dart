import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar_inspector/connect_client.dart';
import 'package:isar_inspector/connected_layout.dart';
import 'package:isar_inspector/error_screen.dart';

class ConnectionScreen extends StatefulWidget {
  final Uri websocketUri;
  const ConnectionScreen({
    required this.websocketUri,
    super.key,
  });

  @override
  State<ConnectionScreen> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionScreen> {
  late Future<ConnectClient> clientFuture;

  @override
  void initState() {
    clientFuture = ConnectClient.connect(websocketUri: widget.websocketUri);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ConnectionScreen oldWidget) {
    if (oldWidget.websocketUri != widget.websocketUri) {
      clientFuture = ConnectClient.connect(websocketUri: widget.websocketUri);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConnectClient>(
      future: clientFuture,
      builder: (context, snapshot) {
        final Widget child = () {
          if (snapshot.hasData) {
            return _InstancesLoader(client: snapshot.data!);
          } else if (snapshot.hasError) {
            return const ErrorScreen();
          }
          return const Loading();
        }();
        if (child is _InstancesLoader) {
          return child;
        }
        final MediaQueryData mediaQueryData = MediaQuery.of(context);

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: mediaQueryData.size.height,
                minWidth: mediaQueryData.size.width,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _InstancesLoader extends StatefulWidget {
  const _InstancesLoader({required this.client});

  final ConnectClient client;

  @override
  State<_InstancesLoader> createState() => _InstancesLoaderState();
}

class _InstancesLoaderState extends State<_InstancesLoader> {
  late Future<List<String>> instancesFuture;
  late StreamSubscription<void> _instancesSubscription;

  @override
  void initState() {
    instancesFuture = widget.client.listInstances();
    _instancesSubscription = widget.client.instancesChanged.listen((event) {
      setState(() {
        instancesFuture = widget.client.listInstances();
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _InstancesLoader oldWidget) {
    instancesFuture = widget.client.listInstances();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _instancesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: instancesFuture,
      builder: (context, snapshot) {
      final child = ()  {
          if (snapshot.hasData) {
            return ConnectedLayout(
              client: widget.client,
              instances: snapshot.data!,
            );
          } else if (snapshot.hasError) {
            return const ErrorScreen();
          }
          return const Loading();
        }
        (); 
        if (child is ConnectedLayout) {
          return child;
        }
        final MediaQueryData mediaQueryData = MediaQuery.of(context);

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: mediaQueryData.size.height,
                minWidth: mediaQueryData.size.width,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
