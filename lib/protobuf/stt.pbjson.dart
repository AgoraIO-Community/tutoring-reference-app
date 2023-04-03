///
//  Generated code. Do not modify.
//  source: stt.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use textDescriptor instead')
const Text$json = const {
  '1': 'Text',
  '2': const [
    const {'1': 'vendor', '3': 1, '4': 1, '5': 5, '10': 'vendor'},
    const {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'seqnum', '3': 3, '4': 1, '5': 5, '10': 'seqnum'},
    const {'1': 'uid', '3': 4, '4': 1, '5': 5, '10': 'uid'},
    const {'1': 'flag', '3': 5, '4': 1, '5': 5, '10': 'flag'},
    const {'1': 'time', '3': 6, '4': 1, '5': 3, '10': 'time'},
    const {'1': 'lang', '3': 7, '4': 1, '5': 5, '10': 'lang'},
    const {'1': 'starttime', '3': 8, '4': 1, '5': 5, '10': 'starttime'},
    const {'1': 'offtime', '3': 9, '4': 1, '5': 5, '10': 'offtime'},
    const {'1': 'words', '3': 10, '4': 3, '5': 11, '6': '.agora.audio2text.Word', '10': 'words'},
  ],
};

/// Descriptor for `Text`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textDescriptor = $convert.base64Decode('CgRUZXh0EhYKBnZlbmRvchgBIAEoBVIGdmVuZG9yEhgKB3ZlcnNpb24YAiABKAVSB3ZlcnNpb24SFgoGc2VxbnVtGAMgASgFUgZzZXFudW0SEAoDdWlkGAQgASgFUgN1aWQSEgoEZmxhZxgFIAEoBVIEZmxhZxISCgR0aW1lGAYgASgDUgR0aW1lEhIKBGxhbmcYByABKAVSBGxhbmcSHAoJc3RhcnR0aW1lGAggASgFUglzdGFydHRpbWUSGAoHb2ZmdGltZRgJIAEoBVIHb2ZmdGltZRIsCgV3b3JkcxgKIAMoCzIWLmFnb3JhLmF1ZGlvMnRleHQuV29yZFIFd29yZHM=');
@$core.Deprecated('Use wordDescriptor instead')
const Word$json = const {
  '1': 'Word',
  '2': const [
    const {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'start_ms', '3': 2, '4': 1, '5': 5, '10': 'startMs'},
    const {'1': 'duration_ms', '3': 3, '4': 1, '5': 5, '10': 'durationMs'},
    const {'1': 'is_final', '3': 4, '4': 1, '5': 8, '10': 'isFinal'},
    const {'1': 'confidence', '3': 5, '4': 1, '5': 1, '10': 'confidence'},
  ],
};

/// Descriptor for `Word`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wordDescriptor = $convert.base64Decode('CgRXb3JkEhIKBHRleHQYASABKAlSBHRleHQSGQoIc3RhcnRfbXMYAiABKAVSB3N0YXJ0TXMSHwoLZHVyYXRpb25fbXMYAyABKAVSCmR1cmF0aW9uTXMSGQoIaXNfZmluYWwYBCABKAhSB2lzRmluYWwSHgoKY29uZmlkZW5jZRgFIAEoAVIKY29uZmlkZW5jZQ==');
