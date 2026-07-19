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
