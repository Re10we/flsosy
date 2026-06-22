import 'dart:ui';

import 'package:flsosy/pages/home/bloc/coin_market_bloc.dart';
import 'package:flsosy/pages/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flsosy/pages/favorites/favorites_page.dart';

import '../../extensions/context_extensions.dart';
import '../../generated/assets.dart';
import 'package:flsosy/pages/chat/chat_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _selectedIndex = ValueNotifier<int>(0);
  final _isBotOpen = ValueNotifier<bool>(false);

  final _pages = [
    BlocProvider(
      create: (_) => CoinMarketBloc(),
      child: const HomePage(),
    ),
    const FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        endDrawer: Drawer(
          child: const ChatPage(),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          forceMaterialTransparency: true,
          titleSpacing: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 24.0,
                sigmaY: 24.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.accentHeaderGreen.withValues(
                    alpha: 0.80,
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: context.colors.borderGreen,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 16.0,
            ),
            child: SvgPicture.asset(
              Assets.ic_app,
              colorFilter: ColorFilter.mode(
                context.colors.accentNeonCyberGreen.withValues(alpha: 0.7),
                BlendMode.srcIn,
              ),
            ),
          ),
          title: Text(
            context.strings?.sosy ?? '',
            style: context.fonts.headlineLgMobile.copyWith(
              color: context.colors.accentNeonCyberGreen,
            ),
            textAlign: TextAlign.left,
          ),
          actions: [
            /// Search button
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search_rounded),
              iconSize: 32.0,
            ),

            /// Bot button
            ValueListenableBuilder(
              valueListenable: _isBotOpen,
              builder: (_, isBotOpen, __) => IconButton(
                onPressed: _openBotDrawer,
                icon: SvgPicture.asset(
                  isBotOpen ? Assets.ic_bot_active : Assets.ic_bot_disable,
                  width: 22,
                  height: 19,
                ),
              ),
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: _selectedIndex,
          builder: (_, index, __) => _pages[index],
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _selectedIndex,
          builder: (_, index, __) => ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 24.0,
                sigmaY: 24.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.accentHeaderGreen.withValues(
                    alpha: 0.80,
                  ),
                  border: Border(
                    top: BorderSide(
                      color: context.colors.borderGreen,
                      width: 1.0,
                    ),
                  ),
                ),
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTheme.of(context)
                        .textTheme
                        .copyWith(tabLabelTextStyle: context.fonts.labelMd),
                  ),
                  child: CupertinoTabBar(
                    onTap: (index) => _selectedIndex.value = index,
                    currentIndex: index,
                    backgroundColor: Colors.transparent,
                    border: null,
                    activeColor: context.colors.accentNeonCyberGreen,
                    inactiveColor: context.colors.neutralMutedSilverGray,
                    items: [
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(Assets.ic_market_inactive),
                        label: context.strings?.market ?? '',
                        activeIcon: SvgPicture.asset(Assets.ic_market_active),
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(Assets.ic_favorites_inactive),
                        label: context.strings?.favorites ?? '',
                        activeIcon:
                            SvgPicture.asset(Assets.ic_favorites_active),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  void _openBotDrawer() {
    Scaffold.of(context).openEndDrawer();
    _isBotOpen.value = !_isBotOpen.value;
  }
}
