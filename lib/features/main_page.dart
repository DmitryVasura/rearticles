import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/config.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/core/utils/haptics.dart';
import 'package:re_articles/features/articles/presentation/pages/articles_list_page.dart';

class MainPage extends StatefulWidget {
  const new({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final spacing = context.spacing;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Re:Articles'),
        surfaceTintColor: colors.surface,
        backgroundColor: colors.surface,
      ),

      body: IndexedStack(
        index: 0,
        children: [
          ArticlesListPageState(),
        ],
      ),

      drawerEdgeDragWidth: MediaQuery.sizeOf(context).width * Config.drawerSwipeZone,
      onDrawerChanged: (isOpened) {
        if (isOpened) Haptics.light();
      },
      drawer: Drawer(
        backgroundColor: colors.surfaceContainer,
        child: Padding(
          padding: EdgeInsets.all(spacing.m),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DrawerButton(
                icon: CupertinoIcons.home, 
                routeName: RouteNames.main, 
                name: context.l10n.home,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: GlassButton(
                      icon: const Icon(
                        Icons.person_outline,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                    
                        Navigator.pushNamed(
                          context,
                          RouteNames.account,
                        );
                      },
                      shape: LiquidRoundedRectangle(
                        borderRadius: 15,
                      ),
                      settings: LiquidGlassSettings(
                        glassColor:
                            colors.surfaceContainerLow,
                      ),
                    ),
                  ),
                    
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      5,
                      10,
                      10,
                    ),
                    child: GlassButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                    
                        Navigator.pushNamed(
                          context,
                          RouteNames.settings,
                        );
                      },
                      shape: LiquidRoundedRectangle(
                        borderRadius: 15,
                      ),
                      settings: LiquidGlassSettings(
                        glassColor:
                            colors.surfaceContainerLow,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  final IconData icon;
  final String routeName;
  final String name;
  const new({
    required this.icon,
    required this.routeName,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final spacing = context.spacing;
    final raduiuses = context.radiuses;

    return GlassButton.custom(
      onTap: () {
        Navigator.pop(context);
        if (routeName == '/'){
          return;
        }

        Navigator.pushNamed(context, routeName);
      },
      settings: LiquidGlassSettings(
        glassColor: colors.surfaceContainerLow
      ),
      shape: LiquidRoundedRectangle(borderRadius: raduiuses.m),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing.m,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: spacing.s,),
            Text(name)
          ],
        ),
      ),
    );
  }
}