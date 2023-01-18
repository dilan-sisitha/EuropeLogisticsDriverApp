import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Text(
          AppLocalizations.of(context)!.loading,
          style: lgLTextDark,
        )),
      ),
    );
  }
}
