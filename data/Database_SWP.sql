-- Ensure we are using the correct database context
USE BookingTourWebsite;
GO

-- Drop foreign keys or tables in reverse order of dependencies
IF OBJECT_ID('dbo.Wishlist', 'U') IS NOT NULL DROP TABLE dbo.Wishlist;
IF OBJECT_ID('dbo.Review', 'U') IS NOT NULL DROP TABLE dbo.Review;
IF OBJECT_ID('dbo.BookingVoucher', 'U') IS NOT NULL DROP TABLE dbo.BookingVoucher;
IF OBJECT_ID('dbo.Payment', 'U') IS NOT NULL DROP TABLE dbo.Payment;
IF OBJECT_ID('dbo.Booking', 'U') IS NOT NULL DROP TABLE dbo.Booking;
IF OBJECT_ID('dbo.Voucher', 'U') IS NOT NULL DROP TABLE dbo.Voucher;
IF OBJECT_ID('dbo.TourPromotion', 'U') IS NOT NULL DROP TABLE dbo.TourPromotion;
IF OBJECT_ID('dbo.Promotion', 'U') IS NOT NULL DROP TABLE dbo.Promotion;
IF OBJECT_ID('dbo.TourSchedule', 'U') IS NOT NULL DROP TABLE dbo.TourSchedule;
IF OBJECT_ID('dbo.Itinerary', 'U') IS NOT NULL DROP TABLE dbo.Itinerary;
IF OBJECT_ID('dbo.TourImage', 'U') IS NOT NULL DROP TABLE dbo.TourImage;
IF OBJECT_ID('dbo.Tour', 'U') IS NOT NULL DROP TABLE dbo.Tour;
IF OBJECT_ID('dbo.Destination', 'U') IS NOT NULL DROP TABLE dbo.Destination;
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL DROP TABLE dbo.Category;
IF OBJECT_ID('dbo.Account', 'U') IS NOT NULL DROP TABLE dbo.Account;
GO

-- Recreate tables
CREATE TABLE Account (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
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
    FOREIGN KEY (created_by) REFERENCES Account(account_id),
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
    status VARCHAR(20),

    FOREIGN KEY (customer_id) REFERENCES Account(account_id),
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
    FOREIGN KEY (customer_id) REFERENCES Account(account_id)
);

CREATE TABLE Wishlist (
    customer_id INT NOT NULL,
    tour_id INT NOT NULL,
    added_at DATETIME DEFAULT GETDATE(),

    PRIMARY KEY (customer_id, tour_id),
    FOREIGN KEY (customer_id) REFERENCES Account(account_id),
    FOREIGN KEY (tour_id) REFERENCES Tour(tour_id)
);
GO

-- 1. Insert Data for Account
INSERT INTO Account (username, password_hash, email, full_name, phone, role, status)
VALUES 
('admin_tour', 'e10adc3949ba59abbe56e057f20f883e', 'admin@bookingtour.vn', N'Administrator', '0901234567', 'Admin', 'Active'),
('staff_01', 'e10adc3949ba59abbe56e057f20f883e', 'staff1@bookingtour.vn', N'Sales Staff 01', '0912345678', 'Staff', 'Active'),
('minhpq', 'e10adc3949ba59abbe56e057f20f883e', 'minhpq.khachhang@gmail.com', N'Pham Quoc Minh', '0923456789', 'Customer', 'Active'),
('khachhang2', 'e10adc3949ba59abbe56e057f20f883e', 'khachhang2@gmail.com', N'Nguyen Van A', '0934567890', 'Customer', 'Active');
GO

-- 2. Insert Data for Category
INSERT INTO Category (category_name, description)
VALUES 
(N'Adventure & Exploration', N'Motorcycle-based tours, exploring untouched destinations or adventurous trails.'),
(N'International Tourism', N'Experience culture, cuisine, and landscapes in countries outside of Vietnam.'),
(N'Study Tour & Company Visits', N'Short-term tours visiting businesses, suitable for students and corporate groups.');
GO

-- 3. Insert Data for Destination
INSERT INTO Destination (destination_name, province, region, description, image_url)
VALUES 
(N'Ha Tien', N'Kien Giang', 'South', N'A coastal city with many historical relics and mysterious caves.', '/images/destinations/hatien.jpg'),
(N'Bangkok', N'Bangkok', 'International', N'The bustling capital of Thailand, a paradise for shopping and street food.', '/images/destinations/bangkok.jpg'),
(N'Ho Chi Minh City', N'Ho Chi Minh City', 'South', N'The most dynamic economic hub in Vietnam.', '/images/destinations/hcmc.jpg');
GO

