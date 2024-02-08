import 'dart:convert';
import 'package:http/http.dart';

class Plausible {
  late Uri server;
  bool isActive;
  String domain;
  String? url;
  String? userAgent;
  String? xForwardedFor;

  Plausible({
    this.isActive = true,
    Uri? server,
    required this.domain,
    this.url,
    this.userAgent,
    this.xForwardedFor,
  }) {
    if (server != null) {
      this.server = server;
    } else {
      this.server = Uri.https('plausible.io', '/api/event');
    }
  }

  Future<void> send({
    String event = 'pageview',
    String page = '',
    String referrer = '',
    Map<String, dynamic>? props,
  }) async {
    if (!isActive) {
      print('Plausible.isActive is $isActive');
      return;
    }

    try {
      final headers = {'Content-Type': 'application/json'};
      if (userAgent != null) headers['User-Agent'] = userAgent!;
      if (xForwardedFor != null) headers['X-Forwarded-For'] = xForwardedFor!;

      final url = 'https://$domain/$page';
      final body = jsonEncode({
        'name': event,
        'domain': domain,
        'props': props,
        'url': url,
        'referrer': referrer
      });

      final response = await post(server, headers: headers, body: body);
      print(response.statusCode);
    } catch (error) {
      print('Error sending event: $error');
    }
  }
}
