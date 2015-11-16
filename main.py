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

base = 'https://demo-api.ig.com/gateway/deal'

c = config()
payload={"identifier": c["username"], "password": c["password"]}
headers = {
  "Content-Type": "application/json; charset=UTF-8",
  "Accept": "application/json; charset=UTF-8",
  "X-IG-API-KEY": c["api_key"]
  }


def do1():
    url = base + '/session'
    return requests.post(url, headers=headers, json=payload)
