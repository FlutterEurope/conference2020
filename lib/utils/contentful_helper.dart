import 'package:conferenceapp/common/logger.dart';
import 'package:contentful_rich_text/types/types.dart';

extension ContentfulHelper on Document {
  String toSimpleString() {
    if (this == null) {
      return '';
    }
    try {
      var buffer = new StringBuffer();

      this.content.forEach((c) {
        final content = c['content'] as List<dynamic>;
        if (content != null) {
          parseContentNode(content, buffer);
        }
      });

      return buffer.toString();
    } catch (e) {
      logger.error('Error during parsing Contentful document');
      logger.errorException(e);
      return '';
    }
  }

  void parseContentNode(List<dynamic> content, StringBuffer buffer) {
    content.forEach((d) {
      var content = d['content'] as List<dynamic>;
      if (content != null) {
        parseContentNode(content, buffer);
      } else {
        buffer.write(d['value']);
        buffer.write('\n');
      }
    });
  }
}
