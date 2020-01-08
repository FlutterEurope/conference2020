import 'package:conferenceapp/config.dart';
import 'package:conferenceapp/main_common.dart';

void main() {
  final space = 'CONTENTFUL_SPACE';
  final apiKey = 'CONTENTFUL_API_KEY';
  final snapfeedProjectId = 'SNAPFEED_PROJECTID';
  final snapfeedSecret = 'SNAPFEED_SECRET';
  final bugfenderKey = 'BUGFENDER_KEY';

  final config = AppConfig(
    contentfulApiKey: apiKey,
    contentfulSpace: space,
    flavor: 'prod',
    snapfeedProjectId: snapfeedProjectId,
    snapfeedSecret: snapfeedSecret,
    bugfenderKey: bugfenderKey,
  );
  mainCommon(config: config);
}
