#!/usr/bin/env python
import xml.etree.cElementTree as xml
yweatherNs = {'yweather' : 'http://xml.weather.yahoo.com/ns/rss/1.0'}
yahooUrl = '/home/sejo/.cache/weather.xml'
try:
    root = xml.parse(yahooUrl).getroot()
    conditionsTag = root.find('channel/item/yweather:condition', yweatherNs)
    temp = conditionsTag.get('temp')
    weather = conditionsTag.get('text')

    if not temp:
        temp = "N/A"

    if not weather:
        weather = "N/A"

    print(weather + ":" + temp)

except: #Error opening the file
    print("N/A:N/A")
