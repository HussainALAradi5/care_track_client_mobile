/// Text of the accountant's screens: the books overview, the journal and the reports.
class AccountingTexts {
  const AccountingTexts._();

  static const navBooks = 'Books';
  static const navJournal = 'Journal';
  static const navReports = 'Reports';

  static const noOrganization = 'Your account has no organization-wide role yet.';
  static const noOrganizationHint = 'An administrator grants the accountant role for an organization.';
  static const lockedTitle = 'Not available for your role';
  static const lockedHint = 'Ask an administrator if you need this screen.';

  static const booksTitle = 'Books';
  static const booksSubtitle = 'How the month is going, next to the month before.';
  static const notSetUp = 'The books are not set up yet';
  static const notSetUpHint = 'Set them up on the web: it creates the chart of accounts and opens this year.';
  static const revenue = 'Revenue';
  static const expenses = 'Expenses';
  static const netResult = 'Net result';
  static const cashAndBank = 'Cash and bank';
  static const entriesPosted = 'Entries posted';
  static const drafts = 'Drafts waiting';
  static String versus(String month) => 'vs $month';
  static const topRevenue = 'Largest revenue';
  static const topExpenses = 'Largest expenses';
  static const nothingYet = 'Nothing posted this month yet.';

  static const journalTitle = 'Journal';
  static const journalSubtitle = 'Posted entries and drafts, newest first. Write and post them on the web.';
  static const journalEmpty = 'No journal entries yet.';
  static const allHospitals = 'Whole organization';
  static const debit = 'Debit';
  static const credit = 'Credit';
  static const draft = 'Draft';
  static const posted = 'Posted';
  static const reversed = 'Reversed';

  static const reportsTitle = 'Reports';
  static const reportsSubtitle = 'Statements from posted entries, up to today (income this year).';
  static const trialBalance = 'Trial balance';
  static const incomeStatement = 'Income statement';
  static const balanceSheet = 'Balance sheet';
}
