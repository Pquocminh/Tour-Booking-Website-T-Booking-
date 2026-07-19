package model;

import java.sql.Timestamp;

public class Employee extends Account {

    public Employee() {
        super();
    }

    public Employee(int accountId, String username, String passwordHash, String email, 
                   String fullName, String phone, String address, String role, String status, Timestamp createdAt) {
        super(accountId, username, passwordHash, email, fullName, phone, address, role, status, createdAt);
    }
}
