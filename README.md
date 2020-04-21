# flutter_adform
Adform plugin for Flutter.

# Installation

1. Dependencies
Add this to your package's pubspec.yaml file:

```dart
dependencies:
  flutter_adform: "^0.0.1"
```

2. You can install packages from the command line:

with Flutter:

```dart
$ flutter pub get
```

## Setup

### iOS
Add this to Info.plist
```
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>sms</string>
	<string>tel</string>
</array>
<key>io.flutter.embedded_views_preview</key>
<true/>
```

# Support

### Supported Platforms
- `0.0.1` >= iOS
- `0.0.1` >= AndroidX

### Supported Adform ads
- Inline Ads (SmartAdSize)