-- 4. Insert Data for Tour
INSERT INTO Tour (category_id, created_by, destination_id, tour_name, departure_location, description, duration_days, base_price, status)
VALUES 
(1, 2, 1, N'Can Tho - Ha Tien Exploration Adventure', N'Can Tho', N'A 2-day 1-night motorcycle adventure from Can Tho to Ha Tien, checking in at famous destinations.', 2, 1200000.00, 'Active'),
(2, 2, 2, N'Overseas Semester Experience in Bangkok', N'Ho Chi Minh City', N'A program combining travel and international student cultural exchange in Thailand.', 5, 8500000.00, 'Active'),
(3, 2, 3, N'IT Company Tour - Technology Business Visit', N'Can Tho', N'A 1-day trip to visit major technology corporations in Ho Chi Minh City.', 1, 500000.00, 'Active');
GO

-- 5. Insert Data for TourImage
INSERT INTO TourImage (tour_id, image_url, is_thumbnail)
VALUES 
(1, '/images/tours/hatien_thachdong.jpg', 1),
(1, '/images/tours/hatien_nuidadung.jpg', 0),
(2, '/images/tours/bkk_street.jpg', 1),
(3, '/images/tours/hcmc_fpt_software.jpg', 1);
GO

-- 6. Insert Data for Itinerary
INSERT INTO Itinerary (tour_id, day_number, title, description)
VALUES 
(1, 1, N'Can Tho - Ha Tien - Thach Dong', N'Morning: Depart from Can Tho. Afternoon: Visit Thach Dong Cave, listen to the legend of Thach Sanh.'),
(1, 2, N'Explore Da Dung Mountain - Return to Can Tho', N'Morning: Conquer 14 caves at Da Dung Mountain. Afternoon: Return to Can Tho by motorcycle, ending the journey.'),
(2, 1, N'Ho Chi Minh City - Bangkok', N'Take a midday flight to Suvarnabhumi Airport. Check-in at the hotel.'),
(2, 2, N'Kasem Bundit University Exchange', N'Visit the campus and exchange with international students at Kasem Bundit University.'),
(3, 1, N'Software Enterprise Visit', N'Travel to Ho Chi Minh City, visit the workspace of software engineers, and listen to presentations about Agile/Scrum.');
GO

-- 7. Insert Data for TourSchedule
INSERT INTO TourSchedule (tour_id, departure_date, return_date, price, available_slots, status)
VALUES 
(1, '2026-06-15', '2026-06-16', 1100000.00, 20, 'Open'),
(1, '2026-07-10', '2026-07-11', 1200000.00, 20, 'Open'),
(2, '2026-09-24', '2026-09-28', 8500000.00, 15, 'Open'),
(3, '2026-08-20', '2026-08-20', 500000.00, 45, 'Open');
GO

-- 8. Insert Data for Promotion
INSERT INTO Promotion (promotion_name, discount_percent, start_date, end_date, status)
VALUES 
(N'Radiant Summer', 10, '2026-06-01', '2026-08-31', 'Active'),
(N'Welcome Freshmen', 15, '2026-09-01', '2026-10-31', 'Active');
GO

-- 9. Insert Data for TourPromotion
INSERT INTO TourPromotion (promotion_id, tour_id)
VALUES 
(1, 1),
(2, 2);
GO

-- 10. Insert Data for Voucher
INSERT INTO Voucher (voucher_code, discount_percent, minimum_order_value, max_discount_amount, quantity, start_date, end_date, status)
VALUES 
('SUMMER26', 5.00, 2000000.00, 500000.00, 100, '2026-06-01', '2026-12-31', 'Active'),
('SVIT50K', 10.00, 1000000.00, 50000.00, 50, '2026-01-01', '2026-12-31', 'Active');
GO

-- 11. Insert Data for Booking
INSERT INTO Booking (customer_id, schedule_id, number_of_people, contact_name, contact_phone, total_price, status)
VALUES 
(3, 1, 2, N'Pham Quoc Minh', '0923456789', 2200000.00, 'Confirmed'),
(4, 2, 1, N'Nguyen Van A', '0934567890', 1200000.00, 'Pending');
GO

-- 12. Insert Data for Payment
INSERT INTO Payment (booking_id, amount, payment_method, payment_status, transaction_code)
VALUES 
(1, 2200000.00, 'VNPay', 'Completed', 'VNPAY123456789');
GO

-- 13. Insert Data for BookingVoucher
INSERT INTO BookingVoucher (booking_id, voucher_id)
VALUES 
(1, 2);
GO

-- 14. Insert Data for Review
INSERT INTO Review (booking_id, customer_id, rating, comment, status)
VALUES 
(1, 3, 5, N'Very exciting adventure trip, the scenery at Da Dung Mountain is extremely beautiful. The tour guide was very supportive!', 'Approved');
GO

-- 15. Insert Data for Wishlist
INSERT INTO Wishlist (customer_id, tour_id)
VALUES 
(3, 2),
(3, 3);
GO