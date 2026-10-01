import 'package:flutter/material.dart';

/// Global navigator key for accessing navigation context from anywhere in the app
/// Used primarily for push notification navigation when the app is in background/terminated state
final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
