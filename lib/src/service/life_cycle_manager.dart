import 'package:flutter/material.dart';

class LifecycleCallback {
  final Function()? onResumed;
  final Function()? onPaused;
  final Function()? onInactive;
  final Function()? onDetached;
  LifecycleCallback({
    this.onResumed,
    this.onPaused,
    this.onInactive,
    this.onDetached,
  });
}

class LifecycleWidget extends StatefulWidget {
  final Widget child;
  final LifecycleCallback callback;

  LifecycleWidget({Key? key, required this.child, required this.callback})
      : super(key: key);

  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifecycleWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print('state = $state');
    switch (state) {
      case AppLifecycleState.resumed:
        widget.callback.onResumed != null
            ? widget.callback.onResumed!()
            : print("RESUME");
        break;
      case AppLifecycleState.inactive:
        widget.callback.onInactive != null
            ? widget.callback.onInactive!()
            : print("INACTIVE");
        break;
      case AppLifecycleState.paused:
        widget.callback.onPaused != null
            ? widget.callback.onPaused!()
            : print("PAUSE");
        break;
      case AppLifecycleState.detached:
        widget.callback.onDetached != null
            ? widget.callback.onDetached!()
            : print("DETATCH");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
