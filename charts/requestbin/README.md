helm install requestbin --values value/requestbin.yml --create-namespace -n requestbin requestbin/
helm upgrade requestbin --values value/requestbin.yml --create-namespace -n requestbin requestbin/

helm install oldtyt-xyz --values value/oldtyt-xyz.yml -n oldtyt-xyz --create-namespace oldtyt-xyz/
helm upgrade oldtyt-xyz --values value/oldtyt-xyz.yml -n oldtyt-xyz --create-namespace oldtyt-xyz/
