# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class FoospiItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    pass

class AmzItem(scrapy.Item):
    name = scrapy.Field()
    maker = scrapy.Field()
    url = scrapy.Field()
    imgUrl = scrapy.Field()
