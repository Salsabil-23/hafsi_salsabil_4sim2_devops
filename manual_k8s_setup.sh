#!/bin/bash

echo "=== Configuration manuelle Kubernetes ==="

# 1. Démarrer Minikube si nécessaire
minikube start

# 2. Créer le namespace
kubectl create namespace devops --dry-run=client -o yaml | kubectl apply -f -

# 3. Vérifier
kubectl get namespaces
kubectl config set-context --current --namespace=devops

echo "✅ Configuration terminée"
echo "Maintenant, le pipeline Jenkins devrait fonctionner"
