import 'dart:js_util';
import 'package:dart_test/kata.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:diff_match_patch/diff_match_patch.dart';

String snapshot() {
  String contents = '';

  final items = [
      Item("Aged Brie", 0, 0),
      Item("Backstage passes to a TAFKAL80ETC concert", 0, 0),
      Item("Sulfuras, Hand of Ragnaros", 0, 0),
      Item("foo", 0, 0),
      Item("Aged Brie", 100, 100),
      Item("Backstage passes to a TAFKAL80ETC concert", 100, 100),
      Item("Sulfuras, Hand of Ragnaros", 100, 100),
      Item("foo", 100, 100),
      Item("Aged Brie", -100, -100),
      Item("Backstage passes to a TAFKAL80ETC concert", -100, -100),
      Item("Sulfuras, Hand of Ragnaros", -100, -100),
      Item("foo", -100, -100),
    ];

    GildedRose app = GildedRose(items);

    for (int i = 0; i < 1000; i++) {
      app.updateQuality();
      for (int j = 0; j < items.length; j++) {
        contents += items[j].toString() + ";";
      }
      contents += "\n";
    }

    return contents;
}

void main() {
  
  test('record unrefactored snapshot', () async { // Run only on the old version 
    var file = File('unrefactoredSnapshot.txt');
    // Write the text to the file asynchronously
    await file.writeAsString(snapshot());
  }, skip: true);

  test('Verify with the old version snapshot', () async {
    var file = File('unrefactoredSnapshot.txt');
    try {
      String contents = await file.readAsString();
      var wFile = File('refactoredSnapshot.txt');
      // Write the text to the file asynchronously
      await wFile.writeAsString(snapshot());
      if ((contents == snapshot()) == false) {
          print(diff(contents, snapshot()).toString());
      }
      expect(contents == snapshot(), true); // just to do not print long string in the output
    } catch (e) {
      fail(e.toString());
    }
  });

  test('Sulfaras remains same quality and sell in', () {
    const quality = 70;
    const saleIn = 100;
    var item = Item('Sulfuras, Hand of Ragnaros', saleIn, quality);
    var items = <Item>[item];

    GildedRose app = GildedRose(items);
    for (int i = 0; i<100; i++) {
      app.updateQuality();
    }


    expect(item.quality, quality);
    expect(item.sellIn, saleIn);
  });

  test('Quality cant be negative for default item', () {
    const quality = 10;
    const sellIn = 10;
    var item = Item('Some item', sellIn, quality);
    var items = <Item>[item];

    GildedRose app = GildedRose(items);
    for (int i = 0; i<100; i++) {
      app.updateQuality();
    }

    expect(item.quality, greaterThanOrEqualTo(0));
  });

  test('Quality decreases twice faster after sale in expired for default item', () {
    const quality = 20;
    const sellIn = 5;
    var item = Item('Some item', sellIn, quality);
    var items = <Item>[item];

    GildedRose app = GildedRose(items);
    for (int i = 0; i<10; i++) {
      app.updateQuality();
    }

    expect(item.quality, 5);
  });

  test('Aged Brie quality increases with the age', () {
    const quality = 0;
    const sellIn = 10;
    var item = Item('Aged Brie', sellIn, quality);
    var items = <Item>[item];

    GildedRose app = GildedRose(items);
    for (int i = 0; i<10; i++) {
      app.updateQuality();
    }

    expect(item.quality, 10);
  });

  test('Aged Brie quality increases with the age but cant be greater then 50', () {
    const quality = 45;
    const sellIn = 10;
    var item = Item('Aged Brie', sellIn, quality);
    var items = <Item>[item];

    GildedRose app = GildedRose(items);
    for (int i = 0; i<10; i++) {
      app.updateQuality();
    }

    expect(item.quality, lessThanOrEqualTo(50));
  });

  test('Backstage pasess loses all the quality if sellIn is negative', () {
    const quality = 100;
    const sellIn = 10;
    var item = Item('Backstage passes to a TAFKAL80ETC concert', sellIn, quality);
    var items = <Item>[item];

    GildedRose app = GildedRose(items);
    for (int i = 0; i<11; i++) {
      app.updateQuality();
    }

    expect(item.quality, 0);
  });

  test('Backstage pasess increase quality at one point before expiration minus 10 days', () {
    const quality = 5;
    const sellIn = 20;
    var item = Item('Backstage passes to a TAFKAL80ETC concert', sellIn, quality);
    var items = <Item>[item];

    GildedRose app = GildedRose(items);
    for (int i = 0; i<10; i++) {
      app.updateQuality();
    }

    expect(item.quality, 15);
  });

  test('Backstage pasess increase quality at two points before expiration minus 5 days', () {
    const quality = 5;
    const sellIn = 9;
    var item = Item('Backstage passes to a TAFKAL80ETC concert', sellIn, quality);
    var items = <Item>[item];

    GildedRose app = GildedRose(items);
    for (int i = 0; i<4; i++) {
      app.updateQuality();
    }

    expect(item.quality, 13);
  });

  test('Backstage pasess increase quality at three points before expiration minus 3 days', () {
    const quality = 5;
    const sellIn = 9;
    var item = Item('Backstage passes to a TAFKAL80ETC concert', sellIn, quality);
    var items = <Item>[item];

    GildedRose app = GildedRose(items);
    for (int i = 0; i<9; i++) {
      app.updateQuality();
    }

    expect(item.quality, 28);
  });

  // "Sulfuras, Hand of Ragnaros"
}