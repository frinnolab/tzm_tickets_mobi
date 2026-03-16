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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFF2FA862);
      case 'pending':
        return const Color(0xFFE5BB31);
      case 'closed':
        return Colors.grey.shade600;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketId = widget.ticket['id']?.toString() ?? '?';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D364A),
        foregroundColor: Colors.white,
        title: const Text('Back', style: TextStyle(fontSize: 18)),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ticket Info Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ticket #TKT-$ticketId',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(_status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.ticket['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.ticket['description'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // AI Suggestion Output Card (if available/error)
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                if (!settings.enableAi) return const SizedBox.shrink();

                if (_isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (_suggestion != null || _errorMessage != null) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _errorMessage != null
                                  ? Icons.error
                                  : (_isMock == true
                                        ? Icons.warning_amber
                                        : Icons.auto_awesome),
                              color: _errorMessage != null
                                  ? Colors.red
                                  : (_isMock == true
                                        ? Colors.orange
                                        : const Color(0xFF1D6763)),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _errorMessage != null
                                  ? 'AI Request Failed'
                                  : (_isMock == true
                                        ? 'AI Mock Suggestion'
                                        : 'AI Suggested Resolution'),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _errorMessage != null
                                    ? Colors.red
                                    : (_isMock == true
                                          ? Colors.orange
                                          : const Color(0xFF1D6763)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage ?? _suggestion!,
                          style: TextStyle(
                            fontSize: 14,
                            color: _errorMessage != null
                                ? Colors.red
                                : Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Get AI Suggestion Button
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D6763),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _getSuggestion,
                    child: const Text(
                      'GET AI SUGGESTION',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Footer actions (View History, Close Ticket)
            Column(
              children: [
                // TextButton(
                //   onPressed: () {}, // Dummy action
                //   child: const Text(
                //     'View History',
                //     style: TextStyle(color: Colors.black87, fontSize: 14),
                //   ),
                // ),
                if (_status.toLowerCase() != 'closed')
                  _isClosing
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: _closeTicket,
                          child: const Text(
                            'Close Ticket',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
