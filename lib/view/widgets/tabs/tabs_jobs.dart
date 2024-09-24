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

  final List<String> tabtitle; // Specify type as List<String>
  final List<Widget> tabContent; // Specify type as List<Widget>
  final int initialIndex;
  final List<int> jobCounts; // List of job counts

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
        // TabBar (scrollable)
        TabBar(
          tabAlignment: TabAlignment.start,
          controller: _tabController,
          labelStyle: getPrimaryBoldStyle(
            fontSize: 20,
            color: context.resources.color.btnColorBlue,
          ),
          unselectedLabelColor: const Color(0xffBEC2CE),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
          isScrollable: true, // Allow the TabBar to scroll
          labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          tabs: List<Widget>.generate(widget.tabtitle.length, (index) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Tab(
                    child: Text(
                      widget.tabtitle[index],
                      style: getPrimaryBoldStyle(
                        fontSize: 18,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ),
                ),
                if (widget.jobCounts[index] > 0)
                  Positioned(
                    right: -18,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.jobCounts[index]}',
                          style: const TextStyle(
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
        // Expanded TabBarView to be inside the DraggableScrollableSheet
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget
                .tabContent, // Each tab content should already be a scrollable widget
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

// import 'package:flutter/material.dart';
// import 'package:dingdone/res/app_context_extension.dart';
// import 'package:dingdone/res/fonts/styles_manager.dart';

// class TabsJobs extends StatefulWidget {
//   final List<String> tabtitle; // Changed to List<String> for clarity
//   final List<Widget> tabContent; // Ensure this is a list of widgets
//   // final Widget content; // This is the widget to display above the tabs
//   final int initialIndex;
//   final Function(int) onTabSelected;

//   const TabsJobs({
//     Key? key,
//     required this.tabtitle,
//     required this.tabContent,
//     // required this.content,
//     this.initialIndex = 0,
//     required this.onTabSelected,
//   }) : super(key: key);

//   @override
//   _TabsJobsState createState() => _TabsJobsState();
// }

// class _TabsJobsState extends State<TabsJobs>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//       length: widget.tabtitle.length,
//       vsync: this,
//       initialIndex: widget.initialIndex,
//     );

//     _tabController.addListener(() {
//       if (!_tabController.indexIsChanging) {
//         widget.onTabSelected(_tabController.index);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return NestedScrollView(
//       physics: const NeverScrollableScrollPhysics(),
//       headerSliverBuilder: (context, value) {
//         return [
//           // SliverToBoxAdapter(
//           //   child: widget.content,
//           // ),
//           SliverToBoxAdapter(
//             child: Align(
//               alignment: Alignment.center,
//               child: TabBar(
//                 tabAlignment: TabAlignment.start,
//                 controller: _tabController,
//                 labelColor: context.resources.color.btnColorBlue,
//                 unselectedLabelColor: const Color(0xffBEC2CE),
//                 indicatorColor: context.resources.color.btnColorBlue,
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 indicatorWeight: 3,
//                 isScrollable: true,
//                 labelPadding: EdgeInsets.only(
//                   left: context.appValues.appPadding.p15,
//                   top: context.appValues.appPadding.p15,
//                   right: context.appValues.appPadding.p15,
//                 ),
//                 tabs: widget.tabtitle.map((title) {
//                   return Tab(
//                     child: Text(
//                       title,
//                       style: getPrimaryRegularStyle(fontSize: 17),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           )
//         ];
//       },
//       body: TabBarView(
//         controller: _tabController,
//         children: widget.tabContent,
//       ),
//     );
//   }
// }
