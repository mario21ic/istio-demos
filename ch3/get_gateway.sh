#!/bin/bash

export INGRESS_HOST=$(minikube ip)
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export GATEWAY=$INGRESS_HOST:$INGRESS_PORT
echo $GATEWAY
kubectl get svc istio-ingressgateway -n istio-system
#minikube tunnel
echo $GATEWAY
curl -v $GATEWAY

curl -H "Host: helloweb.dev" $GATEWAY
curl -H "Host: movieweb.dev" $GATEWAY
