import 'package:euex/components/gpsStatus.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/config/environment.dart';
import 'package:euex/database/firebaseFirestoreDb.dart';
import 'package:euex/helpers/permissionHandler.dart';
import 'package:euex/models/order.dart';
import 'package:euex/screens/chat/chatButton.dart';
import 'package:euex/screens/chat/chatPage.dart';
import 'package:euex/screens/home/widgets/googleMaps.dart';
import 'package:euex/screens/home/widgets/ordercountText.dart';
import 'package:euex/screens/home/widgets/topAreaWidget.dart';
import 'package:euex/services/SettingService.dart';
import 'package:euex/services/activeOrderService.dart';
import 'package:euex/services/applicationDataService.dart';
import 'package:euex/services/chatService.dart';
import 'package:euex/services/cloudMessagingService.dart';
import 'package:euex/services/driverService.dart';
import 'package:euex/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../components/singleMenuListScroll.dart';
import '../../helpers/firebaseAuthUser.dart';
import '../../providers/authProvider.dart';
import '../../services/notificationService.dart';

class Home extends StatefulWidget {
  final String? fromAddress;
  final String? toAddress;
  final Order? order;

  const Home({
    this.fromAddress,
    this.toAddress,
    this.order,
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final panelController = PanelController();
  late bool collectionDocStatus;
  late bool deliveryDocStatus;

  @override
  void initState() {
    FirebaseAuthUser().checkCurrentUserState();
    PermissionHandler().requestPermission();
    SettingService().saveAdminSettings();
    OrderService().loadCurrentOrders(context);
    ActiveOrderService().checkCurrentOrderRadius(context);
    Future.delayed(Duration.zero, () {
      ChatService().updateInbox(Provider.of<AuthProvider>(context, listen: false).navigationKey);
    });
   // CloudMessaging().initMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.2;
    final panelHeightopen = MediaQuery.of(context).size.height * 0.95;
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: bPrimaryColor,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 48.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                //NotificatioButton(),
                SizedBox(
                  height: 10,
                ),
                ChatButton()
              ]),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: const NetworkStatus(),
            ),
            const GpsStatus(),
            Expanded(
              child: SlidingUpPanel(
                controller: panelController,
                minHeight: panelHeightClosed,
                maxHeight: panelHeightopen,
                parallaxEnabled: true,
                parallaxOffset: .5,
                body: GoogleMaps(
                  order: widget.order,
                ),
                panelBuilder: (controller) => PanelWidget(
                  controller: controller,
                  panelController: panelController,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future _selectNotification(String? payload) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const ChatPage()),
    );
  }
}

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget(
      {Key? key, required this.controller, required this.panelController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListView(
        padding: EdgeInsets.zero,
        controller: controller,
        children: [
          const SizedBox(
            height: 10,
          ),
          buildDragHandler(),
          const SizedBox(
            height: 5,
          ),
          buildArea(context),
          const SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }

  Widget buildArea(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const TopAreaWidget(),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Container(
            alignment: Alignment.topLeft,
            color: bPrimaryLightColor.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [OrderCountText()],
              ),
            ),
          ),
        ),
        const MenuListScrollView(),
      ]),
    );
  }

  Widget buildDragHandler() {
    return GestureDetector(
      child: Center(
        child: Container(
          width: 30,
          height: 10,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        ),
      ),
      onTap: () => panelController.isPanelOpen
          ? panelController.close()
          : panelController.open(),
    );
  }

  void togglePanel() => panelController.isPanelOpen
      ? panelController.close()
      : panelController.open();
}
