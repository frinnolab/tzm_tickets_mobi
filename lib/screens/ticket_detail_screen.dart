import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../settings_provider.dart';

class TicketDetailScreen extends StatefulWidget {
  final Map<String, dynamic> ticket;
  const TicketDetailScreen({super.key, required this.ticket});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final ApiService _apiService = ApiService();
  String? _suggestion;
  String? _errorMessage;
  bool? _isMock;
  bool _isClosing = false;
  bool _isLoading = false;
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.ticket['status'] ?? 'open';
  }

  Future<void> _closeTicket() async {
    setState(() => _isClosing = true);
    try {
      await _apiService.closeTicket(widget.ticket['id']);
      setState(() => _status = 'closed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket closed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isClosing = false);
    }
  }

  Future<void> _getSuggestion() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final result = await _apiService.suggestResponse(widget.ticket['id']);
      setState(() {
        _suggestion = result['suggestion'];
        _errorMessage = result['error_message'];
        _isMock = result['is_mock'] == true;
      });
    } catch (e) {
      if (mounted) {
        setState(
          () => _errorMessage = e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.ticket['title'] ?? 'Ticket Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: $_status',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (_status.toLowerCase() != 'closed')
                    _isClosing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : TextButton.icon(
                            onPressed: _closeTicket,
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text(
                              'Close Ticket',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.ticket['description'] ?? ''),

              Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  if (!settings.enableAi) {
                    return const SizedBox.shrink(); // Hide the AI UI completely
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 32),
                      const Text(
                        'AI Suggestion Module',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (_suggestion != null || _errorMessage != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_errorMessage != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withAlpha(25),
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_suggestion != null)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _isMock == true
                                      ? Colors.orange.withAlpha(25)
                                      : Colors.green.withAlpha(25),
                                  border: Border.all(
                                    color: _isMock == true
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _isMock == true
                                              ? Icons.warning_amber
                                              : Icons.check_circle,
                                          color: _isMock == true
                                              ? Colors.orange
                                              : Colors.green,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _isMock == true
                                                ? 'Mock Fallback Suggestion'
                                                : 'AI Suggestion',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _isMock == true
                                                  ? Colors.orange.shade800
                                                  : Colors.green.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _suggestion!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        )
                      else
                        ElevatedButton.icon(
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Get AI Suggestion'),
                          onPressed: _getSuggestion,
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
