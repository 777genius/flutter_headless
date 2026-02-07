import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_contracts/headless_contracts.dart';
import 'package:headless_material/textfield.dart';

void main() {
  group('MaterialTextFieldDecorationFactory', () {
    group('variant mapping', () {
      test('underlined → UnderlineInputBorder, filled: false', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(variant: RTextFieldVariant.underlined),
          state: const RTextFieldState(),
        );

        expect(decoration.border, isA<UnderlineInputBorder>());
        expect(decoration.filled, isFalse);
      });

      test('outlined → OutlineInputBorder, filled: false', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(variant: RTextFieldVariant.outlined),
          state: const RTextFieldState(),
        );

        expect(decoration.border, isA<OutlineInputBorder>());
        expect(decoration.filled, isFalse);
      });

      test('filled → UnderlineInputBorder, filled: true', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(variant: RTextFieldVariant.filled),
          state: const RTextFieldState(),
        );

        expect(decoration.border, isA<UnderlineInputBorder>());
        expect(decoration.filled, isTrue);
      });
    });

    group('spec mapping', () {
      test('maps placeholder to hintText', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(placeholder: 'Enter text'),
          state: const RTextFieldState(),
        );

        expect(decoration.hintText, 'Enter text');
      });

      test('maps label to labelText', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(label: 'Name'),
          state: const RTextFieldState(),
        );

        expect(decoration.labelText, 'Name');
      });

      test('maps helperText', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(helperText: 'Help me'),
          state: const RTextFieldState(),
        );

        expect(decoration.helperText, 'Help me');
      });

      test('maps errorText', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(errorText: 'Required'),
          state: const RTextFieldState(),
        );

        expect(decoration.errorText, 'Required');
      });

      test('maps maxLines to hintMaxLines', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(maxLines: 3),
          state: const RTextFieldState(),
        );

        expect(decoration.hintMaxLines, 3);
      });

      test('maps maxLines:null to hintMaxLines:null', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(maxLines: null),
          state: const RTextFieldState(),
        );

        expect(decoration.hintMaxLines, isNull);
      });

      test('maps disabled state to enabled: false', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(isDisabled: true),
        );

        expect(decoration.enabled, isFalse);
      });
    });

    group('slots mapping', () {
      test('maps leading to prefixIcon', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(),
          slots: const RTextFieldSlots(
            leading: Icon(Icons.search),
          ),
        );

        expect(decoration.prefixIcon, isA<Icon>());
      });

      test('maps trailing to suffixIcon', () {
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(),
          slots: const RTextFieldSlots(
            trailing: Icon(Icons.clear),
          ),
        );

        expect(decoration.suffixIcon, isA<Icon>());
      });

      test('maps prefix slot', () {
        final prefix = Container(key: const ValueKey('p'));
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(isFocused: true),
          slots: RTextFieldSlots(prefix: prefix),
        );

        expect(decoration.prefix, same(prefix));
      });

      test('maps suffix slot', () {
        final suffix = Container(key: const ValueKey('s'));
        final decoration = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(isFocused: true),
          slots: RTextFieldSlots(suffix: suffix),
        );

        expect(decoration.suffix, same(suffix));
      });
    });

    group('parity invariants', () {
      test('does not set contentPadding', () {
        final d = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(),
        );
        expect(d.contentPadding, isNull);
      });

      test('does not set constraints', () {
        final d = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(),
        );
        expect(d.constraints, isNull);
      });

      test('does not set labelStyle', () {
        final d = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(label: 'Label'),
          state: const RTextFieldState(),
        );
        expect(d.labelStyle, isNull);
      });

      test('does not set floatingLabelStyle', () {
        final d = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(label: 'Label'),
          state: const RTextFieldState(),
        );
        expect(d.floatingLabelStyle, isNull);
      });

      test('does not set fillColor', () {
        final d = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(variant: RTextFieldVariant.filled),
          state: const RTextFieldState(),
        );
        expect(d.fillColor, isNull);
      });

      test('does not set hoverColor', () {
        final d = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(isHovered: true),
        );
        expect(d.hoverColor, isNull);
      });

      test('does not set focusedBorder', () {
        final d = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(isFocused: true),
        );
        expect(d.focusedBorder, isNull);
      });

      test('does not set enabledBorder', () {
        final d = MaterialTextFieldDecorationFactory.create(
          spec: const RTextFieldSpec(),
          state: const RTextFieldState(),
        );
        expect(d.enabledBorder, isNull);
      });
    });
  });

  group('MaterialTextFieldStateAdapter', () {
    test('isFocused reflects state.isFocused', () {
      expect(
        MaterialTextFieldStateAdapter.isFocused(
          const RTextFieldState(isFocused: true),
        ),
        isTrue,
      );
      expect(
        MaterialTextFieldStateAdapter.isFocused(
          const RTextFieldState(isFocused: false),
        ),
        isFalse,
      );
    });

    test('isHovering reflects state.isHovered', () {
      expect(
        MaterialTextFieldStateAdapter.isHovering(
          const RTextFieldState(isHovered: true),
        ),
        isTrue,
      );
      expect(
        MaterialTextFieldStateAdapter.isHovering(
          const RTextFieldState(isHovered: false),
        ),
        isFalse,
      );
    });

    test('isEmpty is inverse of state.hasText', () {
      expect(
        MaterialTextFieldStateAdapter.isEmpty(
          const RTextFieldState(hasText: true),
        ),
        isFalse,
      );
      expect(
        MaterialTextFieldStateAdapter.isEmpty(
          const RTextFieldState(hasText: false),
        ),
        isTrue,
      );
    });

    test('isEnabled is inverse of state.isDisabled', () {
      expect(
        MaterialTextFieldStateAdapter.isEnabled(
          const RTextFieldState(isDisabled: true),
        ),
        isFalse,
      );
      expect(
        MaterialTextFieldStateAdapter.isEnabled(
          const RTextFieldState(isDisabled: false),
        ),
        isTrue,
      );
    });

    test('expands is always false in v1', () {
      expect(
        MaterialTextFieldStateAdapter.expands(const RTextFieldState()),
        isFalse,
      );
      expect(
        MaterialTextFieldStateAdapter.expands(
          const RTextFieldState(isFocused: true, hasText: true),
        ),
        isFalse,
      );
    });
  });

  group('MaterialTextFieldAffixVisibilityResolver', () {
    final widget = Container(key: const ValueKey('affix'));

    test('never → null', () {
      final result = MaterialTextFieldAffixVisibilityResolver.resolve(
        mode: RTextFieldOverlayVisibilityMode.never,
        state: const RTextFieldState(),
        widget: widget,
      );
      expect(result, isNull);
    });

    test('always → widget', () {
      final result = MaterialTextFieldAffixVisibilityResolver.resolve(
        mode: RTextFieldOverlayVisibilityMode.always,
        state: const RTextFieldState(),
        widget: widget,
      );
      expect(result, same(widget));
    });

    test('whileEditing → widget when focused', () {
      final result = MaterialTextFieldAffixVisibilityResolver.resolve(
        mode: RTextFieldOverlayVisibilityMode.whileEditing,
        state: const RTextFieldState(isFocused: true),
        widget: widget,
      );
      expect(result, same(widget));
    });

    test('whileEditing → null when not focused', () {
      final result = MaterialTextFieldAffixVisibilityResolver.resolve(
        mode: RTextFieldOverlayVisibilityMode.whileEditing,
        state: const RTextFieldState(isFocused: false),
        widget: widget,
      );
      expect(result, isNull);
    });

    test('notEditing → null when focused', () {
      final result = MaterialTextFieldAffixVisibilityResolver.resolve(
        mode: RTextFieldOverlayVisibilityMode.notEditing,
        state: const RTextFieldState(isFocused: true),
        widget: widget,
      );
      expect(result, isNull);
    });

    test('notEditing → widget when not focused', () {
      final result = MaterialTextFieldAffixVisibilityResolver.resolve(
        mode: RTextFieldOverlayVisibilityMode.notEditing,
        state: const RTextFieldState(isFocused: false),
        widget: widget,
      );
      expect(result, same(widget));
    });

    test('null widget → null regardless of mode', () {
      for (final mode in RTextFieldOverlayVisibilityMode.values) {
        final result = MaterialTextFieldAffixVisibilityResolver.resolve(
          mode: mode,
          state: const RTextFieldState(isFocused: true),
          widget: null,
        );
        expect(result, isNull, reason: 'mode=$mode should return null');
      }
    });
  });

  group('MaterialTextFieldRenderer', () {
    testWidgets('throws StateError on Material 2 theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: false),
          home: Builder(
            builder: (context) {
              return const MaterialTextFieldRenderer().render(
                RTextFieldRenderRequest(
                  context: context,
                  input: const SizedBox.shrink(),
                  spec: const RTextFieldSpec(),
                  state: const RTextFieldState(),
                ),
              );
            },
          ),
        ),
      );

      final error = tester.takeException();
      expect(error, isA<StateError>());
      expect(
        error.toString(),
        contains('requires Material 3'),
      );
    });

    testWidgets('renders InputDecorator with M3 theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox.shrink(),
                    spec: const RTextFieldSpec(
                      label: 'Test Label',
                      placeholder: 'Enter text',
                    ),
                    state: const RTextFieldState(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(InputDecorator), findsOneWidget);
    });

    testWidgets('does not forward baseStyle to InputDecorator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox.shrink(),
                    spec: const RTextFieldSpec(label: 'Label'),
                    state: const RTextFieldState(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(decorator.baseStyle, isNull);
    });

    testWidgets('does not check HeadlessRendererPolicy', (tester) async {
      // Renderer renders without any HeadlessThemeProvider —
      // no policy check, no token requirement.
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox.shrink(),
                    spec: const RTextFieldSpec(label: 'Label'),
                    state: const RTextFieldState(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(InputDecorator), findsOneWidget);
    });

    testWidgets('no GestureDetector wrapper when commands is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox(width: 200, height: 48),
                    spec: const RTextFieldSpec(),
                    state: const RTextFieldState(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsNothing);
      expect(find.byType(InputDecorator), findsOneWidget);
    });

    testWidgets('no GestureDetector wrapper when tapContainer is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox(width: 200, height: 48),
                    spec: const RTextFieldSpec(),
                    state: const RTextFieldState(),
                    commands: const RTextFieldCommands(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsNothing);
      expect(find.byType(InputDecorator), findsOneWidget);
    });

    testWidgets('wraps with GestureDetector for tapContainer', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox(width: 200, height: 48),
                    spec: const RTextFieldSpec(),
                    state: const RTextFieldState(),
                    commands: RTextFieldCommands(
                      tapContainer: () => tapped = true,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, isTrue);
    });
  });

  group('End-to-end: renderer → InputDecorator', () {
    testWidgets(
        'filled variant: decoration.filled=true, border=UnderlineInputBorder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox.shrink(),
                    spec: const RTextFieldSpec(
                      variant: RTextFieldVariant.filled,
                      label: 'Label',
                    ),
                    state: const RTextFieldState(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(decorator.decoration.filled, isTrue);
      expect(decorator.decoration.border, isA<UnderlineInputBorder>());
    });

    testWidgets(
        'outlined variant: decoration.filled=false, border=OutlineInputBorder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox.shrink(),
                    spec: const RTextFieldSpec(
                      variant: RTextFieldVariant.outlined,
                      label: 'Label',
                    ),
                    state: const RTextFieldState(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(decorator.decoration.filled, isFalse);
      expect(decorator.decoration.border, isA<OutlineInputBorder>());
    });

    testWidgets('error+focused propagates through pipeline', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox.shrink(),
                    spec: const RTextFieldSpec(
                      label: 'Label',
                      errorText: 'Required',
                    ),
                    state: const RTextFieldState(
                      isError: true,
                      isFocused: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(decorator.decoration.errorText, 'Required');
      expect(decorator.isFocused, isTrue);
    });

    testWidgets(
        'slots propagate to decoration prefixIcon/suffixIcon/prefix/suffix',
        (tester) async {
      const leading = Icon(Icons.search);
      const trailing = Icon(Icons.clear);
      const prefix = Text('\$');
      const suffix = Text('.00');

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox.shrink(),
                    spec: const RTextFieldSpec(label: 'Amount'),
                    state: const RTextFieldState(isFocused: true),
                    slots: const RTextFieldSlots(
                      leading: leading,
                      trailing: trailing,
                      prefix: prefix,
                      suffix: suffix,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(decorator.decoration.prefixIcon, same(leading));
      expect(decorator.decoration.suffixIcon, same(trailing));
      expect(decorator.decoration.prefix, same(prefix));
      expect(decorator.decoration.suffix, same(suffix));
    });

    testWidgets('affix visibility resolved before reaching InputDecorator',
        (tester) async {
      const prefix = Text('\$');

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const MaterialTextFieldRenderer().render(
                  RTextFieldRenderRequest(
                    context: context,
                    input: const SizedBox.shrink(),
                    spec: const RTextFieldSpec(
                      label: 'Amount',
                      prefixMode: RTextFieldOverlayVisibilityMode.whileEditing,
                    ),
                    state: const RTextFieldState(isFocused: false),
                    slots: const RTextFieldSlots(prefix: prefix),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      // whileEditing + unfocused → prefix should be null
      expect(decorator.decoration.prefix, isNull);
    });
  });
}
