import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class Tabs extends StatefulWidget {
  Tabs({
    Key? key,
    required this.tabtitle,
    required this.tabContent,
    required this.content,
    required this.jobCounts,
    this.initialIndex = 0, required String initialActiveTab,
  }) : super(key: key);

  final List<dynamic> tabtitle;
  final List<dynamic> tabContent;
  final int initialIndex;
  final Widget content;
  final List<int> jobCounts; // List of job counts

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      body: DefaultTabController(
        length: widget.tabtitle.length,
        child: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: widget.content,
              ),
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: TabBar(
                        tabAlignment:TabAlignment.start,
                        controller: _tabController,
                        labelStyle: getPrimaryBoldStyle(
                          fontSize: 20,
                          color: context.resources.color.btnColorBlue,
                        ),
                        unselectedLabelColor: const Color(0xffBEC2CE),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffF3D347), // Yellow color
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight:3,
                        isScrollable: true,
                        labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        tabs: List<Widget>.generate(widget.tabtitle.length, (index) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0), // Add padding to avoid overlay
                                child: Tab(
                                  child: Text(
                                    widget.tabtitle[index],
                                    style: getPrimaryRegularStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                              if (widget.jobCounts[index] > 0) // Only show badge if job count is greater than 0
                                Positioned(
                                  right: -18,
                                  top: -5,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 24,
                                      minHeight: 24,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${widget.jobCounts[index]}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ...widget.tabContent.map((e) => e).toList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
