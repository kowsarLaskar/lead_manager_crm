import 'package:lead_manager_crm/data/db/app_database.dart';
import '../models/lead_model.dart';

class LeadRepository {
  final AppDatabase _appDatabase = AppDatabase.instance;

  Future<void> insertLead(LeadModel lead) async {
    final db = await _appDatabase.database;
    await db.insert('leads', lead.toMap());
  }

  Future<List<LeadModel>> getAllLeads() async {
    final db = await _appDatabase.database;
    final result = await db.query('leads', orderBy: 'createdAt DESC');
    return result.map((json) => LeadModel.fromMap(json)).toList();
  }

  Future<void> updateLead(LeadModel lead) async {
    final db = await _appDatabase.database;
    await db.update(
      'leads',
      lead.toMap(),
      where: 'id = ?',
      whereArgs: [lead.id],
    );
  }

  Future<void> deleteLead(String id) async {
    final db = await _appDatabase.database;
    await db.delete('leads', where: 'id = ?', whereArgs: [id]);
  }
}
