import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightTheme = theme.brightness == Brightness.light;

    return AppBar(
      title: Text(
        title, 
        style: theme.appBarTheme.titleTextStyle?.copyWith(
          fontFamily: title == '7 locva' ? 'Eka' : 'BpgNinoMtavruli',
        )
      ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: theme.appBarTheme.elevation,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isLightTheme ? Colors.white.withOpacity(0.5) : theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'უკან',
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
