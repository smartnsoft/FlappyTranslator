import 'package:flappy_translator/src/extensions/list_extensions.dart';
import 'package:test/test.dart';

void main() {
  test('mapIndexedWhere', () {
    expect(
        ['a', 'b', 'c'].mapIndexedWhere((i, e) => e).toList(), ['a', 'b', 'c']);
    expect(['a', 'b', 'c'].mapIndexedWhere((i, e) => i).toList(), [0, 1, 2]);
    // with filter
    expect(
        ['aasd', 'bas', 'cas', 'a', 'asdas']
            .mapIndexedWhere((i, e) => e.length)
            .toList(),
        [4, 3, 3, 1, 5]);
    expect(
        ['aasd', 'bas', 'cas', 'a', 'asdas']
            .mapIndexedWhere((i, e) => e, (i, e) => e.length != 3)
            .toList(),
        ['aasd', 'a', 'asdas']);
    expect(
        ['123456', '123', '123', '12345678', '123456']
            .mapIndexedWhere((i, e) => e[i], (i, e) => e.length != 3)
            .toList(),
        ['1', '4', '5']);
  });
}
