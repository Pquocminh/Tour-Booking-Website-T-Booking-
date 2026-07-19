USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'BookingTourWebsite')
BEGIN
    ALTER DATABASE BookingTourWebsite SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BookingTourWebsite;
END
GO
CREATE DATABASE BookingTourWebsite;
GO
USE BookingTourWebsite;
GO

CREATE TABLE Customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address NVARCHAR(255),
    status VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    last_login DATETIME
);

CREATE TABLE Employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address NVARCHAR(255),
    role VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    last_login DATETIME
);
GO
