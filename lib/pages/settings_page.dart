
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('პარამეტრები'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'თემა',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Wrap(
              spacing: 8.0,
              children: <Widget>[
                ChoiceChip(
                  label: const Text('ღია'),
                  selected: settingsController.themeMode == ThemeMode.light,
                  onSelected: (bool selected) {
                    if (selected) {
                      settingsController.updateThemeMode(ThemeMode.light);
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('მუქი'),
                  selected: settingsController.themeMode == ThemeMode.dark,
                  onSelected: (bool selected) {
                    if (selected) {
                      settingsController.updateThemeMode(ThemeMode.dark);
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('სისტემური'),
                  selected: settingsController.themeMode == ThemeMode.system,
                  onSelected: (bool selected) {
                    if (selected) {
                      settingsController.updateThemeMode(ThemeMode.system);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'შრიფტის ზომა',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Slider(
              value: settingsController.fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 6,
              label: settingsController.fontSize.round().toString(),
              onChanged: (double value) {
                settingsController.updateFontSize(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
