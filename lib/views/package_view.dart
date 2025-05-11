import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageView extends StatefulWidget {
  const PackageView({super.key});

  @override
  State<PackageView> createState() => _PackageViewState();
}

class _PackageViewState extends State<PackageView> {
  Map<String, dynamic> myPackageData = {};
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      myPackageData = value.data;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Package Infos Details")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            myPackageData.toString(),
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
