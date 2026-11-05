/// Text of the document screens: the patient's documents and the clinician's visits.
class DocumentTexts {
  const DocumentTexts._();

  static const navDocuments = 'Documents';
  static const navVisits = 'Visits';

  static const myDocumentsTitle = 'Documents';
  static const myDocumentsSubtitle = 'Reports, certificates and letters your care team issued.';
  static const myDocumentsEmpty = 'No documents yet.';
  static const myDocumentsEmptyHint = 'Documents your doctor or nurse issues after a visit appear here.';
  static String issuedBy(String name) => 'Issued by $name';

  static const visitsTitle = 'My visits';
  static const visitsSubtitle = 'Your visits here and the documents written for them. Write documents on the web.';
  static const visitsEmpty = 'No visits yet.';
  static const visitsEmptyHint = 'Visits booked with you at this hospital show here.';
  static const visitDocuments = 'Documents of this visit';
  static const noDocuments = 'No documents for this visit yet.';
  static const notArrived = 'Documents can be written once the patient has arrived.';

  static const kinds = {
    'MEDICAL_REPORT': 'Medical report',
    'ATTENDANCE_CERTIFICATE': 'Attendance certificate',
    'FITNESS_CERTIFICATE': 'Fitness certificate',
    'REFERRAL_NOTE': 'Referral note',
    'GENERAL_LETTER': 'Letter',
  };
}
