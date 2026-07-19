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
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    last_login DATETIME
);

CREATE TABLE Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX)
);

CREATE TABLE Destination (
    destination_id INT IDENTITY(1,1) PRIMARY KEY,
    destination_name NVARCHAR(200) NOT NULL,
    province NVARCHAR(100),
    region VARCHAR(50),
    description NVARCHAR(MAX),
    image_url VARCHAR(500)
);

CREATE TABLE Tour (
    tour_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    created_by INT NOT NULL,
    destination_id INT NOT NULL,
    tour_name NVARCHAR(200) NOT NULL,
    departure_location NVARCHAR(200),
    description NVARCHAR(MAX),
    duration_days INT,
    base_price DECIMAL(12,2),
    status VARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    FOREIGN KEY (created_by) REFERENCES Employee(employee_id),
    FOREIGN KEY (destination_id) REFERENCES Destination(destination_id)
);

CREATE TABLE TourImage (
    image_id INT IDENTITY(1,1) PRIMARY KEY,
    tour_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_thumbnail BIT DEFAULT 0,
    uploaded_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (tour_id) REFERENCES Tour(tour_id)
);

CREATE TABLE Itinerary (
    itinerary_id INT IDENTITY(1,1) PRIMARY KEY,
    tour_id INT NOT NULL,
    day_number INT NOT NULL,
    title NVARCHAR(200),
    description NVARCHAR(MAX),

    FOREIGN KEY (tour_id) REFERENCES Tour(tour_id)
);

CREATE TABLE TourSchedule (
    schedule_id INT IDENTITY(1,1) PRIMARY KEY,
    tour_id INT NOT NULL,
    departure_date DATE NOT NULL,
    return_date DATE NOT NULL,
    price DECIMAL(12,2),
    total_slots INT,
    available_slots INT,
    status VARCHAR(20),

    FOREIGN KEY (tour_id) REFERENCES Tour(tour_id)
);

CREATE TABLE Promotion (
    promotion_id INT IDENTITY(1,1) PRIMARY KEY,
    promotion_name NVARCHAR(200) NOT NULL,
    discount_percent INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20)
);

CREATE TABLE TourPromotion (
    promotion_id INT NOT NULL,
    tour_id INT NOT NULL,

    PRIMARY KEY (promotion_id, tour_id),
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id),
    FOREIGN KEY (tour_id) REFERENCES Tour(tour_id)
);

CREATE TABLE Voucher (
    voucher_id INT IDENTITY(1,1) PRIMARY KEY,
    voucher_code VARCHAR(50) NOT NULL UNIQUE,
    discount_percent DECIMAL(5,2),
    minimum_order_value DECIMAL(12,2),
    max_discount_amount DECIMAL(12,2),
    quantity INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20)
);

CREATE TABLE Booking (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    schedule_id INT NOT NULL,
    booking_date DATETIME DEFAULT GETDATE(),
    number_of_people INT NOT NULL,
    contact_name NVARCHAR(100),
    contact_phone VARCHAR(20),
    total_price DECIMAL(12,2),
    deposit_amount DECIMAL(12,2) DEFAULT 0.00,
    status VARCHAR(20),

    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (schedule_id) REFERENCES TourSchedule(schedule_id)
);

CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(12,2),
    payment_method VARCHAR(30),
    payment_status VARCHAR(20),
    transaction_code VARCHAR(255),
    payment_date DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

