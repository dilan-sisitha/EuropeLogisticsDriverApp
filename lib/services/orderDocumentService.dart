import 'package:euex/api/api.dart';
import 'package:euex/api/responseFormatter.dart';
import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/helpers/httpClient.dart';
import 'package:euex/models/document.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderDocumentService {
  var orderDocsBox = Hive.box('order_documents');
  HttpClient httpClient = HttpClient();

  String fileNameFromUrl(url) {
    var pos = url.lastIndexOf('/');
    String result = (pos != -1) ? url.substring(pos + 1, url.length) : url;
    return result;
  }

  retrieveAllOrderDocs() async {
    var response = await Api().getDocuments();
    if (response is HttpResponse && response.statusCode == 200) {
      try {
        if (response.data is List) {
          var orderDocumentsList = List.from(response.data);
          if (orderDocumentsList.isNotEmpty) {
            for (var orderDocuments in orderDocumentsList) {
              var documentList = List.from(orderDocuments['documents']);
              if (documentList.isNotEmpty) {
                String orderId = orderDocuments['order_id'].toString();
                List<dynamic>? existingOrderList =
                    getOrderDocumentList(orderId);
                List docList = await addSavedDocumentsToList(
                    documentList, orderId, existingOrderList);
                if (docList.isNotEmpty && docList is List<dynamic>) {
                  orderDocsBox.put(orderId, docList);
                }
              }
            }
          }
        }
      } catch (e, stackTrace) {
        debugPrint(stackTrace.toString());
      }
    }
  }

  retrieveSingleOrderDocs(orderId) async {
    var response = await Api().getDocuments();
    if (response is HttpResponse && response.statusCode == 200) {
      try {
        if (response.data is List) {
          var orderDocumentsList = List.from(response.data);
          if (orderDocumentsList.isNotEmpty) {
            for (var orderDocuments in orderDocumentsList) {
              var documentList = List.from(orderDocuments['documents']);
              if (documentList.isNotEmpty &&
                  orderDocuments['order_id'] == orderId) {
                String orderId = orderDocuments['order_id'].toString();
                List<dynamic>? existingOrderList =
                    getOrderDocumentList(orderId);
                List docList = await addSavedDocumentsToList(
                    documentList, orderId, existingOrderList);
                if (docList.isNotEmpty && docList is List<dynamic>) {
                  orderDocsBox.put(orderId, docList);
                }
              }
            }
          }
        }
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    }
  }

  getOrderDocumentList(orderId) {
    List<dynamic> existingDocs = [];
    if (orderDocsBox.containsKey(orderId)) {
      existingDocs = orderDocsBox.get(orderId);
    }
    return existingDocs;
  }

  saveDocument(document, orderId) async {
    String fileName = fileNameFromUrl(document['document']);
    var path = await FileHandler().savePath('docs', fileName);
    var response = await httpClient.download(document['document'], path,
        authenticated: true);
    if (response.statusCode == 200) {
      return Document(
          id: document['id'],
          name: document['name'],
          path: path,
          orderId: int.parse(orderId),
          updatedAt: document['updated_at']);
    }
    return null;
  }

  deleteDocumentDirectory(dirPath) async {
    await FileHandler().deleteDirectory(dirPath);
  }

  Future<Map> checkDocumentUpdate(orderId, document) async {
    bool update = false;
    bool create = true;
    if (orderDocsBox.containsKey(orderId)) {
      List<dynamic> orderDocList =
          await Hive.box('order_documents').get(orderId);
      Iterable<dynamic>? existingDocs =
          orderDocList.where((item) => item.id == document['id']);
      if (existingDocs.isNotEmpty) {
        create = false;
        Document doc = existingDocs.first;
        if (doc.updatedAt != document['updated_at']) {
          update = true;
        }
      }
    }
    return {'create': create, 'update': update};
  }

  Future<List> addSavedDocumentsToList(documents, orderId, docList) async {
    try {
      for (var document in documents) {
        var updateOrCreate = await checkDocumentUpdate(orderId, document);
        if (updateOrCreate['create'] || updateOrCreate['update']) {
          if (updateOrCreate['update']) {
            docList.removeWhere((item) => item.id == document['id']);
          }
          var doc = await saveDocument(document, orderId);
          if (doc is Document) {
            docList.add(doc);
          }
        }
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
    return docList;
  }
}
