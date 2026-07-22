import 'package:flutter/material.dart';

/// Placeholder — Relationship History (People I Met).
///
/// Not yet implemented. Will be designed after Sprint 7 (Event Intelligence)
/// provides meaningful context for every connection: who was met, where,
/// when, and why. A list of names is not enough.
///
/// Renamed from "Connections" to "Relationship History" per FD-020:
/// "Relationships are always between people. Organizations provide identity,
/// trust, and continuity."
///
/// See: ROADMAP.md — Sprint 7+ (Relationship History)
class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('People I Met')),
      body: const Center(
        child: Text(
          'Coming after Sprint 7',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
