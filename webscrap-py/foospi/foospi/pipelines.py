# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
import json 

class TxtWriterPipeline(object):
    def __init__(self):
        self.file = open('items.txt', 'wb')

    def process_item(self, item, spider):
        self.file.write('name: {}\n'.format(item['name']))
        self.file.write('maker: {}\n'.format(item['maker']))
        self.file.write('url: {}\n'.format(item['url']))
        self.file.write('imgUrl: {}\n'.format(item['imgUrl']))
        self.file.write('--\n')
        return item

    def __del__(self):
        self.file.close()

class JsonWriterPipeline(object):
    def __init__(self):
        self.file = open('items.json', 'wb')

    def process_item(self, item, spider):
        doc = json.dumps(dict(item)) + ',\n'
        self.file.write(doc)
        return item

    def __del__(self):
        self.file.close()
