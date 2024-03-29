Configuration:
```
kubectl create namespace tutorial
kubectl config set-context --current --namespace=tutorial

kubectl label namespace tutorial istio-injection=enabled
kubectl get namespace -L istio-injection
```


Blue Green:
```
kubectl apply -f blue-green/destination-rule-recomm-v1-v2.yml
curl $(minikube service --url customer -n tutorial)

kubectl apply -f blue-green/virtual-service-recommendation-v1.yml
curl $(minikube service --url customer -n tutorial)

kubectl apply -f blue-green/virtual-service-recommendation-v2.yml
curl $(minikube service --url customer -n tutorial)

kubectl get destinationrule,virtualservice
kubectl delete virtualservice recommendation 
curl $(minikube service --url customer -n tutorial)
```

Canary:
```
kubectl apply -f canary/destination-rule-recomm-v1-v2.yml
kubectl apply -f canary/virtual-service-recommendation-90-10.yml
kubectl apply -f canary/virtual-service-recommendation-50-50.yml
kubectl get destinationrule,virtualservice

while true; do curl $(minikube service --url customer -n tutorial); sleep 1; done
```

Header match:
```
kubectl apply -f canary/destination-rule-recomm-v1-v2.yml
kubectl apply -f canary/virtual-service-recommendation.yml

curl -A "Safari" $(minikube service --url customer -n tutorial)
curl -A "Firefox" $(minikube service --url customer -n tutorial)
```

Dark Launch:
```
kubectl apply -f dark-launch/destination-rule-recomm-v1-v2.yml
kubectl apply -f dark-launch/virtual-service-recommendation.yml

#k get pods -l version=v2 -o=custom-columns=NAME:.metadata.name
kubectl logs -f `kubectl get pods -l version=v2 -o=jsonpath={.items[0].metadata.name}`
curl $(minikube service --url recommendation -n tutorial)
```

Egress:
```
kubectl apply -f dark-launch/destination-rule-recomm.yml
kubectl apply -f dark-launch/virtual-service-recommendation.yml
kubectl apply -f dark-launch/service-entry.yml

kubectl get destinationrule,virtualservice,serviceentry

#k get pods -l app=recommendation,version=v2 -o=custom-columns=NAME:.metadata.name
kubectl logs -f `kubectl get pods -l app=recommendation,version=v3 -o=jsonpath={.items[0].metadata.name}`
curl -m 5 $(minikube service --url customer -n tutorial)
```

Load Balancing & Timeout & Circuit Breaker:
```
kubectl apply -f circuit-breaker/destination-rule-recomm.yml
kubectl apply -f circuit-breaker/virtual-service-recommendation.yml
siege -r 2 -c 20 -v $(minikube service --url customer -n tutorial)

kubectl apply -f circuit-breaker/destination-rule-recomm-traffic-policy.yml
siege -r 2 -c 20 -v $(minikube service --url customer -n tutorial)


kuebctl scale deployment recommendation-v4 --replicas=2
kubectl get pods -l app=recommendation,version=v4
kubectl exec -ti `kubectl get pods -l app=recommendation,version=v4 -o=jsonpath={.items[0].metadata.name}` -- curl localhost:8080/misbehave


kubectl apply -f circuit-breaker/destination-rule-recomm-policy-pool-ejection.yml
curl $(minikube service --url customer -n tutorial)

kubectl apply -f circuit-breaker/destination-rule-recomm.yml
kubectl apply -f circuit-breaker/virtual-service-recommendation-retry.yml
while true; do curl $(minikube service --url customer -n tutorial); sleep 1; done

```

Http errors:
```
curl -m 5 $(minikube service --url customer -n tutorial)

kubectl apply -f http-errors/destination-rule-recomm.yml
kubectl apply -f http-errors/virtual-service.yml

while true; do curl $(minikube service --url customer -n tutorial); sleep 1; done
```

Delays:
```
APP_URL=$(minikube service --url customer -n tutorial)
curl -m 5 $APP_URL

kubectl apply -f delays/destination-rule-recomm.yml
kubectl apply -f delays/virtual-service.yml

while true; do time curl $APP_URL; sleep 1; done
```


Observability:
```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/jaeger.yaml
kubectl get pods,deploy,service -n istio-system

istioctl dashboard jaeger
```


Metrics:
```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/grafana.yaml
kubectl get pods,deploy,service -n istio-system

istioctl dashboard grafana
istioctl dashboard prometheus
```

Kiali:
```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/kiali.yaml
kubectl get pods,deploy,service -n istio-system
watch kubectl get pods,deploy,service -n tutorial

istioctl dashboard kiali
```

# TODO
Allow:
```
kubectl delete destinationrule,virtualservice,serviceentry --all

kubectl apply -f allow/destination-rule-recomm-v1-v2.yml
kubectl apply -f allow/rules.yml

kubectl get destinationrule,virtualservice,serviceentry

curl $(minikube service --url customer -n tutorial)
```


# TODO
Deny:
```
```

Mutual TLS:
```
kubectl apply -f mtls/enable.yml
kubectl apply -f mtls/destination-rule.yml

kubectl get peerauthentication,destinationrule
istioctl authn tls-check

kubectl exec -ti `kubectl get pods -l app=customer,version=v4 -o=jsonpath={.items[0].metadata.name}` -- 
$ apt install -y tcpdump
$ tcpdump -vvv -A -i eth0 '((dst port 8080) and (net 127.0.0.1))'

curl $(minikube service --url customer -n tutorial)
```



