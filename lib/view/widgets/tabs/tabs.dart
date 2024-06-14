import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class Tabs extends StatefulWidget {
  Tabs({
    Key? key,
    required this.tabtitle,
    required this.tabContent,
    required this.content,
    this.initialIndex = 0,
  }) : super(key: key);
  List<dynamic> tabtitle;
  List<dynamic> tabContent;
  int initialIndex;
  final content;
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  // ScrollController _scrollController = ScrollController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabtitle.length,
      vsync: this,
    );
    scrollToTab();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // initialIndex: widget.initialIndex,
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
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  // labelColor: context.resources.color.btnColorBlue,
                  labelStyle: getPrimaryBoldStyle(
                    fontSize: 20,
                    color: context.resources.color.btnColorBlue,
                  ),
                  unselectedLabelColor: const Color(0xffBEC2CE),
                  indicatorColor: const Color(0xffF3D347),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  isScrollable: true,
                  labelPadding: EdgeInsets.only(
                    left: context.appValues.appPadding.p15,
                    top: context.appValues.appPadding.p15,
                    right: context.appValues.appPadding.p15,
                  ),
                  tabs: <Widget>[
                    ...widget.tabtitle
                        .map(
                          (el) => Tab(
                            // text: el,
                            child: Text(
                              el,
                              style: getPrimaryRegularStyle(fontSize: 17),
                            ),
                          ),
                        )
                        .toList(),
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
    );
  }

  void scrollToTab() {
    // final index = widget.tabtitle.indexOf(tabtitle);
    // if (index != -1) {
    _tabController.animateTo(widget.initialIndex);
    // }
  }
}
