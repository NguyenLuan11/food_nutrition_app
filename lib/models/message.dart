import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

class Message {
  String message;

  Message({required this.message});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(message: json['message']);
}
