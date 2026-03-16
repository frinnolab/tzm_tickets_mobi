import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'ticket_detail_screen.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    setState(() => _isLoading = true);
    try {
      final tickets = await _apiService.fetchTickets();
      setState(() => _tickets = tickets);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tickets.isEmpty
          ? const Center(child: Text('No tickets found. Create one!'))
          : RefreshIndicator(
              onRefresh: _fetchTickets,
              child: ListView.builder(
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  final title = _tickets[index]['title'] ?? 'No Title';
                  final status = _tickets[index]['status'] ?? 'Open';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: status.toLowerCase() == 'open'
                          ? Colors.green
                          : Colors.grey,
                      child: const Icon(Icons.receipt, color: Colors.white),
                    ),
                    title: Text(title),
                    subtitle: Text('Status: $status'),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TicketDetailScreen(ticket: _tickets[index]),
                        ),
                      );
                      _fetchTickets(); // Refresh on return
                    },
                  );
                },
              ),
            ),
    );
  }
}
