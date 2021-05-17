Getting start
```
minikube start --nodes 3 -p multinodes
kubectl get nodes
```

Install on Istio
```
istioctl install --set profile=demo -y
```

Enable Istio on default namespace
```
kubectl get namespace
kubectl label namespace default istio-injection=enabled
```

Deploy App
```
kubectl apply -f hello-app-v1.yaml
kubectl apply -f hello-app-v2.yaml
kubectl get pods
```

Dashboard Kiali
```
istioctl dashboard kiali
```

Generate traffic:
```
kubectl exec -ti hello-v2-5bd6f947bb-jtgsn -- sh
apk add --update curl
while sleep 1; do curl -o /dev/null -s -w %{http_code} http://hello-v1-svc:80/; done

kubectl exec -ti hello-v1-5bd6f947bb-jtgsn -- sh
apk add --update curl
while sleep 1; do curl -o /dev/null -s -w %{http_code} http://hello-v2-svc:80/; done
```

Ingress
```
kubectl apply -f ingress.yaml
kubectl get gateway -A

kubectl get service istio-ingressgateway -n istio-system
curl -H "Host: hello.pelado.local" 192.168.1.108:31923/v2
curl -H "Host: hello.pelado.local" 192.168.1.108:31923/v1
```

Nginx Ingress
```
kubectl apply -f nginx-ingress.yaml
kubectl get deploy
kubectl get configmap
kubectl get svc

while sleep 1; do curl 192.168.1.108:32002/v1 && curl 192.168.1.108:32002/v2; done
```

Check connection errors:
```
kubectl delete deploy hello-v1
```
