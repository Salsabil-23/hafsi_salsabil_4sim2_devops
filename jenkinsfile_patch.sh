#!/bin/bash

JENKINSFILE="Jenkinsfile"

# Créer une sauvegarde
cp "$JENKINSFILE" "${JENKINSFILE}.backup"

# Ajouter une étape de préparation Kubernetes
cat > "$JENKINSFILE" << 'JENKINSFILE_NEW'
pipeline {
    agent any
    
    environment {
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
        DOCKER_HOST = 'unix:///var/run/docker.sock'
    }
    
    stages {
        // NOUVELLE ÉTAPE : Préparation Kubernetes
        stage('Prepare Kubernetes Access') {
            steps {
                script {
                    echo '=== Préparation accès Kubernetes ==='
                    sh '''
                        # Vérifier si Minikube est démarré
                        if ! minikube status 2>/dev/null | grep -q "Running"; then
                            echo "Minikube n\'est pas démarré, tentative de démarrage..."
                            minikube start || echo "Impossible de démarrer Minikube"
                            sleep 30
                        fi
                        
                        # Mettre à jour la configuration
                        minikube update-context 2>/dev/null || true
                        
                        # Vérifier l'accès
                        kubectl get nodes && echo "✅ Kubernetes accessible" || {
                            echo "⚠️  Utilisation de la configuration utilisateur"
                            export KUBECONFIG=/root/.kube/config
                            kubectl get nodes || echo "❌ Impossible d'accéder à Kubernetes"
                        }
                    '''
                }
            }
        }
        
        // ÉTAPE EXISTANTE : Clean Workspace (modifiée)
        stage('Clean Workspace') {
            steps {
                script {
                    sh '''
                        rm -rf *
                        git clean -fdx
                    '''
                    echo '✅ Workspace nettoyé'
                }
            }
        }
        
        // Les autres étapes existantes suivent...
        // [VOTRE CODE EXISTANT ICI - à copier depuis le backup]
JENKINSFILE_NEW

# Ajouter le reste du fichier original (sans les premières lignes)
tail -n +4 "${JENKINSFILE}.backup" >> "$JENKINSFILE"

echo "✅ Jenkinsfile modifié"
echo "Différence:"
diff -u "${JENKINSFILE}.backup" "$JENKINSFILE" | head -50
