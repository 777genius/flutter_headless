import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'textfield_test_helpers.dart';

/// Test app wrapper for TextField tests.
class TextFieldTestApp extends StatefulWidget {
  const TextFieldTestApp({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<TextFieldTestApp> createState() => _TextFieldTestAppState();
}

class _TextFieldTestAppState extends State<TextFieldTestApp> {
  final _overlayController = OverlayController();

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeadlessThemeProvider(
      theme: MaterialHeadlessTheme(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnchoredOverlayEngineHost(
          controller: _overlayController,
          child: Scaffold(body: widget.child),
        ),
      ),
    );
  }
}

/// Basic TextField test scenario with controlled mode.
class TextFieldTestScenario extends StatefulWidget {
  const TextFieldTestScenario({
    super.key,
    this.initialValue = '',
    this.placeholder,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
  });

  final String initialValue;
  final String? placeholder;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;

  @override
  State<TextFieldTestScenario> createState() => TextFieldTestScenarioState();
}

class TextFieldTestScenarioState extends State<TextFieldTestScenario> {
  late String _value;
  String _submittedValue = '';
  bool _isFocused = false;
  final _focusNode = FocusNode();

  String get value => _value;
  String get submittedValue => _submittedValue;
  bool get isFocused => _isFocused;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RTextField(
              key: TextFieldTestKeys.textField,
              value: _value,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              placeholder: widget.placeholder,
              label: widget.label,
              helperText: widget.helperText,
              errorText: widget.errorText,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _submittedValue = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Value: $_value',
              key: TextFieldTestKeys.valueLabel,
            ),
            Text(
              'Submitted: $_submittedValue',
              key: TextFieldTestKeys.submitLabel,
            ),
            Text(
              'Focused: $_isFocused',
              key: TextFieldTestKeys.focusLabel,
            ),
          ],
        ),
      ),
    );
  }
}

/// TextField test scenario with controller-driven mode.
class ControllerDrivenTextFieldScenario extends StatefulWidget {
  const ControllerDrivenTextFieldScenario({
    super.key,
    this.initialValue = '',
  });

  final String initialValue;

  @override
  State<ControllerDrivenTextFieldScenario> createState() =>
      _ControllerDrivenTextFieldScenarioState();
}

class _ControllerDrivenTextFieldScenarioState
    extends State<ControllerDrivenTextFieldScenario> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RTextField(
              key: TextFieldTestKeys.textField,
              controller: _controller,
              placeholder: 'Type here...',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text(
              'Value: ${_controller.text}',
              key: TextFieldTestKeys.valueLabel,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: const Key('set_text_button'),
                  onPressed: () {
                    _controller.text = 'Programmatic value';
                    setState(() {});
                  },
                  child: const Text('Set Text'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const Key('clear_button'),
                  onPressed: () {
                    _controller.clear();
                    setState(() {});
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Multiple TextFields scenario for focus navigation testing.
class MultipleTextFieldsScenario extends StatefulWidget {
  const MultipleTextFieldsScenario({super.key});

  @override
  State<MultipleTextFieldsScenario> createState() =>
      _MultipleTextFieldsScenarioState();
}

class _MultipleTextFieldsScenarioState
    extends State<MultipleTextFieldsScenario> {
  final _values = <int, String>{1: '', 2: '', 3: ''};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 1; i <= 3; i++) ...[
            Text('Field $i:'),
            const SizedBox(height: 8),
            RTextField(
              key: TextFieldTestKeys.textFieldN(i),
              value: _values[i]!,
              placeholder: 'Field $i',
              onChanged: (v) => setState(() => _values[i] = v),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

/// TextField with validation scenario.
class ValidationTextFieldScenario extends StatefulWidget {
  const ValidationTextFieldScenario({super.key});

  @override
  State<ValidationTextFieldScenario> createState() =>
      _ValidationTextFieldScenarioState();
}

class _ValidationTextFieldScenarioState
    extends State<ValidationTextFieldScenario> {
  String _email = '';

  String? get _errorText {
    if (_email.isEmpty) return null;
    if (!_email.contains('@')) return 'Invalid email format';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RTextField(
              key: TextFieldTestKeys.textField,
              value: _email,
              placeholder: 'Enter email',
              label: 'Email',
              errorText: _errorText,
              onChanged: (v) => setState(() => _email = v),
            ),
            const SizedBox(height: 16),
            Text(
              'Value: $_email',
              key: TextFieldTestKeys.valueLabel,
            ),
          ],
        ),
      ),
    );
  }
}

/// Password field scenario.
class PasswordTextFieldScenario extends StatefulWidget {
  const PasswordTextFieldScenario({super.key});

  @override
  State<PasswordTextFieldScenario> createState() =>
      _PasswordTextFieldScenarioState();
}

class _PasswordTextFieldScenarioState extends State<PasswordTextFieldScenario> {
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RTextField(
              key: TextFieldTestKeys.textField,
              value: _password,
              placeholder: 'Enter password',
              label: 'Password',
              obscureText: true,
              onChanged: (v) => setState(() => _password = v),
            ),
            const SizedBox(height: 16),
            Text(
              'Value: $_password',
              key: TextFieldTestKeys.valueLabel,
            ),
          ],
        ),
      ),
    );
  }
}

/// Multiline TextField scenario.
class MultilineTextFieldScenario extends StatefulWidget {
  const MultilineTextFieldScenario({super.key});

  @override
  State<MultilineTextFieldScenario> createState() =>
      _MultilineTextFieldScenarioState();
}

class _MultilineTextFieldScenarioState
    extends State<MultilineTextFieldScenario> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RTextField(
              key: TextFieldTestKeys.textField,
              value: _text,
              placeholder: 'Enter description...',
              label: 'Description',
              helperText: 'Max 500 characters',
              maxLines: 4,
              minLines: 2,
              onChanged: (v) => setState(() => _text = v),
            ),
            const SizedBox(height: 16),
            Text(
              'Value: $_text',
              key: TextFieldTestKeys.valueLabel,
            ),
            Text('Length: ${_text.length}'),
          ],
        ),
      ),
    );
  }
}
