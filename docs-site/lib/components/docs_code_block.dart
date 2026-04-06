import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/src/page_parser/page_parser.dart';

/// Code block component that outputs plain `<pre><code>` for client-side
/// highlighting via highlight.js CDN.
class DocsCodeBlock extends CustomComponent {
  DocsCodeBlock({this.defaultLanguage = 'dart'}) : super.base();

  final String defaultLanguage;

  static const _plainLanguages = {'', 'none', 'text', 'txt', 'plain'};

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node
        case ElementNode(
              tag: 'Code' || 'CodeBlock',
              :final children,
              :final attributes,
            ) ||
            ElementNode(
              tag: 'pre',
              children: [
                ElementNode(tag: 'code', :final children, :final attributes),
              ],
            )) {
      final rawLanguage = _extractLanguage(attributes);
      final normalizedLanguage = _normalizeLanguage(rawLanguage);
      final source = children?.map((child) => child.innerText).join(' ') ?? '';

      return _DocsCodeBlock(source: source, language: normalizedLanguage);
    }

    return null;
  }

  String? _extractLanguage(Map<String, String> attributes) {
    var language = attributes['language'];
    final cssClass = attributes['class'];
    if (language == null && (cssClass?.startsWith('language-') ?? false)) {
      language = cssClass!.substring('language-'.length);
    }
    return language;
  }

  String? _normalizeLanguage(String? language) {
    final normalized = language?.trim().toLowerCase() ?? '';
    if (_plainLanguages.contains(normalized)) return null;
    return normalized;
  }
}

class _DocsCodeBlock extends StatelessComponent {
  const _DocsCodeBlock({required this.source, this.language});

  final String source;
  final String? language;

  @override
  Component build(BuildContext context) {
    return div(classes: 'code-block', [
      button(
        classes: 'code-block-copy-button',
        attributes: {
          'type': 'button',
          'aria-label': 'Copy code',
          'data-docs-copy': source,
        },
        [Component.text('⧉')],
      ),
      pre([
        code(
          attributes: {
            if (language != null) 'class': 'language-$language',
          },
          [Component.text(source)],
        ),
      ]),
    ]);
  }
}
