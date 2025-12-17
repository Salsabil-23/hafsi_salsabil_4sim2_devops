#!/bin/bash

echo "=== Réparation de l'accès Kubernetes pour Jenkins ==="

# Créer le répertoire .kube pour Jenkins
mkdir -p /var/lib/jenkins/.kube

# Obtenir la configuration actuelle de minikube
minikube update-context

# Copier la configuration correcte
cp ~/.kube/config /var/lib/jenkins/.kube/config

# Ajuster les permissions
chown -R jenkins:jenkins /var/lib/jenkins/.kube
chmod 600 /var/lib/jenkins/.kube/config

# Tester l'accès
echo "Test d'accès avec l'utilisateur Jenkins:"
sudo -u jenkins kubectl get nodes 2>/dev/null && echo "✅ SUCCÈS : Jenkins peut accéder à Kubernetes" || {
    echo "❌ ÉCHEC : Jenkins ne peut pas accéder à Kubernetes"
    echo "Solution alternative:"
    echo "1. Copier manuellement:"
    echo "   sudo cp ~/.kube/config /var/lib/jenkins/.kube/"
    echo "   sudo chown jenkins:jenkins /var/lib/jenkins/.kube/config"
    echo ""
    echo "2. Vérifier le endpoint:"
    kubectl config view | grep server
}

# Vérifier également dans le script Jenkins
echo ""
echo "=== Configuration pour Jenkinsfile ==="
echo "Dans votre Jenkinsfile, assurez-vous d'avoir:"
echo ""
echo "environment {"
echo "    KUBECONFIG = '/var/lib/jenkins/.kube/config'"
echo "}"
echo ""
echo "Ou dans les steps:"
echo "sh '''"
echo "  export KUBECONFIG=/var/lib/jenkins/.kube/config"
echo "  kubectl get nodes"
echo "'''"
