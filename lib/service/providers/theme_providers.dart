import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Manages the Light/Dark state
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
