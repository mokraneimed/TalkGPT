class Email {
  String? subject;
  String? senderEmail;
  String? senderName;
  String? message;
  String? inReplyTo;
  String? messageID;
  String? refrences;
  String? threadId;
  String? photoUrl;
  int? profileColor;
  DateTime? date;

  Email(
      {this.subject,
      this.senderEmail,
      this.senderName,
      this.message,
      this.inReplyTo,
      this.messageID,
      this.refrences,
      this.threadId,
      this.photoUrl,
      this.profileColor,
      this.date});
}
