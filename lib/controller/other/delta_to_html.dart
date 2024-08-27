// import 'package:quill_delta/quill_delta.dart';
//
// String deltaToHtml(Delta delta) {
//   final StringBuffer html = StringBuffer();
//
//   for (final op in delta.toList()) {
//     if (op.isInsert) {
//       final value = op.data;
//       if (value is String) {
//         html.write(value);
//       } else {
//         final attributes = op.attributes;
//         final tag = _getTag(attributes);
//         final styles = _getStyles(attributes);
//
//         html.write('<$tag');
//         if (styles.isNotEmpty) {
//           html.write(' style="${_getStylesString(styles)}"');
//         }
//         html.write('>');
//         html.write(value);
//         html.write('</$tag>');
//       }
//     }
//   }
//
//   print(html);
//   return html.toString();
// }
//
// String _getTag(Map<String, dynamic>? attributes) {
//   // Default tag is 'p'
//   String tag = 'p';
//
//   if (attributes != null) {
//     final header = attributes['header'];
//     if (header != null) {
//       tag = 'h$header';
//     } else if (attributes.containsKey('blockquote')) {
//       tag = 'blockquote';
//     } else if (attributes.containsKey('code-block')) {
//       tag = 'pre';
//     } else if (attributes.containsKey('list')) {
//       final listType = attributes['list'];
//       if (listType == 'ordered') {
//         tag = 'ol';
//       } else if (listType == 'bullet') {
//         tag = 'ul';
//       }
//     }
//   }
//
//   return tag;
// }
//
// Map<String, String> _getStyles(Map<String, dynamic>? attributes) {
//   final styles = <String, String>{};
//
//   if (attributes != null) {
//     if (attributes.containsKey('bold')) {
//       styles['font-weight'] = 'bold';
//     }
//     if (attributes.containsKey('italic')) {
//       styles['font-style'] = 'italic';
//     }
//     if (attributes.containsKey('underline')) {
//       styles['text-decoration'] = 'underline';
//     }
//     if (attributes.containsKey('color')) {
//       styles['color'] = '#${attributes['color']}';
//     }
//     if (attributes.containsKey('background')) {
//       styles['background-color'] = '#${attributes['background']}';
//     }
//   }
//
//   return styles;
// }
//
// String _getStylesString(Map<String, String> styles) {
//   final sb = StringBuffer();
//   for (final style in styles.entries) {
//     sb.write('${style.key}: ${style.value}; ');
//   }
//   return sb.toString().trim();
// }
