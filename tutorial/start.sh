#!/bin/bash

ACTION="apply"

k $ACTION -f <(istioctl kube-inject -f customer/kubernetes/Deployment.yml) -n tutorial
k $ACTION -f <(istioctl kube-inject -f preference/kubernetes/Deployment.yml) -n tutorial
k $ACTION -f <(istioctl kube-inject -f recommendation/kubernetes/Deployment.yml) -n tutorial
k $ACTION -f <(istioctl kube-inject -f recommendation/kubernetes/Deployment-v2.yml) -n tutorial

