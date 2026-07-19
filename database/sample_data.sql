USE BookingTourWebsite;
GO

-- Insert Categories
INSERT INTO Category (category_name, description) VALUES
('Adventure', 'Exciting and thrilling tours.'),
('Beach', 'Relaxing beach holidays.'),
('Cultural', 'Experience local culture and history.'),
('Nature', 'Explore the great outdoors.');

-- Insert Destinations
INSERT INTO Destination (destination_name, description) VALUES
('Da Nang', 'Beautiful coastal city with stunning bridges.'),
('Ha Noi', 'The historic capital city of Vietnam.'),
('Ho Chi Minh', 'The bustling economic hub of Vietnam.'),
('Phu Quoc', 'Pearl island with gorgeous beaches.'),
('Sa Pa', 'Misty mountains and terraced rice fields.');

-- Insert Tours (created_by = 1 -> admin_tour)
INSERT INTO Tour (category_id, created_by, destination_id, tour_name, departure_location, description, duration_days, base_price, status) VALUES
(1, 1, 5, 'Sa Pa Trekking Adventure', 'Ha Noi', 'A 3-day trekking adventure through the misty mountains of Sa Pa.', 3, 150.00, 'Active'),
(2, 1, 4, 'Phu Quoc Beach Escape', 'Ho Chi Minh', 'A relaxing 4-day escape to the beautiful beaches of Phu Quoc.', 4, 300.00, 'Active'),
(3, 1, 2, 'Ha Noi City Tour', 'Ha Noi', 'Discover the rich history of Ha Noi in this full-day tour.', 1, 50.00, 'Active'),
(4, 1, 1, 'Da Nang Nature Discovery', 'Da Nang', 'Explore Ba Na Hills, Son Tra Peninsula and Marble Mountains.', 3, 200.00, 'Active');

-- Insert TourImages
INSERT INTO TourImage (tour_id, image_url, is_thumbnail) VALUES
(1, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 1),
(2, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482', 1),
(3, 'https://images.unsplash.com/photo-1555921015-5532091f6026', 1),
(4, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b', 1);

-- Insert Itineraries
INSERT INTO Itinerary (tour_id, day_number, title, description) VALUES
(1, 1, 'Arrival in Sa Pa', 'Check in to the hotel and explore the town.'),
(1, 2, 'Trekking to Cat Cat Village', 'A scenic trek to the local village.'),
(1, 3, 'Fansipan Mountain', 'Take the cable car up to the highest peak in Indochina.'),
(2, 1, 'Arrival in Phu Quoc', 'Check in to the beach resort.'),
(2, 2, 'Island Hopping', 'Visit 3 beautiful islands and go snorkeling.'),
(3, 1, 'City Tour', 'Visit Hoan Kiem Lake, Temple of Literature, and Old Quarter.');

-- Insert TourSchedules
INSERT INTO TourSchedule (tour_id, departure_date, return_date, price, total_slots, available_slots, status) VALUES
(1, DATEADD(day, 10, GETDATE()), DATEADD(day, 13, GETDATE()), 150.00, 20, 20, 'Open'),
(1, DATEADD(day, 20, GETDATE()), DATEADD(day, 23, GETDATE()), 150.00, 20, 20, 'Open'),
(2, DATEADD(day, 15, GETDATE()), DATEADD(day, 19, GETDATE()), 300.00, 30, 28, 'Open'),
(3, DATEADD(day, 5, GETDATE()), DATEADD(day, 6, GETDATE()), 50.00, 50, 49, 'Open'),
(4, DATEADD(day, 30, GETDATE()), DATEADD(day, 33, GETDATE()), 200.00, 25, 25, 'Open');

-- Insert Promotions
INSERT INTO Promotion (promotion_name, discount_percent, start_date, end_date, status) VALUES
('Summer Sale', 10, GETDATE(), DATEADD(month, 1, GETDATE()), 'Active'),
('Early Bird', 15, GETDATE(), DATEADD(month, 2, GETDATE()), 'Active');

-- Insert TourPromotions
INSERT INTO TourPromotion (promotion_id, tour_id) VALUES
(1, 2),
(2, 1),
(2, 4);

-- Insert Vouchers
INSERT INTO Voucher (voucher_code, discount_percent, minimum_order_value, max_discount_amount, quantity, start_date, end_date, status) VALUES
('WELCOME10', 10.00, 100.00, 50.00, 100, GETDATE(), DATEADD(month, 6, GETDATE()), 'Active'),
('VIP20', 20.00, 500.00, 150.00, 50, GETDATE(), DATEADD(month, 1, GETDATE()), 'Active');

-- Assuming customer_id = 3 (minhpq), customer_id = 4 (customer_02) exist
-- Insert Bookings
INSERT INTO Booking (customer_id, schedule_id, number_of_people, contact_name, contact_phone, total_price, deposit_amount, status) VALUES
(3, 3, 2, 'MinhPQ', '0912345678', 600.00, 0.00, 'Pending'),
(4, 4, 1, 'Customer 02', '0987654321', 50.00, 50.00, 'Confirmed');

-- Insert Payments
INSERT INTO Payment (booking_id, amount, payment_method, payment_status) VALUES
(2, 50.00, 'VNPAY', 'Completed');

-- Insert Reviews
INSERT INTO Review (booking_id, customer_id, rating, comment, status) VALUES
(2, 4, 5, 'Great tour, really enjoyed it!', 'Visible');

GO
