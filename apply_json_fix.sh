#!/bin/bash

echo "=== 🔧 CORRECTION DE LA RÉCURSION JSON ==="

# Chercher Department.java
FILE=$(find . -type f -name "Department.java" 2>/dev/null | head -1)

if [ -z "$FILE" ]; then
    echo "❌ Fichier Department.java non trouvé"
    echo "Recherche dans le code source..."
    find . -type f -name "*.java" | head -10
    exit 1
fi

echo "Fichier trouvé: $FILE"

# Créer une sauvegarde
BACKUP="${FILE}.backup.$(date +%s)"
cp "$FILE" "$BACKUP"
echo "Sauvegarde créée: $BACKUP"

# Ajouter l'import et l'annotation
echo "Application de la correction..."

# Solution 1: Ajouter @JsonIgnore
sed -i '1s/^/import com.fasterxml.jackson.annotation.JsonIgnore;\n/' "$FILE"
sed -i '/private List<Student> students;/s/private/@JsonIgnore\n    private/' "$FILE"

echo ""
echo "✅ Correction appliquée !"
echo ""
echo "Différences:"
diff -u "$BACKUP" "$FILE" | head -30

echo ""
echo "Pour appliquer cette correction:"
echo "1. Commit ce fichier: git add $FILE"
echo "2. Commit: git commit -m 'Fix JSON recursion with @JsonIgnore'"
echo "3. Push: git push origin main"
echo "4. Relancer le pipeline Jenkins"
