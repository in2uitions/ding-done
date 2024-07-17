import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class Tabs extends StatefulWidget {
  Tabs({
    Key? key,
    required this.tabtitle,
    required this.tabContent,
    required this.content,
    this.initialIndex = 0, required String initialActiveTab,
  }) : super(key: key);

  final List<dynamic> tabtitle;
  final List<dynamic> tabContent;
  final int initialIndex;
  final Widget content;

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
                child: Align(
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
                    tabs: <Widget>[
                      ...widget.tabtitle.map(
                            (el) => Tab(
                          child: Text(
                            el,
                            style: getPrimaryRegularStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
