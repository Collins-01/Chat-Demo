import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/utils.dart';

class LoaderPage extends StatelessWidget {
  final Widget child;
  final bool busy;
  const LoaderPage({Key? key, required this.child, required this.busy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: child,
          ),
          busy
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.75),
                  child: SpinKitDoubleBounce(
                    color: AppColors.primaryColor,
                    size: 180,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
