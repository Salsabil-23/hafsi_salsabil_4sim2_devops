#!/bin/bash
IP=$(minikube ip)
BASE="http://$IP:30080/student"

echo "=== TEST COMPLET DE L'API STUDENT MANAGEMENT ==="
echo "Base URL: $BASE"
echo ""

# Fonction pour formater JSON
format_json() {
    python3 -m json.tool 2>/dev/null || cat
}

# 1. GET all students
echo "1. 📋 LISTE DES ÉTUDIANTS"
echo "GET $BASE/students/getAllStudents"
curl -s "$BASE/students/getAllStudents" | format_json
echo ""

# 2. GET all departments
echo "2. 🏛️ LISTE DES DÉPARTEMENTS"
echo "GET $BASE/Department/getAllDepartment"
curl -s "$BASE/Department/getAllDepartment" | format_json
echo ""

# 3. GET all enrollments
echo "3. 📝 LISTE DES INSCRIPTIONS"
echo "GET $BASE/Enrollment/getAllEnrollment"
curl -s "$BASE/Enrollment/getAllEnrollment" | format_json
echo ""

# 4. CREATE another student
echo "4. 👨‍🎓 CRÉATION D'UN NOUVEL ÉTUDIANT"
STUDENT_JSON='{
  "firstName": "Jane",
  "lastName": "Smith",
  "email": "jane.smith@example.com",
  "phone": "0987654321",
  "dateOfBirth": "2001-02-15",
  "address": "456 Oak St"
}'
echo "POST $BASE/students/createStudent"
echo "Data: $STUDENT_JSON"
curl -s -X POST "$BASE/students/createStudent" \
  -H "Content-Type: application/json" \
  -d "$STUDENT_JSON" | format_json
echo ""

# 5. CREATE another department
echo "5. 🏢 CRÉATION D'UN NOUVEAU DÉPARTEMENT"
DEPT_JSON='{
  "name": "Mathematics",
  "location": "Building B",
  "phone": "555-5678",
  "head": "Dr. Johnson"
}'
echo "POST $BASE/Department/createDepartment"
echo "Data: $DEPT_JSON"
curl -s -X POST "$BASE/Department/createDepartment" \
  -H "Content-Type: application/json" \
  -d "$DEPT_JSON" | format_json
echo ""

# 6. Vérifier le tout
echo "6. ✅ VÉRIFICATION FINALE"
echo "Étudiants:"
curl -s "$BASE/students/getAllStudents" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'Nombre d\\'étudiants: {len(data)}')
for s in data:
    print(f'  - {s[\"firstName\"]} {s[\"lastName\"]} (ID: {s[\"idStudent\"]})')
"

echo ""
echo "Départements:"
curl -s "$BASE/Department/getAllDepartment" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(f'Nombre de départements: {len(data)}')
for d in data:
    print(f'  - {d[\"name\"]} (ID: {d[\"idDepartment\"]})')
"
