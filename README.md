[![License: LGPL v3](https://img.shields.io/badge/License-LGPL_v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)
[![pub package](https://img.shields.io/pub/v/plausible.svg)](https://pub.dartlang.org/packages/plausible)

# dart-plausible
Simple package to send analytics to `plausible.io` or your `self-hosted` server
No unnecessary dependencies, package `http` only

## Features
- [x] pageview
- [x] goals / custom events
- [x] custom events with props
- [x] User-Agent
- [x] X-Forwarded-For
- [ ] referrer (You can contribute)
- [ ] revenue



## Getting started

```sh
flutter pub add plausible
# OR
  dart pub add plausible
```


## Usage

```dart
import 'package:plausible/plausible.dart';

void main() async {
  // Create your own domain using plausible dashboard
  const domain = 'ethicnology.com';

  // Instantiate the Plausible analytics object
  // Take a look at the multiples optionals settings
  final analytics = Plausible(domain: domain);

  // Send a `pageview` event of the page https://[domain]/about
  analytics.send(path: '/about');

  // Save the custom event `my-event` with the props key `anything` and the value `you want`
  // The goal/event `my-event` must be created before on your plausible dashboard
  analytics.send(event: 'my-event', props: {'anything': 'you want'});

  // Define a `User-Agent`: (Useful for CLI, Desktop and Mobiles)
  // Flutter web handle `User-Agent` by itself, and will override this configuration
  // On other platforms I recommand you to use `device_info_plus` package to collect the `userAgent`
  // https://pub.dev/packages/device_info_plus
  analytics.userAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36';

  // Send a `pageview` with the fake User-Agent
  analytics.send(path: '/about');

  // Disable analytics
  analytics.isActive = false;

  // Send a `pageview` will fail: `Plausible.isActive is set to false`
  analytics.send(path: '/about');
}

```
