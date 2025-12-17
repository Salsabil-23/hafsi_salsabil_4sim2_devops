#!/bin/bash

FILE="./src/main/java/tn/esprit/studentmanagement/entities/Department.java"

echo "Réparation de l'ordre des imports dans $FILE"

# Créer une sauvegarde
cp "$FILE" "${FILE}.backup2"

# Réorganiser correctement
cat > "$FILE" << 'FILE_CONTENT'
package tn.esprit.studentmanagement.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "department")
public class Department {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idDepartment;
    
    private String name;
    private String location;
    private String phone;
    private String head; // chef de département

    @OneToMany(mappedBy = "department")
    @JsonIgnore
    private List<Student> students;

    // Getters et setters (à ajouter si manquants)
    public Long getIdDepartment() { return idDepartment; }
    public void setIdDepartment(Long idDepartment) { this.idDepartment = idDepartment; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getHead() { return head; }
    public void setHead(String head) { this.head = head; }
    
    public List<Student> getStudents() { return students; }
    public void setStudents(List<Student> students) { this.students = students; }
}
FILE_CONTENT

echo "✅ Fichier réparé avec l'ordre correct des imports"
echo ""
echo "Nouveau contenu:"
head -15 "$FILE"
