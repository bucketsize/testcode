# -*- coding: utf-8 -*-
import scrapy
from foospi.items import AmzItem
from datetime import datetime
import re

class AmzSpider(scrapy.Spider):
    name = "amz"
    baseUrl = "http://www.amazon.in"
    allowed_domains = ["amazon.in"]
    start_urls = [
        baseUrl+'/gp/site-directory/ref=nav_shopall_btn'
        ]

    def parse(self, response):
        for cat_el in response.css('.popover-grouping'):
            cat = cat_el.css('h2::text').extract_first()
            if re.search('bag', cat):
                sub_cats = cat_el.css('ul > li > a::attr(href)').extract()
                for sub_cat in sub_cats:
                    self.logger.info('>>> DO Listing {}'.format(sub_cat))
                    if re.search('All', sub_cat):
                        self.logger.info('>>> IGNORE {}'.format(sub_cat))
                        return
                    yield scrapy.Request(self.baseUrl + sub_cat, callback=self.parseSubCat)

    def parseSubCat(self, response):
        if response.status in [301, 302] and 'Location' in response.headers:
            reUrl = response.headers['Location'] 
            self.logger.info('>>> MANUAL REDIR {}'.format(reUrl))
            if re.search('[Bb][Oo][Oo][Kk]', reUrl):
                self.logger.info('>>> IGNORE {}'.format(reUrl))
                return
            yield scrapy.Request(reUrl, callback=self.parseSubCat)
        else:    
            self.logger.info(">>> COMPLETED")
            subCat = response.css('.bxw-pageheader__title__text > h1 ::text').extract_first()
            for itemEl in response.css('.s-result-item'):
                try:
                    item = AmzItem()
                    item['timestamp'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                    # subcat, asin, url, imgurl
                    item['subCat'] = subCat
                    item['ASIN'] = itemEl.css('li ::attr(data-asin)').extract_first()
                    item['url'] = itemEl.css('.a-link-normal ::attr(href)').extract_first()
                    item['imgUrl'] = itemEl.css('.a-link-normal > img ::attr(src)').extract_first()
                    
                    # name
                    # price
                    name = itemEl.css('.a-link-normal')[1].css('a ::text').extract_first()
                    price = itemEl.css('li > div > div')[3].css('div > a > span ::text')[1].extract()
                    oldPrice = itemEl.css('li > div > div')[3].css('div > span')[1].css('::text')[1].extract()
                    if 'See' in name.split(' '):
                        name = itemEl.css('.a-link-normal')[2].css('a ::text').extract_first()
                        price = itemEl.css('li > div > div')[4].css('div > a > span ::text')[1].extract()
                        oldPrice = itemEl.css('li > div > div')[4].css('div > span')[1].css('::text')[1].extract()
                    item['name'], item['price'], item['oldPrice'] = name, price, oldPrice
                    
                    # maker    
                    maker = itemEl.css('li > div > div')[2].css('div > div')[1].css('div > span::text')[1].extract()
                except:
                    self.logger.info('>>> SCRAPE-FAILED {}'.format(item['url']))
                yield item 

            nextUrl = response.css('#pagnNextLink ::attr(href)').extract_first()
            self.logger.info('>>> NEXT-LINK {}'.format(nextUrl))
            if nextUrl:
                yield scrapy.Request(self.baseUrl+nextUrl, callback=self.parseSubCat)

            
