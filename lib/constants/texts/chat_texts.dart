/// Text of the chat screens.
class ChatTexts {
  const ChatTexts._();

  static const title = 'Messages';
  static const empty = 'No conversations yet';
  static const emptyHint = 'Start one with someone at your hospital.';
  static const newConversation = 'New conversation';
  static const chooseHospital = 'Hospital';
  static const searchPeople = 'Search people';
  static const patientSupport = 'Message patient support';
  static const noContacts = 'Nobody you can reach yet';
  static const typing = 'is typing';
  static const attach = 'Attach a file';
  static const uploadFailed = 'Could not upload this file';
  static const removeUpload = 'Remove';
  static const edit = 'Edit';
  static const delete = 'Delete';
  static const historyTitle = 'Earlier versions';
  static const mute = 'Mute';
  static const unmute = 'Unmute';
  static const hide = 'Hide conversation';
  static const downloaded = 'File saved.';
  static const badgeFontSize = 11.0;
  static const noRecipients = 'Nobody in this conversation can receive messages now.';
  static const duplicateKey = 'This message could not be sent. Please write it again.';
  static const notAtHospital = 'You are not part of this hospital.';
  static const errors = {
    'CHAT_NO_ACTIVE_RECIPIENT': noRecipients,
    'CHAT_IDEMPOTENCY_CONFLICT': duplicateKey,
    'CHAT_NOT_AT_HOSPITAL': notAtHospital,
  };
  static const open = 'Open messages';
  static const composerHint = 'Write a message';
  static const send = 'Send';
  static const reply = 'Reply';
  static const replyingTo = 'Replying to';
  static const cancel = 'Cancel';
  static const sending = 'Sending...';
  static const notSent = 'Not sent';
  static const retry = 'Retry';
  static const deleted = 'This message was deleted';
  static const edited = 'edited';
  static const attachments = 'Attachment';
  static const loadOlder = 'Show earlier messages';
  static const loadFailed = 'Could not load this conversation.';
  static const delivered = 'Delivered';
  static const read = 'Read';
  static const sent = 'Sent';
  static const maxBadge = 99;
}
