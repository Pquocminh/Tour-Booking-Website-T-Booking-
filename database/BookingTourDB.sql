CREATE DATABASE BookingTourWebsite;
GO

USE BookingTourWebsite;
GO

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

USE BookingTourWebsite;
GO

-- 1. Insert Data for Account
INSERT INTO Account (username, password_hash, email, full_name, phone, role, status)
VALUES 
('admin_tour', 'hashed_password_123', 'admin@bookingtour.vn', N'Quản trị viên', '0901234567', 'Admin', 'Active'),
('staff_01', 'hashed_password_123', 'staff1@bookingtour.vn', N'Nhân viên Sale 01', '0912345678', 'Staff', 'Active'),
('minhpq', 'hashed_password_123', 'minhpq.khachhang@gmail.com', N'Phạm Quốc Minh', '0923456789', 'Customer', 'Active'),
('khachhang2', 'hashed_password_123', 'khachhang2@gmail.com', N'Nguyễn Văn A', '0934567890', 'Customer', 'Active');
GO

-- 2. Insert Data for Category
INSERT INTO Category (category_name, description)
VALUES 
(N'Du lịch phượt & Khám phá', N'Các tour di chuyển bằng xe máy, khám phá các địa danh hoang sơ hoặc các tuyến đường phượt.'),
(N'Du lịch quốc tế', N'Trải nghiệm văn hóa, ẩm thực và cảnh quan tại các quốc gia ngoài Việt Nam.'),
(N'Kiến tập & Company Tour', N'Các tour tổ chức ngắn ngày tham quan doanh nghiệp, phù hợp cho sinh viên, đoàn thể.');
GO

-- 3. Insert Data for Destination
INSERT INTO Destination (destination_name, province, region, description, image_url)
VALUES 
(N'Hà Tiên', N'Kiên Giang', 'South', N'Thành phố ven biển với nhiều di tích lịch sử và hang động kỳ bí.', '/images/destinations/hatien.jpg'),
(N'Bangkok', N'Bangkok', 'International', N'Thủ đô sầm uất của Thái Lan, thiên đường mua sắm và ẩm thực đường phố.', '/images/destinations/bangkok.jpg'),
(N'Thành phố Hồ Chí Minh', N'TP. Hồ Chí Minh', 'South', N'Trung tâm kinh tế năng động nhất Việt Nam.', '/images/destinations/hcmc.jpg');
GO

-- 4. Insert Data for Tour
-- Lưu ý: category_id, created_by, destination_id phụ thuộc vào các ID được tạo tự động ở trên (thường là 1, 2, 3)
INSERT INTO Tour (category_id, created_by, destination_id, tour_name, departure_location, description, duration_days, base_price, status)
VALUES 
(1, 2, 1, N'Phượt Cần Thơ - Hà Tiên: Khám phá Thập Cảnh', N'Cần Thơ', N'Hành trình phượt xe máy 2 ngày 1 đêm từ Cần Thơ đi Hà Tiên, check-in các điểm đến nổi tiếng.', 2, 1200000.00, 'Active'),
(2, 2, 2, N'Trải nghiệm Overseas Semester tại Bangkok', N'Thành phố Hồ Chí Minh', N'Chương trình kết hợp du lịch và trao đổi văn hóa sinh viên quốc tế tại Thái Lan.', 5, 8500000.00, 'Active'),
(3, 2, 3, N'IT Company Tour - Tham quan doanh nghiệp công nghệ', N'Cần Thơ', N'Chuyến đi 1 ngày tham quan các tập đoàn công nghệ lớn tại TP.HCM.', 1, 500000.00, 'Active');
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
(1, 1, N'Cần Thơ - Hà Tiên - Thạch Động', N'Sáng: Di chuyển từ Cần Thơ. Chiều: Tham quan Thạch Động, nghe kể truyền thuyết Thạch Sanh.'),
(1, 2, N'Khám phá Núi Đá Dựng - Trở về Cần Thơ', N'Sáng: Chinh phục 14 hang động tại Núi Đá Dựng. Chiều: Lên xe máy trở về Cần Thơ kết thúc hành trình.'),
(2, 1, N'TP.HCM - Bangkok', N'Bay chuyến trưa sang sân bay Suvarnabhumi. Nhận phòng khách sạn.'),
(2, 2, N'Giao lưu Đại học Kasem Bundit', N'Tham quan campus và giao lưu với sinh viên quốc tế tại đại học Kasem Bundit.'),
(3, 1, N'Tham quan doanh nghiệp phần mềm', N'Di chuyển lên TP.HCM, tham quan không gian làm việc của kỹ sư phần mềm, nghe chia sẻ về Agile/Scrum.');
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
(N'Mùa hè rực rỡ', 10, '2026-06-01', '2026-08-31', 'Active'),
(N'Đón tân sinh viên', 15, '2026-09-01', '2026-10-31', 'Active');
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
-- Giả sử Customer Phạm Quốc Minh (account_id = 3) đặt Tour Phượt Hà Tiên (schedule_id = 1)
INSERT INTO Booking (customer_id, schedule_id, number_of_people, contact_name, contact_phone, total_price, status)
VALUES 
(3, 1, 2, N'Phạm Quốc Minh', '0923456789', 2200000.00, 'Confirmed'),
(4, 2, 1, N'Nguyễn Văn A', '0934567890', 1200000.00, 'Pending');
GO

-- 12. Insert Data for Payment
INSERT INTO Payment (booking_id, amount, payment_method, payment_status, transaction_code)
VALUES 
(1, 2200000.00, 'VNPay', 'Completed', 'VNPAY123456789');
GO

-- 13. Insert Data for BookingVoucher
-- Chú ý: Bảng này áp dụng nếu khách xài voucher 'SVIT50K' (voucher_id = 2) cho booking_id = 1
INSERT INTO BookingVoucher (booking_id, voucher_id)
VALUES 
(1, 2);
GO

-- 14. Insert Data for Review
INSERT INTO Review (booking_id, customer_id, rating, comment, status)
VALUES 
(1, 3, 5, N'Hành trình phượt rất thú vị, cảnh ở Núi Đá Dựng cực kỳ đẹp. HDV hỗ trợ nhiệt tình!', 'Approved');
GO

-- 15. Insert Data for Wishlist
INSERT INTO Wishlist (customer_id, tour_id)
VALUES 
(3, 2),
(3, 3);
GO
