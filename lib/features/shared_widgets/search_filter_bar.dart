import 'package:flutter/material.dart';

class SearchAndFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> sections;
  final String selectedSection;
  final Function(String) onSectionChanged;

  const SearchAndFilterBar({
    super.key,
    required this.searchController,
    required this.sections,
    required this.selectedSection,
    required this.onSectionChanged,
  });

  void _showSectionFilter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: sections.map((section) {
            return ListTile(
              title: Text(
                section.toUpperCase(),
                style: TextStyle(
                  fontWeight: selectedSection == section ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: selectedSection == section ? Icon(Icons.check, color: colorScheme.primary) : null,
              onTap: () {
                Navigator.pop(context);
                onSectionChanged(section);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: Icon(Icons.search, color: colorScheme.onBackground),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: () => _showSectionFilter(context),
            icon: Icon(Icons.filter_alt, color: colorScheme.onBackground),
            label: const Text('Filter'),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}