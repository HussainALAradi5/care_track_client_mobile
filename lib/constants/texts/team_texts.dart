/// Text of My team and My department.
class TeamTexts {
  const TeamTexts._();

  static const navTeam = 'Team';
  static const teamTitle = 'My team';
  static const teamSubtitle = 'The people who report to you, and the people who report to them.';
  static const teamEmpty = 'No one reports to you';
  static const teamEmptyHint = "When you manage a department, or HR sets you as someone's manager, your team shows here.";
  static String reports(int count) => count == 1 ? '1 report' : '$count reports';

  static const navDepartment = 'Department';
  static const departmentTitle = 'My department';
  static const departmentSubtitle = 'Your colleagues in the departments you work in, and the departments under them.';
  static const departmentEmpty = 'Not linked to a department';
  static const departmentEmptyHint = 'HR links you to a position in a department; your colleagues then show here.';
  static String people(int count) => count == 1 ? '1 person' : '$count people';
  static const you = 'You';
  static const main = 'Main';
  static const noOne = 'No one here yet.';
}
