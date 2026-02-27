import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/app_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final dash = context.watch<DashboardProvider>();

    return Scaffold(
      body: Row(
        children: [
          const SidebarWidget(currentRoute: '/dashboard'),
          Expanded(
            child: Column(
              children: [
                // ── Top Bar ──────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back, ${auth.userName}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(auth.user?['facility']?['name'] ?? '',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () => context.go('/notifications'),
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        backgroundColor: AppTheme.primaryGreen,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // ── Body ─────────────────────────────────
                Expanded(
                  child: dash.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : dash.stats == null
                          ? const Center(child: Text('No data available'))
                          : _buildBody(dash.stats!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // ── Stat Cards ──────────────────────────────
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: [
              StatCardWidget(
                title: 'Total Patients',
                value: '${stats['total_patients'] ?? 0}',
                icon: Icons.people,
                color: AppTheme.primaryGreen,
                onTap: () => context.go('/patients'),
              ),
              StatCardWidget(
                title: "Today's Visits",
                value: '${stats['today_visits'] ?? 0}',
                icon: Icons.calendar_today,
                color: AppTheme.primaryBlue,
                onTap: () => context.go('/health-records'),
              ),
              StatCardWidget(
                title: 'Pending Referrals',
                value: '${stats['pending_referrals'] ?? 0}',
                icon: Icons.transfer_within_a_station,
                color: AppTheme.warningAmber,
                onTap: () => context.go('/referrals'),
              ),
              StatCardWidget(
                title: 'Incoming Referrals',
                value: '${stats['incoming_referrals'] ?? 0}',
                icon: Icons.arrow_downward,
                color: AppTheme.accentOrange,
                onTap: () => context.go('/referrals'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Charts ──────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Patient Registrations (Last 6 Months)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: _buildLineChart(
                            List<Map<String, dynamic>>.from(
                                stats['monthly_patients'] ?? []),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Referral Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: _buildPieChart(
                            Map<String, dynamic>.from(
                                stats['referral_stats'] ?? {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Recent Referrals ─────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Referrals',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      TextButton(
                        onPressed: () => context.go('/referrals'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRecentReferralsTable(
                    List<Map<String, dynamic>>.from(
                        stats['recent_referrals'] ?? []),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return const Center(
          child: Text('No data', style: TextStyle(color: Colors.grey)));
    }
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return LineChart(LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 35)),
        rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (val, meta) {
              final i = val.toInt();
              if (i < 0 || i >= data.length) return const SizedBox();
              final m = ((data[i]['month'] ?? 1) as int) - 1;
              return Text(months[m.clamp(0, 11)],
                  style: const TextStyle(fontSize: 10));
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: data.asMap().entries.map((e) => FlSpot(
                e.key.toDouble(),
                ((e.value['total'] ?? 0) as num).toDouble(),
              )).toList(),
          isCurved: true,
          color: AppTheme.primaryGreen,
          barWidth: 3,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.primaryGreen.withOpacity(0.1),
          ),
        ),
      ],
    ));
  }

  Widget _buildPieChart(Map<String, dynamic> data) {
    final colors = <String, Color>{
      'pending':   AppTheme.warningAmber,
      'accepted':  AppTheme.primaryBlue,
      'completed': AppTheme.successGreen,
      'rejected':  AppTheme.errorRed,
      'arrived':   AppTheme.primaryGreen,
    };
    final sections = data.entries.map((e) => PieChartSectionData(
          color: colors[e.key] ?? Colors.grey,
          value: ((e.value ?? 0) as num).toDouble(),
          title: '${e.value}',
          radius: 70,
          titleStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        )).toList();

    if (sections.isEmpty) {
      return const Center(
          child: Text('No referral data',
              style: TextStyle(color: Colors.grey)));
    }
    return PieChart(PieChartData(sections: sections, sectionsSpace: 2));
  }

  Widget _buildRecentReferralsTable(List<Map<String, dynamic>> referrals) {
    if (referrals.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
            child: Text('No recent referrals',
                style: TextStyle(color: Colors.grey))),
      );
    }
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: ['Referral #', 'Patient', 'Facility', 'Priority', 'Status']
              .map((h) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(h,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ))
              .toList(),
        ),
        ...referrals.map((r) {
          final patient = (r['patient'] as Map?) ?? {};
          return TableRow(children: [
            _cell(r['referral_number'] ?? '-'),
            _cell('${patient['first_name'] ?? ''} ${patient['last_name'] ?? ''}'),
            _cell(r['receiving_facility']?['name'] ?? '-'),
            _chip(r['priority'] ?? 'routine'),
            _chip(r['status'] ?? 'pending'),
          ]);
        }),
      ],
    );
  }

  Widget _cell(String text) => Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      );

  Widget _chip(String label) => Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.statusColor(label).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppTheme.statusColor(label)),
          ),
        ),
      );
}