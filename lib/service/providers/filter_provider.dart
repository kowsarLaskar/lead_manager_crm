import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Stores "New", "Contacted", etc. or NULL for "All"
final filterProvider = StateProvider<String?>((ref) => null);

// ✦ NEW: Stores the current search text
final searchQueryProvider = StateProvider<String>((ref) => '');
