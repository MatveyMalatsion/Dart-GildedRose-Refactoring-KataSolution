
import 'dart:math';

void updateAgedBrieQuality(Item item) {
  item.sellIn--;

  if (item.quality > 50) {
    return;
  }

  item.quality = min(item.quality + 1, 50);
  if (item.sellIn < 0) {
    item.quality = min(item.quality + 1, 50);
  }
}

void updateBackstageQuality(Item item) {
  do {
    if (item.sellIn <= 0) {
      item.quality = 0;
      break;
    }
  
    if (item.quality > 50) {
      break;
    }

    if (item.sellIn < 6) {
      item.quality = min(item.quality + 3, 50);
    } else if (item.sellIn < 11) {
      item.quality = min(item.quality + 2, 50); 
    } else if (item.sellIn < 50) {
      item.quality = min(item.quality + 1, 50); 
    }
    
  } while(false);
  
  item.sellIn--;
}

void updateSulfurasQuality(Item item) {
  // Literally do nothing
}

void updateRegularItemQuality(Item item) {
  item.sellIn--;
  if (item.quality >= 0) {
    item.quality = max(item.quality - ((item.sellIn >= 0) ? 1 : 2), 0);
  }
}

class GildedRose {
  List<Item> items;

  GildedRose(this.items);

  final handlers = {
    "Aged Brie": updateAgedBrieQuality,
    "Backstage passes to a TAFKAL80ETC concert": updateBackstageQuality,
    "Sulfuras, Hand of Ragnaros": updateSulfurasQuality
  };

  void updateQuality() {
    for (int i = 0; i < this.items.length; i++) {
      var item = this.items[i];
      var handler = this.handlers[item.name] ?? updateRegularItemQuality;
      handler(item);
    }
  }
}

class Item {
  String name;
  int sellIn;
  int quality;

  Item(this.name, this.sellIn, this.quality);

  String toString() => '$name, $sellIn, $quality';
}
