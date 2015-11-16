from ConfigParser import ConfigParser
import requests

def config():
    c = ConfigParser()
    c.read('.env')
    section = 'default'
    config = {
        'username': c.get(section, 'username')
      , 'password': c.get(section, 'password')
      , 'api_key': c.get(section, 'api_key')
      }
    return config

def do1():
    url = 'https://demo-api.ig.com/gateway/deal/session'
