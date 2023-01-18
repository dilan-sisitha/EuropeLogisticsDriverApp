import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NetworkStatus extends StatelessWidget {
  const NetworkStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<NetworkConnectivityProvider>(context, listen: false)
            .previousState &&
        Provider.of<NetworkConnectivityProvider>(context).isOnline) {
      return Container();
    } else if (Provider.of<NetworkConnectivityProvider>(context).isOnline) {
      return AnimatedSwitcher(
        child: Container(
          key: UniqueKey(),
          width: double.infinity,
          height: 45.0,
          color: Colors.green,
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cached_rounded,
                color: Colors.white,
                size: 19,
              ),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.deviceIsOnline,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
      );
    } else {
      return AnimatedSwitcher(
        child: Provider.of<NetworkConnectivityProvider>(context).isOnline
            ? Container()
            : Container(
                key: UniqueKey(),
                width: double.infinity,
                height: 45.0,
                color:
                    !Provider.of<NetworkConnectivityProvider>(context).isOnline
                        ? Colors.red
                        : Colors.red,
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 19,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.deviceIsOffline,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
