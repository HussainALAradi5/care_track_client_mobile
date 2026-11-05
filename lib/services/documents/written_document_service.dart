import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/documents/written_document.dart';
import '../api/api_client.dart';

/// Reading documents: the patient's own, and a visit's for its clinician. Writing happens on the web.
class WrittenDocumentService {
  WrittenDocumentService(this._api);

  final ApiClient _api;

  Future<PageResult<WrittenDocument>> mine(PageRequest request) async =>
      PageResult.fromJson(await _api.get(Endpoints.myDocuments, query: request.toQuery()), WrittenDocument.fromJson);

  Future<WrittenDocument> mineById(String documentId) async =>
      WrittenDocument.fromJson(await _api.get(Endpoints.myDocument(documentId)));

  Future<PageResult<WrittenDocument>> forVisit(String hospitalId, String appointmentId, PageRequest request) async =>
      PageResult.fromJson(
        await _api.get(Endpoints.visitDocuments(hospitalId, appointmentId), query: request.toQuery()),
        WrittenDocument.fromJson,
      );

  Future<WrittenDocument> getForVisit(String hospitalId, String appointmentId, String documentId) async =>
      WrittenDocument.fromJson(await _api.get(Endpoints.visitDocument(hospitalId, appointmentId, documentId)));
}