CREATE TABLE BookingVoucher (
    booking_id INT NOT NULL,
    voucher_id INT NOT NULL,

    PRIMARY KEY (booking_id, voucher_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (voucher_id) REFERENCES Voucher(voucher_id)
);

CREATE TABLE Review (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT,
    comment NVARCHAR(MAX),
    status VARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Wishlist (
    customer_id INT NOT NULL,
    tour_id INT NOT NULL,
    added_at DATETIME DEFAULT GETDATE(),

    PRIMARY KEY (customer_id, tour_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (tour_id) REFERENCES Tour(tour_id)
);

CREATE TABLE BookingStatusHistory (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    changed_by INT NOT NULL,
    changed_at DATETIME DEFAULT GETDATE(),
    note NVARCHAR(255),

    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
    -- removed changed_by foreign key because it can be either customer or employee
);

USE BookingTourWebsite;
GO

SET IDENTITY_INSERT Employee ON;
INSERT INTO Employee (employee_id, username, password_hash, email, full_name, phone, role, status)
VALUES 
(1, 'admin_tour', 'e10adc3949ba59abbe56e057f20f883e', 'admin@bookingtour.com', 'System Administrator', '0901234567', 'Admin', 'Active'),
(2, 'staff_01', 'e10adc3949ba59abbe56e057f20f883e', 'sales01@bookingtour.com', 'Sales Executive 01', '0912345678', 'Staff', 'Active');
SET IDENTITY_INSERT Employee OFF;
GO

SET IDENTITY_INSERT Customer ON;
INSERT INTO Customer (customer_id, username, password_hash, email, full_name, phone, status)
VALUES 
(3, 'minhpq', 'e10adc3949ba59abbe56e057f20f883e', 'minhpq.customer@gmail.com', 'Pham Quoc Minh', '0923456789', 'Active'),
(4, 'customer_02', 'e10adc3949ba59abbe56e057f20f883e', 'alex.jones@gmail.com', 'Alex Jones', '0934567890', 'Active');
SET IDENTITY_INSERT Customer OFF;
GO

-- 3. Insert Data for Category
INSERT INTO Category (category_name, description)
VALUES 
('Backpacking & Adventure', 'Motorbike tours, exploring pristine destinations, or challenging off-road routes.'),
('International Travel', 'Experience culture, cuisine, and landscapes in countries outside of Vietnam.'),
('Academic & Corporate Visits', 'Short-term field trips and company tours designed for students and organizations.');
GO

-- 4. Insert Data for Destination
INSERT INTO Destination (destination_name, province, region, description, image_url)
VALUES 
('Ha Tien', 'Kien Giang', 'South', 'A coastal city known for its rich history, beautiful beaches, and mystical caves.', '/images/destinations/hatien.jpg'),
('Bangkok', 'Bangkok', 'International', 'The bustling capital of Thailand, a paradise for shopping and vibrant street food.', '/images/destinations/bangkok.jpg'),
('Ho Chi Minh City', 'Ho Chi Minh City', 'South', 'The most dynamic economic and financial hub in Vietnam.', '/images/destinations/hcmc.jpg');
GO

-- 5. Insert Data for Tour
INSERT INTO Tour (category_id, created_by, destination_id, tour_name, departure_location, description, duration_days, base_price, status)
VALUES 
(1, 2, 1, 'Can Tho - Ha Tien Motorbike Backpacking Trip', 'Can Tho', 'A thrilling 2 days 1 night motorbike adventure from Can Tho to Ha Tien, checking in at iconic nature spots.', 2, 1200000.00, 'Active'),
(2, 2, 2, 'Bangkok Overseas Semester Experience', 'Ho Chi Minh City', 'An immersive program combining academic exchange and cultural exploration in Thailand.', 5, 8500000.00, 'Active'),
(3, 2, 3, 'IT Corporate Site Visit & Company Tour', 'Can Tho', 'A comprehensive 1-day professional tour visiting top tech corporations and software hubs in HCMC.', 1, 500000.00, 'Active');
GO

-- 6. Insert Data for TourImage
INSERT INTO TourImage (tour_id, image_url, is_thumbnail)
VALUES 
(1, '/images/tours/hatien_thachdong.jpg', 1),
(1, '/images/tours/hatien_nuidadung.jpg', 0),
(2, '/images/tours/bkk_street.jpg', 1),
(3, '/images/tours/hcmc_fpt_software.jpg', 1);
GO

-- 7. Insert Data for Itinerary
INSERT INTO Itinerary (tour_id, day_number, title, description)
VALUES 
(1, 1, 'Can Tho - Ha Tien - Thach Dong Cave', 'Morning: Ride out from Can Tho. Afternoon: Discover Tháº¡ch Äá»™ng cave and enjoy the scenic coastal sunset.'),
(1, 2, 'Da Dung Mountain Trek - Return to Can Tho', 'Morning: Explore the 14 historical caves inside ÄĂ¡ Dá»±ng Mountain. Afternoon: Ride back to Can Tho, tour ends.'),
(2, 1, 'HCMC - Bangkok Arrival', 'Midday flight to Suvarnabhumi Airport. Check-in at the hotel and evening welcome dinner.'),
(2, 2, 'University Campus Exchange', 'Visit and engage in academic workshops with international students at Kasem Bundit University.'),
(3, 1, 'Tech Industry Exploration', 'Travel to HCMC, tour active tech workspace environments, and join a seminar on Agile/Scrum application.');
GO

-- 8. Insert Data for TourSchedule
INSERT INTO TourSchedule (tour_id, departure_date, return_date, price, total_slots, available_slots, status)
VALUES 
(1, '2026-06-15', '2026-06-16', 1100000.00, 20, 20, 'Open'),
(1, '2026-07-10', '2026-07-11', 1200000.00, 20, 20, 'Open'),
(2, '2026-09-24', '2026-09-28', 8500000.00, 15, 15, 'Open'),
(3, '2026-08-20', '2026-08-20', 500000.00, 45, 45, 'Open');
GO

-- 9. Insert Data for Promotion
INSERT INTO Promotion (promotion_name, discount_percent, start_date, end_date, status)
VALUES 
('Vibrant Summer Sale', 10, '2026-06-01', '2026-08-31', 'Active'),
('Freshman Welcome Discount', 15, '2026-09-01', '2026-10-31', 'Active');
GO

-- 10. Insert Data for TourPromotion
INSERT INTO TourPromotion (promotion_id, tour_id)
VALUES 
(1, 1),
(2, 2);
GO

-- 11. Insert Data for Voucher
INSERT INTO Voucher (voucher_code, discount_percent, minimum_order_value, max_discount_amount, quantity, start_date, end_date, status)
VALUES 
('SUMMER26', 5.00, 2000000.00, 500000.00, 100, '2026-06-01', '2026-12-31', 'Active'),
('TECHSTUDENT', 10.00, 1000000.00, 50000.00, 50, '2026-01-01', '2026-12-31', 'Active');
GO

-- 12. Insert Data for Booking
INSERT INTO Booking (customer_id, schedule_id, number_of_people, contact_name, contact_phone, total_price, deposit_amount, status)
VALUES 
(3, 1, 2, 'Pham Quoc Minh', '0923456789', 2200000.00, 660000.00, 'Confirmed'),
(4, 2, 1, 'Alex Jones', '0934567890', 1200000.00, 360000.00, 'Pending');
GO

-- 13. Insert Data for Payment
INSERT INTO Payment (booking_id, amount, payment_method, payment_status, transaction_code)
VALUES 
(1, 2200000.00, 'VNPay', 'Completed', 'VNPAY123456789');
GO

-- 14. Insert Data for BookingVoucher
INSERT INTO BookingVoucher (booking_id, voucher_id)
VALUES 
(1, 2);
GO

-- 15. Insert Data for Review
INSERT INTO Review (booking_id, customer_id, rating, comment, status)
VALUES 
(1, 3, 5, 'The backpacking trip was incredibly exciting! The views at Da Dung Mountain were breathtaking. Helpful guide!', 'Approved');
GO

-- 16. Insert Data for Wishlist
INSERT INTO Wishlist (customer_id, tour_id)
VALUES 
(3, 2),
(3, 3);
GO

-- 17. Insert Data for BookingStatusHistory
INSERT INTO BookingStatusHistory (booking_id, status, changed_by, changed_at, note)
VALUES 
(1, 'Pending', 3, '2026-06-14 09:00:00', 'Booking created by customer'),
(1, 'Confirmed', 1, '2026-06-14 14:30:00', 'Payment verified, booking confirmed by Admin'),
(2, 'Pending', 4, '2026-06-15 10:15:00', 'Booking created by customer');
GO
