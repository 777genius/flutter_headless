import 'package:phone_numbers_parser/metadata.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

final class RPhoneFieldSampleNumberResolver {
  const RPhoneFieldSampleNumberResolver();

  PhoneNumber resolve(IsoCode isoCode) {
    final examples = metadataExamplesByIsoCode[isoCode];
    final sample = _firstAvailableSample(examples);
    if (sample == null) {
      return PhoneNumber(isoCode: isoCode, nsn: '');
    }
    return PhoneNumber.parse(
      sample,
      destinationCountry: isoCode,
    );
  }

  String? _firstAvailableSample(dynamic examples) {
    if (examples == null) return null;
    for (final sample in [
      examples.mobile,
      examples.fixedLine,
      examples.voip,
      examples.uan,
      examples.sharedCost,
    ]) {
      if (sample is String && sample.isNotEmpty) {
        return sample;
      }
    }
    return null;
  }
}
