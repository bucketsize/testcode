# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class AmzItem(scrapy.Item):
    subCat = scrapy.Field()
    ASIN = scrapy.Field()
    name = scrapy.Field()
    maker = scrapy.Field()
    url = scrapy.Field()
    imgUrl = scrapy.Field()
    price = scrapy.Field()
    oldPrice = scrapy.Field()
    timestamp = scrapy.Field()
