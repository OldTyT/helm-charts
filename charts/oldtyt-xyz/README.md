# oldtyt-xyz

helm repo add oldtyt https://oldtyt.github.io/helm-charts/

helm install oldtyt-xyz --values ../../value/oldtyt-xyz.yml -n oldtyt-xyz --create-namespace oldtyt/oldtyt-xyz
helm upgrade oldtyt-xyz --values ../../value/oldtyt-xyz.yml -n oldtyt-xyz --create-namespace oldtyt/oldtyt-xyz
