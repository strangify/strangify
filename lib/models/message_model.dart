class MessageModel {
  final String senderId;
  final String message;
  final DateTime time;

  MessageModel(
      {required this.message, required this.senderId, required this.time});
}
