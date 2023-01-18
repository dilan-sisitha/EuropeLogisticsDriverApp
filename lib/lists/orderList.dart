class Orders {
  final String drivername,
      driverImage,
      driverContact,
      vanImage,
      vanType,
      vanMake,
      vanreg,
      loadingTime,
      unloadingTime,
      amountLoading,
      amountUnloading;

  final String orderID,
      size,
      collectionDate,
      collectionTime,
      pickupLocation,
      deliveryLocation,
      driverHelp,
      doc;
  final bool corporateOrder, completed, processing;

  Orders({
    required this.processing,
    required this.completed,
    required this.orderID,
    required this.size,
    required this.collectionDate,
    required this.collectionTime,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.driverHelp,
    required this.corporateOrder,
    required this.driverImage,
    required this.drivername,
    required this.driverContact,
    required this.vanImage,
    required this.vanType,
    required this.vanMake,
    required this.vanreg,
    required this.loadingTime,
    required this.unloadingTime,
    required this.amountLoading,
    required this.doc,
    required this.amountUnloading,
  });
}

List<Orders> orders = [
  Orders(
      orderID: "E1321313213",
      size: "10m3 (up to 600Kg)",
      collectionDate: "25/03/2022",
      collectionTime: "02:02:00",
      pickupLocation: "45645 Beehive lane,\nilford\n132ER,\nUnited kingdom",
      deliveryLocation: " Hive lane,\ncroydon,\n78931ER, \nUnited kingdom",
      driverHelp: "Driver help is requested",
      corporateOrder: true,
      drivername: "Sam Doe",
      driverImage: "asset/images/man.png",
      driverContact: "45644565455",
      vanImage: "asset/images/van.jpg",
      vanType: "Luton van",
      vanMake: "Mercedes-Benz Sprinter",
      vanreg: "ER - 5655",
      completed: false,
      processing: true,
      loadingTime: "00:30",
      unloadingTime: "00:40",
      amountLoading: "€ 10",
      amountUnloading: "€ 20",
      doc:
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"),
  Orders(
      orderID: "V1321313213",
      size: "15m3 (up to 1000Kg)",
      collectionDate: "25/03/2022",
      collectionTime: "04:05:00",
      pickupLocation: "645 op lane,\nBromley\n12ER,\nUnited kingdom",
      deliveryLocation: " Queen lane,\nKingston,\n9931ER,\nUnited kingdom",
      driverHelp: "Driver help is requested",
      corporateOrder: false,
      drivername: "",
      driverImage: "",
      driverContact: "",
      vanImage: "",
      vanType: "",
      vanMake: "",
      vanreg: "",
      completed: false,
      processing: false,
      loadingTime: "00:20",
      unloadingTime: "00:20",
      amountLoading: "€ 15",
      amountUnloading: "€ 30",
      doc: "http://www.africau.edu/images/default/sample.pdf"),
  Orders(
      orderID: "J5321313213",
      size: "5m3 (up to 300Kg)",
      collectionDate: "25/03/2022",
      collectionTime: "08:20:00",
      pickupLocation: "85 King's lane,\nBromley\n12ER,\nUnited kingdom",
      deliveryLocation: "James lane,\nKingston,\n9931ER,\nUnited kingdom",
      driverHelp: "Driver help is requested",
      corporateOrder: false,
      drivername: "",
      driverImage: "",
      driverContact: "",
      vanImage: "",
      vanType: "",
      vanMake: "",
      vanreg: "",
      completed: false,
      processing: false,
      loadingTime: "00:10",
      unloadingTime: "00:20",
      amountLoading: "€ 50",
      amountUnloading: "€ 30",
      doc: "http://www.africau.edu/images/default/sample.pdf")
];
