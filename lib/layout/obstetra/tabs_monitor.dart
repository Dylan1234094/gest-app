import 'package:flutter/material.dart';
import 'package:gest_app/layout/obstetra/detailgest_obstetra.dart';
import 'package:gest_app/layout/obstetra/monitor_exams/monitor_exams.dart';
import 'package:gest_app/layout/obstetra/monitor_goals/monitor_goals.dart';

class TabsMonitor extends StatefulWidget {
  final String gestId;
  const TabsMonitor({required this.gestId});

  static String id = '/tabsObstetra';

  @override
  State<TabsMonitor> createState() => _TabsMonitorState();
}

class _TabsMonitorState extends State<TabsMonitor>
    with TickerProviderStateMixin {
  late TabController tabController;

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'PERFIL'),
    Tab(text: 'EXAMENES'),
    Tab(text: 'METAS DE ACT.'),
  ];

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
      length: tabs.length,
      initialIndex: 0,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            bottom: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 5),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontSize: 10),
              indicatorColor: Colors.white,
              controller: tabController,
              tabs: tabs,
            ),
          ),
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            PerfilGest(gestId: widget.gestId),
            ListaExamenes(gestId: widget.gestId),
            ListaMetas(gestId: widget.gestId)
          ],
        ),
      ),
    );
  }
}
