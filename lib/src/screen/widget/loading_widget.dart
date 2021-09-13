import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingCellWidget extends StatelessWidget {
  const LoadingCellWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: CupertinoActivityIndicator(
          radius: 12.0,
        ),
      ),
    );
  }
}
