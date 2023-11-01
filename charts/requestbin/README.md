# requestbin

helm repo add oldtyt https://oldtyt.github.io/helm-charts/

helm install requestbin --values ../../value/requestbin.yml -n requestbin --create-namespace oldtyt/requestbin
helm upgrade requestbin --values ../../value/requestbin.yml -n requestbin --create-namespace oldtyt/requestbin
