# istio-demos
Istio demo files in order to practice

Install Istio client
```
curl -L https://git.io/getLatestIstio | sh -
```

Install Istio inside Kubernetes
```
istioctl manifest apply --set profile=demo
kubectl get pods -n istio-system
kubectl get pods -n istio-system
kubectl label namespace default istio-injection=enabled
kubectl get namespace -L istio-injection
```

Prometheus & Grafana:
```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/grafana.yaml
```

Dashboard Kiali:
```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/kiali.yaml
istioctl dashboard kiali
```

Integrations:
https://istio.io/latest/docs/ops/integrations/grafana/
