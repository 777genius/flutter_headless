import 'package:flutter/material.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_textfield/headless_textfield.dart';

import '../widgets/theme_mode_switch.dart';
import 'widgets/demo_section.dart';
import 'widgets/textfield_overrides_demo_section.dart';
import 'widgets/textfield_variants_demo_section.dart';

class TextFieldDemoScreen extends StatefulWidget {
  const TextFieldDemoScreen({super.key});

  @override
  State<TextFieldDemoScreen> createState() => _TextFieldDemoScreenState();
}

class _TextFieldDemoScreenState extends State<TextFieldDemoScreen> {
  String _email = '';
  String _password = '';
  String _description = '';
  final _controllerDriven = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _controllerDriven.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextField Demo'),
        actions: const [
          ThemeModeSwitch(),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DemoSection(
              title: 'Controlled Mode',
              description:
                  'Using value + onChanged for state management (React-style)',
              child: Column(
                children: [
                  RTextField(
                    value: _email,
                    onChanged: (v) => setState(() => _email = v),
                    label: 'Email',
                    placeholder: 'Enter your email',
                    helperText: 'We will never share your email',
                    variant: RTextFieldVariant.underlined,
                  ),
                  const SizedBox(height: 8),
                  Text('Current value: $_email'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const TextFieldVariantsDemoSection(),
            const SizedBox(height: 24),
            DemoSection(
              title: 'Password Field',
              description: 'obscureText hides the input',
              child: RTextField(
                value: _password,
                onChanged: (v) => setState(() => _password = v),
                label: 'Password',
                placeholder: 'Enter password',
                obscureText: true,
                variant: RTextFieldVariant.outlined,
              ),
            ),
            const SizedBox(height: 24),
            DemoSection(
              title: 'Error State',
              description: 'errorText displays below the field',
              child: RTextField(
                value: _email,
                onChanged: (v) => setState(() => _email = v),
                label: 'Email with validation',
                placeholder: 'Enter email',
                errorText: _email.isEmpty
                    ? null
                    : _email.contains('@')
                        ? null
                        : 'Please enter a valid email',
                variant: RTextFieldVariant.filled,
              ),
            ),
            const SizedBox(height: 24),
            DemoSection(
              title: 'Multiline',
              description: 'maxLines > 1 enables multiline input',
              child: RTextField(
                value: _description,
                onChanged: (v) => setState(() => _description = v),
                label: 'Description',
                placeholder: 'Enter description...',
                helperText: 'Max 500 characters',
                maxLines: 4,
                minLines: 2,
                variant: RTextFieldVariant.outlined,
              ),
            ),
            const SizedBox(height: 24),
            DemoSection(
              title: 'Disabled State',
              description: 'enabled=false makes field non-interactive',
              child: RTextField(
                value: 'Cannot edit this',
                label: 'Disabled Field',
                enabled: false,
                variant: RTextFieldVariant.outlined,
              ),
            ),
            const SizedBox(height: 24),
            DemoSection(
              title: 'Read-Only State',
              description: 'readOnly=true allows selection but not editing',
              child: RTextField(
                value: 'Read-only content',
                label: 'Read-Only Field',
                readOnly: true,
                variant: RTextFieldVariant.underlined,
              ),
            ),
            const SizedBox(height: 24),
            DemoSection(
              title: 'Controller-Driven Mode',
              description: 'Using TextEditingController for advanced control',
              child: Column(
                children: [
                  RTextField(
                    controller: _controllerDriven,
                    label: 'Controller-driven',
                    placeholder: 'Type here...',
                    onChanged: (v) => setState(() {}),
                    variant: RTextFieldVariant.filled,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _controllerDriven.text = 'Programmatically set!';
                          setState(() {});
                        },
                        child: const Text('Set Text'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _controllerDriven.clear();
                          setState(() {});
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Controller text: ${_controllerDriven.text}'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const TextFieldOverridesDemoSection(),
            const SizedBox(height: 24),
            DemoSection(
              title: 'Slots (leading / trailing)',
              description:
                  'Structural customization without touching behavior.\n'
                  'Useful for search fields, clear buttons, voice input, etc.',
              child: Column(
                children: [
                  RTextField(
                    controller: _searchController,
                    label: 'Search',
                    placeholder: 'Type to search...',
                    onChanged: (_) => setState(() {}),
                    clearButtonMode: RTextFieldOverlayVisibilityMode.whileEditing,
                    slots: const RTextFieldSlots(
                      leading: Icon(Icons.search),
                      trailing: Icon(Icons.mic),
                    ),
                    variant: RTextFieldVariant.filled,
                  ),
                  const SizedBox(height: 8),
                  Text('Value: ${_searchController.text}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
