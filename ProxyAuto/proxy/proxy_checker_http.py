import random
import requests

amount = open("amount.txt", "r")
int = int(amount.read())
proxy_file = 'http.proxies'
working_proxies_file = 'http_working_proxies.txt'

proxies = []
with open(proxy_file, 'r') as f:
    proxies = f.readlines()

random.shuffle(proxies)
working_proxies = []

while len(working_proxies) < int and len(proxies) > 0:
    proxy = proxies.pop().strip()
    print(f'Testing proxy: {proxy}')
    try:
        response = requests.get('https://www.google.com, proxies={'http': proxy, 'https': proxy}, timeout=5)
        if response.status_code == 200:
            working_proxies.append(proxy)
            print(f'Working proxy: {proxy}')
    except:
        print(f'Proxy {proxy} failed. Removing from list.')
        pass

with open(working_proxies_file, 'w') as f:
    f.write('\n'.join(working_proxies))

print(f'{len(working_proxies)} working proxies found.')
