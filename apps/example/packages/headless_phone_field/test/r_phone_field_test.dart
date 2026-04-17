import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headless_material/headless_material.dart';
import 'package:headless_phone_field/headless_phone_field.dart';

class _FakeCountryNavigator implements RPhoneFieldCountrySelectorNavigator {
  const _FakeCountryNavigator(this.result);

  final IsoCode? result;

  @override
  final bool searchAutofocus = false;

  @override
  final Color? backgroundColor = null;

  @override
  final bool useRootNavigator = true;

  @override
  Future<IsoCode?> show(
    BuildContext context,
    RPhoneFieldCountrySelectorRequest request,
  ) async {
    return result;
  }
}

Widget _testHarness(Widget child) {
  return HeadlessMaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  testWidgets('country selection updates value and onCountryChanged',
      (tester) async {
    PhoneNumber? lastValue;
    IsoCode? lastCountry;

    await tester.pumpWidget(_testHarness(
      RPhoneField(
        value: const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
        onChanged: (value) => lastValue = value,
        onCountryChanged: (country) => lastCountry = country,
        countrySelectorNavigator: const _FakeCountryNavigator(IsoCode.GB),
        countryButtonBuilder: (context, request) {
          return TextButton(
            key: const Key('country-button'),
            onPressed: request.onPressed,
            child: const Text('Choose country'),
          );
        },
      ),
    ));

    await tester.tap(find.byKey(const Key('country-button')));
    await tester.pumpAndSettle();

    expect(lastCountry, IsoCode.GB);
    expect(lastValue?.isoCode, IsoCode.GB);
  });

  testWidgets('custom country button builder receives current country data',
      (tester) async {
    late RPhoneFieldCountryButtonRequest capturedRequest;

    await tester.pumpWidget(_testHarness(
      RPhoneField(
        value: PhoneNumber.parse('+380671234567'),
        onChanged: (_) {},
        countryButtonBuilder: (context, request) {
          capturedRequest = request;
          return Text(request.country.formattedDialCode);
        },
      ),
    ));

    expect(capturedRequest.country.isoCode, IsoCode.UA);
    expect(
      capturedRequest.country.formattedDialCode.replaceAll(' ', ''),
      '+380',
    );
  });

  testWidgets('custom country button builder can change country directly',
      (tester) async {
    PhoneNumber? lastValue;
    IsoCode? lastCountry;

    await tester.pumpWidget(_testHarness(
      RPhoneField(
        value: const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
        onChanged: (value) => lastValue = value,
        onCountryChanged: (country) => lastCountry = country,
        countries: const [IsoCode.US, IsoCode.GB],
        favoriteCountries: const [IsoCode.GB],
        countryButtonBuilder: (context, request) {
          expect(request.countries.map((item) => item.isoCode),
              contains(IsoCode.GB));
          expect(
            request.favoriteCountries.map((item) => item.isoCode),
            contains(IsoCode.GB),
          );
          return TextButton(
            key: const Key('country-menu-button'),
            onPressed: () => request.onCountrySelected(IsoCode.GB),
            child: const Text('Choose country'),
          );
        },
      ),
    ));

    await tester.tap(find.byKey(const Key('country-menu-button')));
    await tester.pumpAndSettle();

    expect(lastCountry, IsoCode.GB);
    expect(lastValue?.isoCode, IsoCode.GB);
  });

  testWidgets('menu navigator opens inline search and selects country',
      (tester) async {
    PhoneNumber? lastValue;

    await tester.pumpWidget(_testHarness(
      RPhoneField(
        initialValue: const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
        onChanged: (value) => lastValue = value,
        countries: const [IsoCode.US, IsoCode.GB, IsoCode.UA],
        favoriteCountries: const [IsoCode.US],
        countrySelectorNavigator:
            const RPhoneFieldCountrySelectorNavigator.menu(
          height: 360,
          searchAutofocus: true,
        ),
        countryButtonBuilder: (context, request) {
          return TextButton(
            key: const Key('country-button'),
            onPressed: request.onPressed,
            child: const Text('Choose country'),
          );
        },
      ),
    ));

    await tester.tap(find.byKey(const Key('country-button')));
    await tester.pumpAndSettle();

    final searchField = find.byKey(const ValueKey('phone-country-menu-search'));
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'United Kingdom');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('phone-country-option-GB')));
    await tester.pumpAndSettle();

    expect(lastValue?.isoCode, IsoCode.GB);
  });

  testWidgets('menu navigator can center the menu on the whole field',
      (tester) async {
    await tester.pumpWidget(_testHarness(
      Center(
        child: SizedBox(
          width: 420,
          child: RPhoneField(
            key: const ValueKey('centered-menu-field'),
            initialValue: const PhoneNumber(isoCode: IsoCode.FR, nsn: ''),
            onChanged: (_) {},
            countries: const [IsoCode.FR, IsoCode.BE, IsoCode.CH],
            countrySelectorNavigator:
                const RPhoneFieldCountrySelectorNavigator.menu(
              height: 360,
              searchAutofocus: true,
              anchorTarget: RPhoneFieldMenuAnchorTarget.field,
            ),
            countryButtonBuilder: (context, request) {
              return TextButton(
                key: const Key('country-button'),
                onPressed: request.onPressed,
                child: const Text('Choose country'),
              );
            },
          ),
        ),
      ),
    ));

    await tester.tap(find.byKey(const Key('country-button')));
    await tester.pumpAndSettle();

    final fieldCenter =
        tester.getCenter(find.byKey(const ValueKey('centered-menu-field')));
    final menuCenter = tester
        .getCenter(find.byKey(const ValueKey('phone-country-menu-surface')));

    expect(menuCenter.dx, moreOrLessEquals(fieldCenter.dx, epsilon: 1));
  });

  testWidgets('page navigator applies the requested route background',
      (tester) async {
    const routeBackground = Color(0xFF172019);

    await tester.pumpWidget(_testHarness(
      RPhoneField(
        initialValue: const PhoneNumber(isoCode: IsoCode.UA, nsn: ''),
        onChanged: (_) {},
        countries: const [IsoCode.UA, IsoCode.PL, IsoCode.DE],
        countrySelectorNavigator:
            const RPhoneFieldCountrySelectorNavigator.page(
          backgroundColor: routeBackground,
          searchAutofocus: true,
        ),
        countryButtonBuilder: (context, request) {
          return TextButton(
            key: const Key('country-button'),
            onPressed: request.onPressed,
            child: const Text('Choose country'),
          );
        },
      ),
    ));

    await tester.tap(find.byKey(const Key('country-button')));
    await tester.pumpAndSettle();

    final routeTheme = tester.widget<Theme>(
      find
          .byWidgetPredicate(
            (widget) =>
                widget is Theme &&
                widget.data.scaffoldBackgroundColor == routeBackground,
          )
          .last,
    );
    expect(routeTheme.data.scaffoldBackgroundColor, routeBackground);
  });

  testWidgets('changing country button placement does not throw',
      (tester) async {
    Widget subject(RPhoneFieldCountryButtonPlacement placement) {
      return _testHarness(
        RPhoneField(
          value: PhoneNumber.parse('+33123456789'),
          onChanged: (_) {},
          style: RPhoneFieldStyle(countryButtonPlacement: placement),
          countrySelectorNavigator:
              const RPhoneFieldCountrySelectorNavigator.menu(
            height: 360,
            searchAutofocus: true,
          ),
          countryButtonBuilder: (context, request) {
            return TextButton(
              onPressed: request.onPressed,
              child: Text(request.country.isoCode.name),
            );
          },
        ),
      );
    }

    await tester.pumpWidget(subject(RPhoneFieldCountryButtonPlacement.prefix));
    expect(tester.takeException(), isNull);

    await tester
        .pumpWidget(subject(RPhoneFieldCountryButtonPlacement.trailing));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(subject(RPhoneFieldCountryButtonPlacement.suffix));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(subject(RPhoneFieldCountryButtonPlacement.leading));
    expect(tester.takeException(), isNull);
  });

  testWidgets('explicit errorText wins over validator output', (tester) async {
    await tester.pumpWidget(_testHarness(
      RPhoneField(
        value: const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
        onChanged: (_) {},
        errorText: 'Server says no',
        validator: RPhoneFieldValidator.required(),
      ),
    ));

    expect(find.text('Server says no'), findsOneWidget);
    expect(find.text('Enter a phone number'), findsNothing);
  });

  testWidgets('editable text uses phone autofill defaults', (tester) async {
    await tester.pumpWidget(_testHarness(
      RPhoneField(
        value: const PhoneNumber(isoCode: IsoCode.US, nsn: ''),
        onChanged: (_) {},
      ),
    ));

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(
      editable.autofillHints,
      contains(AutofillHints.telephoneNumberNational),
    );
    expect(editable.enableIMEPersonalizedLearning, isFalse);
    expect(editable.autocorrect, isFalse);
    expect(editable.enableSuggestions, isFalse);
  });

  testWidgets('country selection collapses the caret to the end',
      (tester) async {
    final controller = RPhoneFieldController(
      initialValue: PhoneNumber.parse('+12025550148'),
    );

    await tester.pumpWidget(_testHarness(
      RPhoneField(
        controller: controller,
        onChanged: (_) {},
        countries: const [IsoCode.US, IsoCode.GB],
        countryButtonBuilder: (context, request) {
          return TextButton(
            key: const Key('country-menu-button'),
            onPressed: () => request.onCountrySelected(IsoCode.GB),
            child: const Text('Choose country'),
          );
        },
      ),
    ));

    await tester.tap(find.byType(EditableText));
    await tester.pump();
    controller.selectNationalNumber();
    await tester.pump();

    await tester.tap(find.byKey(const Key('country-menu-button')));
    await tester.pumpAndSettle();

    expect(
      controller.textController.selection,
      TextSelection.collapsed(
        offset: controller.textController.text.length,
      ),
    );
  });

  testWidgets(
      'country selection keeps the caret at the end after a late select-all',
      (tester) async {
    final controller = RPhoneFieldController(
      initialValue: PhoneNumber.parse('+12025550148'),
    );

    await tester.pumpWidget(_testHarness(
      RPhoneField(
        controller: controller,
        onChanged: (_) {},
        onCountryChanged: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.selectNationalNumber();
          });
        },
        countries: const [IsoCode.US, IsoCode.GB],
        countryButtonBuilder: (context, request) {
          return TextButton(
            key: const Key('country-menu-button'),
            onPressed: () => request.onCountrySelected(IsoCode.GB),
            child: const Text('Choose country'),
          );
        },
      ),
    ));

    await tester.tap(find.byType(EditableText));
    await tester.pump();

    await tester.tap(find.byKey(const Key('country-menu-button')));
    await tester.pump();
    await tester.pump();

    expect(
      controller.textController.selection,
      TextSelection.collapsed(
        offset: controller.textController.text.length,
      ),
    );
  });
}
