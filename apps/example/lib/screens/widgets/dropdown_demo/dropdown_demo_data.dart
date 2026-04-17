import 'package:flutter/material.dart';
import 'package:headless/headless.dart';

import 'dropdown_demo_option.dart';

const dropdownDemoFruitValues = <String>['One', 'Two', 'Three', 'Four'];

const dropdownDemoCityCodes = <String, String>{
  'New York': 'NYC',
  'Los Angeles': 'LA',
  'San Francisco': 'SF',
  'Chicago': 'CH',
  'Miami': 'MI',
};

const dropdownDemoTravelOptions = <DropdownDemoOption>[
  DropdownDemoOption(
    id: 'lhr',
    title: 'London Heathrow',
    subtitle: 'Airport pickup desk',
    shortLabel: 'LHR',
    leading: HeadlessContent.emoji('🇬🇧'),
  ),
  DropdownDemoOption(
    id: 'cdg',
    title: 'Paris Charles de Gaulle',
    subtitle: 'Morning arrivals board',
    shortLabel: 'CDG',
    leading: HeadlessContent.emoji('🇫🇷'),
  ),
  DropdownDemoOption(
    id: 'hnd',
    title: 'Tokyo Haneda',
    subtitle: 'After-hours concierge',
    shortLabel: 'HND',
    leading: HeadlessContent.emoji('🇯🇵'),
  ),
  DropdownDemoOption(
    id: 'sfo',
    title: 'San Francisco',
    subtitle: 'Downtown rider line',
    shortLabel: 'SFO',
    leading: HeadlessContent.emoji('🇺🇸'),
  ),
];

const dropdownDemoEditorialOptions = <DropdownDemoOption>[
  DropdownDemoOption(
    id: 'issue07',
    title: 'Issue 07',
    subtitle: 'Weekend culture queue',
    shortLabel: '07',
    leading: HeadlessContent.icon(Icons.auto_stories_rounded),
  ),
  DropdownDemoOption(
    id: 'issue11',
    title: 'Issue 11',
    subtitle: 'Front page morning lock',
    shortLabel: '11',
    leading: HeadlessContent.icon(Icons.chrome_reader_mode_rounded),
  ),
  DropdownDemoOption(
    id: 'issue16',
    title: 'Issue 16',
    subtitle: 'Print notes and corrections',
    shortLabel: '16',
    leading: HeadlessContent.icon(Icons.edit_note_rounded),
  ),
  DropdownDemoOption(
    id: 'issue24',
    title: 'Issue 24',
    subtitle: 'Late-night wire roundup',
    shortLabel: '24',
    leading: HeadlessContent.icon(Icons.newspaper_rounded),
  ),
];

const dropdownDemoCommandOptions = <DropdownDemoOption>[
  DropdownDemoOption(
    id: 'prod',
    title: 'prod-eu-1',
    subtitle: 'Primary customer traffic',
    shortLabel: 'LIVE',
    leading: HeadlessContent.icon(Icons.monitor_heart_rounded),
  ),
  DropdownDemoOption(
    id: 'staging',
    title: 'staging-us-2',
    subtitle: 'Verification and release gates',
    shortLabel: 'SAFE',
    leading: HeadlessContent.icon(Icons.shield_moon_rounded),
  ),
  DropdownDemoOption(
    id: 'preview',
    title: 'preview-labs',
    subtitle: 'Design QA and smoke checks',
    shortLabel: 'LAB',
    leading: HeadlessContent.icon(Icons.science_rounded),
  ),
  DropdownDemoOption(
    id: 'archive',
    title: 'archive-west',
    subtitle: 'Rollback snapshots and logs',
    shortLabel: 'LOG',
    leading: HeadlessContent.icon(Icons.inventory_2_rounded),
  ),
];

const dropdownDemoTeamOptions = <DropdownDemoOption>[
  DropdownDemoOption(
    id: 'core',
    title: 'Core UI',
    subtitle: 'Primitives and contracts',
    shortLabel: 'CORE',
    leading: HeadlessContent.icon(Icons.layers_rounded),
  ),
  DropdownDemoOption(
    id: 'growth',
    title: 'Growth',
    subtitle: 'Activation and onboarding',
    shortLabel: 'GROW',
    leading: HeadlessContent.icon(Icons.trending_up_rounded),
  ),
  DropdownDemoOption(
    id: 'research',
    title: 'Research',
    subtitle: 'Explorations and synthesis',
    shortLabel: 'LAB',
    leading: HeadlessContent.icon(Icons.psychology_alt_rounded),
  ),
  DropdownDemoOption(
    id: 'infra',
    title: 'Infra',
    subtitle: 'Pipelines and rollout safety',
    shortLabel: 'OPS',
    leading: HeadlessContent.icon(Icons.settings_suggest_rounded),
  ),
];

final dropdownDemoFruitAdapter = HeadlessItemAdapter<String>.simple(
  id: (value) => ListboxItemId(value),
  titleText: (value) => value,
);

final dropdownDemoCityAdapter = HeadlessItemAdapter<String>(
  id: (value) => ListboxItemId(value),
  primaryText: (value) => value,
  trailing: (value) => HeadlessContent.text(dropdownDemoCityCodes[value] ?? ''),
);

final dropdownDemoOptionAdapter = HeadlessItemAdapter<DropdownDemoOption>(
  id: (value) => ListboxItemId(value.id),
  primaryText: (value) => value.title,
  searchText: (value) => '${value.title} ${value.subtitle} ${value.shortLabel}',
  leading: (value) => value.leading!,
  subtitle: (value) => HeadlessContent.text(value.subtitle),
  trailing: (value) => HeadlessContent.text(value.shortLabel),
);
