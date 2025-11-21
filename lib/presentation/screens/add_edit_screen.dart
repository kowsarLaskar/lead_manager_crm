import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lead_manager_crm/core/constants/app_color.dart';
import 'package:lead_manager_crm/service/providers/lead_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/lead_model.dart';
import '../../../core/utils/status_helper.dart';

class AddEditLeadScreen extends ConsumerStatefulWidget {
  final LeadModel? lead; // Null means Add mode

  const AddEditLeadScreen({super.key, this.lead});

  @override
  ConsumerState<AddEditLeadScreen> createState() => _AddEditLeadScreenState();
}

class _AddEditLeadScreenState extends ConsumerState<AddEditLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _contactCtrl;
  late TextEditingController _notesCtrl;
  LeadStatus _selectedStatus = LeadStatus.New;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.lead?.name ?? '');
    _contactCtrl = TextEditingController(text: widget.lead?.contact ?? '');
    _notesCtrl = TextEditingController(text: widget.lead?.notes ?? '');
    if (widget.lead != null) {
      _selectedStatus = StatusHelper.stringToStatus(widget.lead!.status);
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.lead != null;
      final lead = LeadModel(
        id: isEditing ? widget.lead!.id : const Uuid().v4(),
        name: _nameCtrl.text,
        contact: _contactCtrl.text,
        notes: _notesCtrl.text,
        status: _selectedStatus.name,
        createdAt: isEditing
            ? widget.lead!.createdAt
            : DateTime.now().toIso8601String(),
      );

      if (isEditing) {
        ref.read(leadProvider.notifier).updateLead(lead);
      } else {
        ref.read(leadProvider.notifier).addLead(lead);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lead == null ? 'Add Lead' : 'Edit Lead'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Lead Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactCtrl,
                decoration: const InputDecoration(
                  labelText: 'Contact (Phone/Email)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<LeadStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: LeadStatus.values.map((s) {
                  return DropdownMenuItem(value: s, child: Text(s.name));
                }).toList(),
                onChanged: (v) => setState(() => _selectedStatus = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _save,
                child: const Text('Save Lead'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
