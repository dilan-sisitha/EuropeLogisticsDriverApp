import 'package:euex/components/button.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/order.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/detailTabs.dart';
import 'package:euex/services/activeOrderService.dart';
import 'package:euex/services/clearanceDocService.dart';
import 'package:euex/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryLocationDetails extends StatefulWidget {
  const DeliveryLocationDetails({
    Key? key,
    required this.order,
    required this.showLocation,
  }) : super(key: key);
  final Order order;
  final bool showLocation;

  @override
  State<DeliveryLocationDetails> createState() =>
      _DeliveryLocationDetailsState();
}

class _DeliveryLocationDetailsState extends State<DeliveryLocationDetails> {
  String _title = 'please wait ..';
  String _subtitle = '';

  @override
  void initState() {
    _updateLocationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsTab(
      titleText: widget.showLocation
          ? _title
          : AppLocalizations.of(context)!.deliveryLocation,
      subTitleText: widget.showLocation
          ? _subtitle
          : OrderService()
              .getPostalCode(widget.order.to, widget.order.toAddress),
      iconName: const Icon(
        Icons.location_on,
        color: iconcolors3,
      ),
      elevButton: (widget.showLocation && _documentButtonText != null)
          ? buttonYellow(
              btnText: _documentButtonText!,
              press: _updateDocumentCollectionStatus,
            )
          : Container(),
    );
  }

  _updateDocumentCollectionStatus() async {
    if (_documentCollectionType != null) {
      await ClearanceDocService()
          .saveClearanceDocStatus(widget.order, _documentCollectionType!);
    }
    _updateLocationData();
  }

  _updateLocationData() {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        _title = _locationType;
        _subtitle = _address;
      });
    });
  }

  String get _locationType {
    String? _docCollectionType = _documentCollectionType;
    if (_docCollectionType == ClearanceDocService.pickup) {
      return AppLocalizations.of(context)!.documentCollectionPoint;
    } else if (_docCollectionType == ClearanceDocService.release) {
      return AppLocalizations.of(context)!.documentReleasePoint;
    }
    return AppLocalizations.of(context)!.deliveryLocation;
  }

  String get _address {
    String? orderStatus =
        ActiveOrderService().getActiveOrderStatus(widget.order.id);
    String? _docCollectionType = _documentCollectionType;
    if (_docCollectionType != null) {
      if (_docCollectionType == ClearanceDocService.pickup) {
        return widget.order.documentPickupPoint!;
      } else if (_docCollectionType == ClearanceDocService.release) {
        return widget.order.documentReleasePoint!;
      }
    } else if (orderStatus == ActiveOrderService.loadingEnd) {
      return widget.order.toAddress;
    }
    return OrderService()
        .getPostalCode(widget.order.to, widget.order.toAddress);
  }

  String? get _documentButtonText {
    String? _docCollectionType = _documentCollectionType;
    if (_docCollectionType == ClearanceDocService.pickup) {
      return AppLocalizations.of(context)!.iHaveCollectedDocuments;
    } else if (_docCollectionType == ClearanceDocService.release) {
      return AppLocalizations.of(context)!.iSubmittedDocuments;
    }
    return null;
  }

  String? get _documentCollectionType {
    String? orderStatus =
        ActiveOrderService().getActiveOrderStatus(widget.order.id);
    bool pickupStatus = ClearanceDocService()
        .checkClearanceDocStatus(widget.order.id, ClearanceDocService.pickup);
    bool releaseStatus = ClearanceDocService()
        .checkClearanceDocStatus(widget.order.id, ClearanceDocService.release);
    if (!pickupStatus && widget.order.documentPickupPoint != null) {
      return ClearanceDocService.pickup;
    } else if (!releaseStatus &&
        widget.order.documentPickupPoint != null &&
        widget.order.documentReleasePoint != null &&
        orderStatus == ActiveOrderService.loadingEnd) {
      return ClearanceDocService.release;
    }
    return null;
  }
}
