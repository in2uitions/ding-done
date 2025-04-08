import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class TabsJobs extends StatefulWidget {
  TabsJobs({
    Key? key,
    required this.tabtitle,
    required this.tabContent,
    required this.jobCounts,
    this.initialIndex = 0,
    required String initialActiveTab,
  }) : super(key: key);

  final List<String> tabtitle;
  final List<Widget> tabContent;
  final int initialIndex;
  final List<int> jobCounts;

  @override
  _TabsJobsState createState() => _TabsJobsState();
}

class _TabsJobsState extends State<TabsJobs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabtitle.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Updated custom-styled TabBar:
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xffEAEAFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            controller: _tabController,
            isScrollable: true,
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            // Custom indicator that fills the entire tab with a little padding.
            indicator: BoxDecoration(
              color: const Color(0xff4100E3),
              borderRadius: BorderRadius.circular(10),
            ),
            // Remove any default underline.
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            indicatorWeight: 0,
            labelStyle: getPrimaryBoldStyle(fontSize: 12),
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xff4100E3),
            tabs: List<Widget>.generate(
              widget.tabtitle.length,
              (index) => Tab(text: widget.tabtitle[index]),
            ),
          ),
        ),
        // Expanded TabBarView for the tab content.
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabContent,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
