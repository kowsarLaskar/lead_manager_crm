import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/lead_model.dart';
import '../../data/repositories/lead_repository.dart';
import 'filter_provider.dart';

final leadRepositoryProvider = Provider((ref) => LeadRepository());

class LeadNotifier extends StateNotifier<List<LeadModel>> {
  final LeadRepository _repository;

  LeadNotifier(this._repository) : super([]) {
    loadLeads();
  }

  Future<void> loadLeads() async {
    List<LeadModel> currentLeads = await _repository.getAllLeads();

    // ✦ NEW: Seed dummy data if DB is empty
    if (currentLeads.isEmpty) {
      await _seedDummyData();
      currentLeads = await _repository.getAllLeads();
    }

    state = currentLeads;
  }

  Future<void> _seedDummyData() async {
    final dummyLeads = [
      LeadModel(
        id: const Uuid().v4(),
        name: "Sarah Jenkins",
        contact: "+1 (555) 019-2834",
        notes: "Interested in the premium plan. Call back on Monday.",
        status: "New",
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
      ),
      LeadModel(
        id: const Uuid().v4(),
        name: "TechCorp Solutions",
        contact: "info@techcorp.com",
        notes: "Need a custom quote for 50 users.",
        status: "Contacted",
        createdAt: DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      ),
      LeadModel(
        id: const Uuid().v4(),
        name: "Michael Ross",
        contact: "m.ross@pearson.net",
        notes: "Signed the contract yesterday. Onboarding needed.",
        status: "Converted",
        createdAt: DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
      ),
      LeadModel(
        id: const Uuid().v4(),
        name: "David Miller",
        contact: "d.miller@example.com",
        notes: "Budget constraints. Revisit in Q4.",
        status: "Lost",
        createdAt: DateTime.now()
            .subtract(const Duration(days: 5))
            .toIso8601String(),
      ),
      LeadModel(
        id: const Uuid().v4(),
        name: "Emily Clark",
        contact: "+1 (555) 999-1122",
        notes: "Met at the conference. Sends regards.",
        status: "New",
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 30))
            .toIso8601String(),
      ),
    ];

    for (var lead in dummyLeads) {
      await _repository.insertLead(lead);
    }
  }

  Future<void> addLead(LeadModel lead) async {
    await _repository.insertLead(lead);
    await loadLeads();
  }

  Future<void> updateLead(LeadModel lead) async {
    await _repository.updateLead(lead);
    await loadLeads();
  }

  Future<void> deleteLead(String id) async {
    await _repository.deleteLead(id);
    await loadLeads();
  }
}

final leadProvider = StateNotifierProvider<LeadNotifier, List<LeadModel>>((
  ref,
) {
  return LeadNotifier(ref.watch(leadRepositoryProvider));
});

// Computed Provider for Filtering (Status + Search)
final filteredLeadsProvider = Provider<List<LeadModel>>((ref) {
  final allLeads = ref.watch(leadProvider);
  final filterStatus = ref.watch(filterProvider);
  final searchQuery = ref
      .watch(searchQueryProvider)
      .toLowerCase(); // Watch search query

  return allLeads.where((lead) {
    // 1. Check Status Match (if filter is null, it matches everything)
    final matchesStatus =
        (filterStatus == null) ||
        (lead.status.toLowerCase() == filterStatus.toLowerCase());

    // 2. Check Name Match (Search)
    final matchesSearch =
        lead.name.toLowerCase().contains(searchQuery) ||
        lead.contact.toLowerCase().contains(searchQuery);

    return matchesStatus && matchesSearch;
  }).toList();
});
