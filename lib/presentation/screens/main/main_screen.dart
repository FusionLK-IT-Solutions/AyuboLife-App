import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/bloc/navigation/navigation_bloc.dart';
import 'package:ayubolife/bloc/navigation/navigation_event.dart';
import 'package:ayubolife/bloc/navigation/navigation_state.dart';
import 'package:ayubolife/presentation/screens/wellness/wellness_dashboard.dart';
import 'package:ayubolife/presentation/screens/discover/discover_page.dart';
import 'package:ayubolife/presentation/screens/inbox/inbox_page.dart';
import 'package:ayubolife/presentation/screens/more/more_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      WellnessDashboard(),
      DiscoverPage(),
      InboxPage(),
      MorePage(),
    ];

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: pages[state.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<NavigationBloc>().add(NavigationItemSelected(index: index));
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Me',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inbox),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
          ),
        );
      },
    );
  }
}