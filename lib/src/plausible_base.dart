import 'dart:convert';
import 'package:http/http.dart';

/// Main class to deal with plausible analytics
class Plausible {
  /// Analytics server to communicate with. default: plausible.io/api/event
  /// Modify this value if you self-host plausible analytics. example: self.hosted/api/event
  late Uri server;

  /// Activate the analytics or Deactivate them in dev mode
  bool isActive;

  /// a.k.a. data-domain refer to your plausible project
  String domain;

  /// The base url of the page viewed listed in the category `Top Pages`
  /// Counted if the event sent is set to "pageview"
  /// default: https://{domain}/{path} | [Uri.https(domain, path)]
  Uri? url;

  /// User-Agent is a http header used by plausible to improve their hability to distinguish a user from another
  /// This has not to be set if you use flutter web (the browser will handle it)
  String? userAgent;

  /// X-Forwarded-For is a http header used by plausible to improve their hability to distinguish a user from another
  /// This has not to be set if you use flutter web (the browser will handle it)
  /// It should match the user public IP
  String? xForwardedFor;

  /// Default constructor
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

  /// Send an event to plausible analytics server.
  /// defaults:
  /// - event   : pageview
  /// - path    : https://{domain}/{path}
  /// - props   : null
  Future<void> send({
    String event = 'pageview',
    String path = '/',
    Map<String, dynamic>? props,
  }) async {
    if (!isActive) {
      print('Plausible.isActive is set to $isActive');
      return;
    }

    try {
      final headers = {'Content-Type': 'application/json'};
      if (userAgent != null) headers['User-Agent'] = userAgent!;
      if (xForwardedFor != null) headers['X-Forwarded-For'] = xForwardedFor!;

      final resolved = url ?? Uri.https(domain, path);
      final basePath = resolved.path.isNotEmpty ? resolved.path : '/';
      final eventUrl =
          resolved.hasQuery ? '$basePath?${resolved.query}' : basePath;

      final body = jsonEncode({
        'name': event,
        'domain': domain,
        'props': props,
        'url': eventUrl,
      });

      await post(server, headers: headers, body: body);
    } catch (error) {
      throw Exception('Error sending event: $error');
    }
  }
}
