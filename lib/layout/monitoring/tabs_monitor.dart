import 'package:flutter/material.dart';
import 'package:gest_app/layout/monitoring/detailgest_obstetra.dart';
import 'package:gest_app/layout/monitoring/monitor_exams/monitor_exams.dart';
import 'package:gest_app/layout/monitoring/monitor_goals/monitor_goals.dart';

class TabsMonitor extends StatefulWidget {
  final String gestId;
  const TabsMonitor({Key? key, required this.gestId}) : super(key: key);

  @override
  State<TabsMonitor> createState() => _TabsMonitorState();
}

class _TabsMonitorState extends State<TabsMonitor> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            title: const Text(""),
            bottom: TabBar(
                controller: tabController,
                tabs: const <Widget>[Tab(text: "Perfil"), Tab(text: "Exámenes"), Tab(text: "Metas de Act. Física")]),
          ),
        ],
        body: TabBarView(controller: tabController, children: [
          DetailMonitorGest(gestId: widget.gestId),
          MonitorExamPage(gestId: widget.gestId),
          MonitorGoalPage(gestId: widget.gestId)
        ]),
      ),
    );
  }
}
