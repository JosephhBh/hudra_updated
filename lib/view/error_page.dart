import 'package:flutter/material.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:provider/provider.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Provider.of<ProviderGlobal>(context).goBackAll(),
      child: Center(
        child: Text('Page Not Found',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
