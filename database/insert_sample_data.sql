USE BookingTourWebsite;
GO

-- ============================================================================
-- 0. DISABLE CONSTRAINTS & CLEANUP SAMPLE DATA (Preserves Employee & Customer)
-- ============================================================================
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

DELETE FROM BookingStatusHistory;
DELETE FROM Wishlist;
DELETE FROM Review;
DELETE FROM BookingVoucher;
DELETE FROM Payment;
DELETE FROM Booking;
DELETE FROM TourPromotion;
DELETE FROM Promotion;
DELETE FROM Voucher;
DELETE FROM TourSchedule;
DELETE FROM Itinerary;
DELETE FROM TourImage;
DELETE FROM Tour;
DELETE FROM Destination;
DELETE FROM Category;
GO

-- ============================================================================
-- 1. INSERT CATEGORIES (20 Categories with explicit IDs)
-- ============================================================================
SET IDENTITY_INSERT Category ON;
INSERT INTO Category (category_id, category_name, description) VALUES
(1, 'Backpacking & Adventure', 'Motorbike tours, off-road mountain trails, and wilderness exploration.'),
(2, 'Cultural & Heritage', 'UNESCO heritage sites, ancient temples, imperial citadels, and local traditions.'),
(3, 'Beach & Island Resort', 'Tropical beaches, island hopping, coral reef snorkeling, and oceanfront luxury.'),
(4, 'Eco & Nature Discovery', 'National parks, bio-diverse nature reserves, caves, and wildlife sanctuaries.'),
(5, 'Culinary & Foodie Tours', 'Local street food tours, night markets, gourmet dining, and cooking classes.'),
(6, 'Luxury & Wellness Cruise', '5-star luxury cruises, spa retreats, private yachts, and high-end relaxation.'),
(7, 'Academic & Corporate Visits', 'University exchange trips, company site visits, tech hubs, and corporate retreats.'),
(8, 'Family & Leisure', 'Fun-filled family holidays featuring theme parks, cable cars, and kid-friendly spots.'),
(9, 'Honeymoon & Romantic', 'Romantic escapes, sunset private dinners, flower valleys, and scenic couple retreats.'),
(10, 'Photography & Scenic', 'Spectacular mountain passes, terraced rice fields, coastal roads, and flower blooms.'),
(11, 'Spiritual & Pilgrimage', 'Sacred temples, ancient pagodas, meditation centers, and peaceful spiritual sites.'),
(12, 'International Exploration', 'Overseas travel, cross-border cultural immersion, and foreign city sightseeing.'),
(13, 'Extreme Sports & Trekking', 'High-altitude mountain climbing, cave exploration, zip-lining, and water sports.'),
(14, 'Festival & Seasonal Special', 'Special tours designed around seasonal flower blooms, harvests, and local festivals.'),
(15, 'River & Delta Exploration', 'Floating markets, riverboat cruises, fruit orchards, and rustic delta life.'),
(16, 'City Break & Urban Life', 'Weekend city sightseeing, colonial architecture, rooftop lounges, and shopping.'),
(17, 'Highland & Mountain Escapes', 'Cool-climate mountain towns, pine forests, coffee farms, and tea plantations.'),
(18, 'Historical Battlefield & Memory', 'Historic battlefields, war memory museums, and educational heritage trails.'),
(19, 'Private Customized Tours', 'Tailor-made private itineraries crafted for families, couples, and small groups.'),
(20, 'Senior & Gentle Relaxation', 'Slow-paced, comfortable sightseeing tours specially tailored for senior travelers.');
SET IDENTITY_INSERT Category OFF;
GO

-- ============================================================================
-- 2. INSERT DESTINATIONS (20 Destinations with Local Image Paths)
-- Region valid values: 'North', 'Central', 'South', 'International'
-- ============================================================================
SET IDENTITY_INSERT Destination ON;
INSERT INTO Destination (destination_id, destination_name, province, region, description, image_url) VALUES
-- North Vietnam (6 Destinations: IDs 1-6)
(1, 'Ha Long Bay', 'Quang Ninh', 'North', 'UNESCO World Heritage site featuring thousands of towering limestone karst islands.', '/images/destinations/halong.jpg'),
(2, 'Sapa', 'Lao Cai', 'North', 'Misty mountain town renowned for terraced rice fields, Fansipan peak, and ethnic villages.', '/images/destinations/sapa.jpg'),
(3, 'Hanoi', 'Hanoi', 'North', 'Historic capital city of Vietnam with vibrant Old Quarter, ancient temples, and French architecture.', '/images/destinations/hanoi.jpg'),
(4, 'Ninh Binh', 'Ninh Binh', 'North', 'Known as Ha Long Bay on land, featuring Trang An karst landscapes and Mua Cave viewpoint.', '/images/destinations/ninhbinh.jpg'),
(5, 'Ha Giang', 'Ha Giang', 'North', 'Majestic mountain plateau, famous Ma Pi Leng pass, and spectacular terraced valleys.', '/images/destinations/hagiang.jpg'),
(6, 'Cat Ba Island', 'Hai Phong', 'North', 'Largest island in Lan Ha Bay featuring national park bio-reserves and pristine sandy beaches.', '/images/destinations/catba.jpg'),

-- Central Vietnam (6 Destinations: IDs 7-12)
(7, 'Da Nang', 'Da Nang', 'Central', 'Modern coastal city famous for My Khe Beach, Marble Mountains, and Ba Na Hills Golden Bridge.', '/images/destinations/danang.jpg'),
(8, 'Hoi An', 'Quang Nam', 'Central', 'Enchanting UNESCO ancient town with lantern-lit streets, yellow heritage houses, and tailor shops.', '/images/destinations/hoian.jpg'),
(9, 'Hue', 'Thua Thien Hue', 'Central', 'Former imperial capital with royal citadel, Nguyen dynasty emperors tombs, and Perfume River.', '/images/destinations/hue.jpg'),
(10, 'Nha Trang', 'Khanh Hoa', 'Central', 'Premier beach destination featuring turquoise waters, coral reef diving, and VinWonders amusement park.', '/images/destinations/nhatrang.jpg'),
(11, 'Da Lat', 'Lam Dong', 'Central', 'Romantic highland city of eternal spring with pine forests, flower gardens, and cool mountain air.', '/images/destinations/dalat.jpg'),
(12, 'Phong Nha', 'Quang Binh', 'Central', 'Home to Son Doong and Paradise Cave inside the UNESCO Phong Nha - Ke Bang National Park.', '/images/destinations/phongnha.jpg'),

-- South Vietnam (5 Destinations: IDs 13-17)
(13, 'Ho Chi Minh City', 'Ho Chi Minh City', 'South', 'The dynamic economic hub of Vietnam, blending historic colonial landmarks with modern skyscrapers.', '/images/destinations/hcmc.jpg'),
(14, 'Phu Quoc Island', 'Kien Giang', 'South', 'Tropical island paradise with white sand beaches, crystal clear waters, and world-class resorts.', '/images/destinations/phuquoc.jpg'),
(15, 'Can Tho', 'Can Tho', 'South', 'Heart of the Mekong Delta, famous for Cai Rang Floating Market, river canals, and fruit orchards.', '/images/destinations/cantho.jpg'),
(16, 'Ha Tien', 'Kien Giang', 'South', 'Charming coastal border town with historic limestone caves, beaches, and rich local history.', '/images/destinations/hatien.jpg'),
(17, 'Vung Tau', 'Ba Ria - Vung Tau', 'South', 'Popular seaside escape with wide coastal roads, Christ the King statue, and fresh seafood markets.', '/images/destinations/vungtau.jpg'),

-- International Destinations (3 Destinations: IDs 18-20)
(18, 'Bangkok', 'Bangkok', 'International', 'Vibrant capital of Thailand, famous for ornate Buddhist shrines, floating markets, and shopping.', '/images/destinations/bangkok.jpg'),
(19, 'Singapore', 'Singapore', 'International', 'Modern garden city-state featuring Gardens by the Bay, Marina Bay Sands, and Jewel Changi.', '/images/destinations/singapore.jpg'),
(20, 'Tokyo', 'Tokyo', 'International', 'Dynamic Japanese metropolis blending futuristic skyscrapers, historic shrines, and Mt. Fuji views.', '/images/destinations/tokyo.jpg');
SET IDENTITY_INSERT Destination OFF;
GO

-- ============================================================================
-- 3. INSERT TOURS (20 Tours with explicit IDs: 17 VN + 3 Intl)
-- Base price >= 1000.00, created_by = 1 (Admin) or 2 (Staff)
-- ============================================================================
SET IDENTITY_INSERT Tour ON;
INSERT INTO Tour (tour_id, category_id, created_by, destination_id, tour_name, departure_location, description, duration_days, base_price, status) VALUES
(1, 6, 1, 1, 'Ha Long Bay 5-Star Luxury Overnight Cruise', 'Hanoi', 'Experience a magnificent 2-day 1-night luxury cruise through Ha Long Bay, discovering Sung Sot Cave, kayaking in Luon Cave, and enjoying fine dining on board.', 2, 3500000.00, 'Active'),
(2, 1, 2, 2, 'Sapa Fansipan Peak & Ethnic Village Trekking', 'Hanoi', 'A thrilling 3-day adventure exploring the misty mountains of Sapa, trekking through Cat Cat and Ta Van ethnic villages, and riding the cable car to Fansipan Peak.', 3, 2800000.00, 'Active'),
(3, 5, 1, 3, 'Hanoi Old Quarter Foodie & Street Art Tour', 'Hanoi', 'A culinary 1-day walking tour tasting famous Hanoi egg coffee, Pho, Bun Cha, and exploring hidden street food alleys in the historic Old Quarter.', 1, 650000.00, 'Active'),
(4, 4, 2, 4, 'Trang An & Mua Cave Eco Boat Tour', 'Hanoi', 'A full-day eco tour visiting the UNESCO Trang An Landscape Complex by wooden sampan boat and climbing 500 steps to Mua Cave viewpoint for panoramic views.', 1, 850000.00, 'Active'),
(5, 13, 1, 5, 'Ha Giang Motorbike Loop & Ma Pi Leng Expedition', 'Hanoi', 'An epic 4-day motorbike loop across Ha Giang rocky plateau, tackling the legendary Ma Pi Leng Pass, boat riding on Nho Que river, and staying at local homestays.', 4, 4200000.00, 'Active'),
(6, 3, 2, 6, 'Cat Ba National Park & Lan Ha Bay Kayaking', 'Hai Phong', 'A 2-day island escape trekking through Cat Ba National Park jungle, kayaking through quiet lagoons in Lan Ha Bay, and relaxing on sandy beaches.', 2, 1950000.00, 'Active'),
(7, 8, 1, 7, 'Ba Na Hills Golden Bridge & Coastal Fun', 'Da Nang', 'A 2-day fun family tour taking the cable car to Ba Na Hills, photographing the iconic Golden Hands Bridge, exploring French Village, and unwinding at My Khe Beach.', 2, 2100000.00, 'Active'),
(8, 2, 2, 8, 'Hoi An Lantern Festival & Ancient Town Walking Tour', 'Da Nang', 'A charming 1-day tour strolling through UNESCO Hoi An Ancient Town, visiting ancient assembly halls, crafting your own silk lantern, and joining the evening river light boat.', 1, 750000.00, 'Active'),
(9, 11, 1, 9, 'Hue Imperial Citadel & Royal Tombs Heritage Tour', 'Hue', 'A 2-day deep dive into Vietnamese royal history, visiting the Hue Imperial Citadel, Thien Mu Pagoda, and the grand tombs of King Minh Mang and Khai Dinh.', 2, 1600000.00, 'Active'),
(10, 3, 2, 10, 'Nha Trang 4 Islands Coral Reef Hopping', 'Nha Trang', 'A vibrant 1-day boat tour visiting 4 islands in Nha Trang Bay, snorkeling at Mun Island coral preserve, enjoying floating seafood lunch, and water sports.', 1, 950000.00, 'Active'),
(11, 9, 1, 11, 'Romantic Da Lat Valley of Love & Pine Hills', 'Ho Chi Minh City', 'A romantic 3-day getaway to cool mountain city Da Lat, visiting Valley of Love, Langbiang Mountain peak, Tuyen Lam Lake, and fresh flower farms.', 3, 2650000.00, 'Active'),
(12, 13, 2, 12, 'Phong Nha Paradise Cave & Dark Cave Expedition', 'Dong Hoi', 'A 2-day adventurous cave expedition exploring Paradise Cave limestone formations and zip-lining, mud bathing, and kayaking inside Dark Cave.', 2, 3100000.00, 'Active'),
(13, 7, 1, 13, 'HCMC IT Corporate Site Visit & Innovation Hubs', 'Can Tho', 'A professional 1-day corporate tour visiting top software technology campuses, tech workspace environments, and attending seminars on Agile innovation.', 1, 550000.00, 'Active'),
(14, 3, 2, 14, 'Phu Quoc Tropical Sunset & Cable Car Beach Escape', 'Ho Chi Minh City', 'A 3-day tropical island getaway riding Hon Thom sea-crossing cable car, island hopping on speedboat, and catching sunsets at Grand World Venetian canal.', 3, 4900000.00, 'Active'),
(15, 15, 1, 15, 'Cai Rang Floating Market & Mekong Delta Tour', 'Can Tho', 'An authentic 1-day Mekong Delta experience taking an early morning boat to Cai Rang Floating Market, visiting traditional noodle workshops and fruit orchards.', 1, 450000.00, 'Active'),
(16, 1, 2, 16, 'Can Tho - Ha Tien Motorbike Coastal Adventure', 'Can Tho', 'A thrilling 2-day 1-night coastal motorbike journey from Can Tho to Ha Tien, discovering mystical Thach Dong Cave and trekking Da Dung Mountain.', 2, 1200000.00, 'Active'),
(17, 16, 1, 17, 'Vung Tau Weekend Beach & Christ Statue Relaxation', 'Ho Chi Minh City', 'A relaxing 2-day weekend beach break climbing Mount Nho Christ Statue, taking oceanview photos at Cape Nghinh Phong, and indulging in fresh seafood.', 2, 1350000.00, 'Active'),
(18, 12, 2, 18, 'Bangkok Shopping & Grand Palace Cultural Trip', 'Ho Chi Minh City', 'An exciting 4-day international package exploring Bangkok Grand Palace, Wat Arun, cruising Chao Phraya River, and shopping at CentralWorld and Chatuchak Market.', 4, 6800000.00, 'Active'),
(19, 12, 1, 19, 'Singapore Jewel Changi & Gardens by the Bay Discovery', 'Ho Chi Minh City', 'A premier 4-day tour to modern Singapore, visiting Jewel Changi Rain Vortex, Gardens by the Bay Flower Dome, Merlion Park, and Universal Studios Singapore.', 4, 9500000.00, 'Active'),
(20, 12, 2, 20, 'Tokyo Mt Fuji & Asakusa Heritage Tour', 'Ho Chi Minh City', 'An unforgettable 5-day Japan tour exploring Tokyo historic Asakusa Sensoji Temple, Tokyo Skytree, viewing Mt. Fuji from Lake Ashi cruise, and Shinjuku nightscape.', 5, 18500000.00, 'Active');
SET IDENTITY_INSERT Tour OFF;
GO

-- ============================================================================
-- 4. INSERT TOUR IMAGES (20 Records with Local Image Paths)
-- ============================================================================
SET IDENTITY_INSERT TourImage ON;
INSERT INTO TourImage (image_id, tour_id, image_url, is_thumbnail) VALUES
(1, 1, '/images/tours/tour_1.jpg', 1),
(2, 2, '/images/tours/tour_2.jpg', 1),
(3, 3, '/images/tours/tour_3.jpg', 1),
(4, 4, '/images/tours/tour_4.jpg', 1),
(5, 5, '/images/tours/tour_5.jpg', 1),
(6, 6, '/images/tours/tour_6.jpg', 1),
(7, 7, '/images/tours/tour_7.jpg', 1),
(8, 8, '/images/tours/tour_8.jpg', 1),
(9, 9, '/images/tours/tour_9.jpg', 1),
(10, 10, '/images/tours/tour_10.jpg', 1),
(11, 11, '/images/tours/tour_11.jpg', 1),
(12, 12, '/images/tours/tour_12.jpg', 1),
(13, 13, '/images/tours/tour_13.jpg', 1),
(14, 14, '/images/tours/tour_14.jpg', 1),
(15, 15, '/images/tours/tour_15.jpg', 1),
(16, 16, '/images/tours/tour_16.jpg', 1),
(17, 17, '/images/tours/tour_17.jpg', 1),
(18, 18, '/images/tours/tour_18.jpg', 1),
(19, 19, '/images/tours/tour_19.jpg', 1),
(20, 20, '/images/tours/tour_20.jpg', 1);
SET IDENTITY_INSERT TourImage OFF;
GO

-- ============================================================================
-- 5. INSERT ITINERARIES (46 Daily Records with explicit IDs for all 20 Tours)
-- ============================================================================
SET IDENTITY_INSERT Itinerary ON;
INSERT INTO Itinerary (itinerary_id, tour_id, day_number, title, description) VALUES
-- Tour 1 (2 Days)
(1, 1, 1, 'Hanoi - Ha Long Bay - Sung Sot Cave', 'Board luxury cruise at Tuan Chau Marina. Enjoy buffet lunch while sailing past karst islets. Afternoon guided tour inside Sung Sot Cave.'),
(2, 1, 2, 'Luon Cave Kayaking - Return to Hanoi', 'Morning Taichi session on deck. Kayak through Luon Cave. Enjoy farewell brunch while cruising back to port and transfer to Hanoi.'),

-- Tour 2 (3 Days)
(3, 2, 1, 'Hanoi - Sapa - Cat Cat Village', 'Depart Hanoi by luxury bus. Arrive in Sapa for check-in. Afternoon trek to Cat Cat village of Hmong ethnic culture.'),
(4, 2, 2, 'Fansipan Peak Summit - Muong Hoa Valley', 'Take the cable car to Fansipan Summit (Legend 3,143m). Afternoon scenic walk through Muong Hoa terraced rice valley.'),
(5, 2, 3, 'Lao Chai & Ta Van Village - Hanoi Return', 'Morning trek visiting Lao Chai and Ta Van villages. Enjoy local ethnic lunch before bus transfer back to Hanoi.'),

-- Tour 3 (1 Day)
(6, 3, 1, 'Hanoi Old Quarter Foodie & Culture Walk', 'Morning egg coffee tasting at Cafe Giang, visit Dong Xuan Market, taste authentic Pho Thin and Bun Cha Huong Lien, end with street art walking.'),

-- Tour 4 (1 Day)
(7, 4, 1, 'Trang An Sampan Ride & Mua Cave Trek', 'Travel from Hanoi to Ninh Binh. Board wooden sampan boat exploring Trang An limestone caves, then climb 500 stone steps to Mua Cave dragon peak.'),

-- Tour 5 (4 Days)
(8, 5, 1, 'Hanoi - Ha Giang City - Quan Ba Pass', 'Drive from Hanoi to Ha Giang. Ride up Quan Ba Heaven Gate and view Twin Mountains. Overnight in Quan Ba homestay.'),
(9, 5, 2, 'Quan Ba - Dong Karst Plateau - Hmong Palace', 'Ride through Yen Minh pine forest and Dong Van Karst Plateau. Visit Hmong King Vuong Palace and Dong Van Ancient Town.'),
(10, 5, 3, 'Ma Pi Leng Pass - Nho Que River Boat', 'Conquer Ma Pi Leng Pass, one of Vietnam four great mountain passes. Boat ride along turquoise Nho Que river through Tu San canyon.'),
(11, 5, 4, 'Du Gia Waterfall - Ha Giang - Hanoi Return', 'Morning swim at Du Gia natural waterfall, ride back to Ha Giang City and take afternoon bus back to Hanoi.'),

-- Tour 6 (2 Days)
(12, 6, 1, 'Hai Phong Ferry - Cat Ba Jungle Trek', 'Take ferry to Cat Ba Island. Afternoon guided jungle trekking inside Cat Ba National Park up to Ngu Lam peak.'),
(13, 6, 2, 'Lan Ha Bay Kayaking - Monkey Island', 'Board cruise into Lan Ha Bay, kayak around Dark & Bright Cave lagoons, swim at Monkey Island beach before returning to Hai Phong.'),

-- Tour 7 (2 Days)
(14, 7, 1, 'Da Nang - Ba Na Hills - Golden Bridge', 'Take world-record cable car up Ba Na Hills. Walk across the iconic Golden Hands Bridge and explore French Village and Fantasy Park.'),
(15, 7, 2, 'My Khe Beach - Marble Mountains - Departure', 'Morning beach relaxation at My Khe Beach. Visit Marble Mountains and Am Phu Cave before transfer to airport.'),

-- Tour 8 (1 Day)
(16, 8, 1, 'Hoi An Ancient Town & Lantern Night', 'Guided walking tour visiting Japanese Covered Bridge, Tan Ky Ancient House, Phuc Kien Assembly Hall, silk lantern workshop, and evening river boat lantern drop.'),

-- Tour 9 (2 Days)
(17, 9, 1, 'Hue Imperial Citadel & Thien Mu Pagoda', 'Explore the ancient Hue Imperial Citadel and Forbidden Purple City. Afternoon boat trip on Perfume River visiting Thien Mu Pagoda.'),
(18, 9, 2, 'Royal Tombs of Minh Mang & Khai Dinh', 'Visit the regal tomb of Emperor Minh Mang and the European-influenced Khai Dinh Tomb. Taste traditional Hue royal cuisine before tour end.'),

-- Tour 10 (1 Day)
(19, 10, 1, 'Nha Trang 4 Islands Speedboat & Snorkeling', 'Speedboat ride to Mun Island marine preserve for snorkeling, visit Tranh Beach for water sports, enjoy floating seafood lunch at Con Se Tre.'),

-- Tour 11 (3 Days)
(20, 11, 1, 'HCMC - Da Lat Arrival - Xuan Huong Lake', 'Drive or flight from HCMC to Da Lat. Check in hotel, walk around Xuan Huong Lake, and explore Da Lat Night Market.'),
(21, 11, 2, 'Valley of Love - Langbiang Mountain Peak', 'Visit romantic Valley of Love, take jeep ride up Langbiang Mountain for panoramic views, and visit Tuyen Lam Lake Zen Monastery.'),
(22, 11, 3, 'Hydrangea Flower Farm - Return to HCMC', 'Morning photoshoot at Hydrangea Flower Field, visit Cable Car Robin Hill, and return transfer to HCMC.'),

-- Tour 12 (2 Days)
(23, 12, 1, 'Dong Hoi Arrival - Paradise Cave Discovery', 'Arrive in Dong Hoi, drive to Phong Nha National Park. Explore 1km of stunning stalactites inside Paradise Cave.'),
(24, 12, 2, 'Dark Cave Zip-line & Mud Bath Adventure', 'Experience 400m zip-line into Dark Cave, swim in underground mud bath, kayak on Chay River, and return transfer to Dong Hoi.'),

-- Tour 13 (1 Day)
(25, 13, 1, 'HCMC IT Tech Campus & Corporate Seminar', 'Travel to HCMC IT Tech Park, tour modern software engineering workspaces, engage in Q&A session with senior developers on Agile practices.'),

-- Tour 14 (3 Days)
(26, 14, 1, 'HCMC - Phu Quoc Arrival - Grand World', 'Flight from HCMC to Phu Quoc Island. Check in seaside resort. Evening stroll along Grand World Venetian canal and watch water laser show.'),
(27, 14, 2, 'Hon Thom 3-Wire Cable Car & 4 Islands Cruise', 'Ride the world longest sea-crossing cable car to Hon Thom. Speedboat island hopping to Fingernail & May Rut islands for snorkeling.'),
(28, 14, 3, 'Sunset Sanato & Local Pepper Farm', 'Morning visit to Phu Quoc Pepper Farm and Fish Sauce Factory. Check-in at Sunset Sanato beach before flight back to HCMC.'),

-- Tour 15 (1 Day)
(29, 15, 1, 'Cai Rang Floating Market & Mekong Life', 'Early 5:30 AM boat tour to Cai Rang Floating Market, taste pineapple on riverboat, visit Huot Huong noodle factory and fruit garden.'),

-- Tour 16 (2 Days)
(30, 16, 1, 'Can Tho - Ha Tien Motorbike Ride', 'Scenic motorbike ride along border coastal road from Can Tho to Ha Tien. Visit historical Thach Dong Cave and Mui Nai Beach sunset.'),
(31, 16, 2, 'Da Dung Mountain Exploration - Can Tho Return', 'Explore 14 natural limestone caves inside Da Dung Mountain. Enjoy local seafood lunch and ride back to Can Tho.'),

-- Tour 17 (2 Days)
(32, 17, 1, 'HCMC - Vung Tau - Back Beach Relaxation', 'Drive from HCMC to Vung Tau coastal city. Check-in hotel, swim at Back Beach, and enjoy evening night market seafood feast.'),
(33, 17, 2, 'Christ the King Statue Climb - Cape Nghinh Phong', 'Climb 847 steps up Mount Nho to Christ Statue shoulder viewpoint. Visit Cape Nghinh Phong before afternoon return to HCMC.'),

-- Tour 18 (4 Days)
(34, 18, 1, 'HCMC - Bangkok Arrival - Asiatique Riverfront', 'Flight to Suvarnabhumi Airport. Transfer to hotel. Evening dinner and shopping at Asiatique The Riverfront night market.'),
(35, 18, 2, 'Grand Palace - Wat Arun - Chao Phraya Cruise', 'Visit Bangkok Grand Palace and Emerald Buddha Temple. Take riverboat to Wat Arun (Temple of Dawn) and evening Chao Phraya dinner cruise.'),
(36, 18, 3, 'Chatuchak Weekend Market & CentralWorld', 'Full day shopping spree at Chatuchak Weekend Market, Pratunam market district, and CentralWorld shopping mega complex.'),
(37, 18, 4, 'Safari World Marine Park - Flight Return', 'Visit Safari World open zoo and marine show park. Transfer to airport for flight back to Ho Chi Minh City.'),

-- Tour 19 (4 Days)
(38, 19, 1, 'HCMC - Singapore Jewel Changi Arrival', 'Flight to Changi Airport. Photograph the 40m indoor Rain Vortex waterfall at Jewel. Transfer to hotel and evening Clark Quay walk.'),
(39, 19, 2, 'Merlion Park - Gardens by the Bay Light Show', 'Visit iconic Merlion Statue, Floral Fantasy Dome, Cloud Forest, and witness the Supertree Grove evening Garden Rhapsody light show.'),
(40, 19, 3, 'Universal Studios Singapore - Sentosa Island', 'Full day pass at Universal Studios Singapore theme park on Sentosa Island, enjoying Transformers ride and Siloso Beach.'),
(41, 19, 4, 'Chinatown - Orchard Road - Flight Departure', 'Morning cultural walk through Chinatown and Buddha Tooth Relic Temple. Last-minute souvenir shopping on Orchard Road before flight home.'),

-- Tour 20 (5 Days)
(42, 20, 1, 'Vietnam - Tokyo Narita Arrival - Shinjuku', 'Flight to Tokyo Narita/Haneda Airport. Transfer to hotel. Evening walk through illuminated Shinjuku neon district.'),
(43, 20, 2, 'Asakusa Temple - Tokyo Skytree - Akihabara', 'Visit Tokyo oldest Asakusa Sensoji Temple, Nakamise shopping street, view city from Tokyo Skytree, and explore Akihabara tech town.'),
(44, 20, 3, 'Mt. Fuji 5th Station - Lake Ashi Cruise', 'Drive to Mt. Fuji 5th Station for panoramic views. Scenic boat cruise on Lake Ashi in Hakone and ride Komagatake Ropeway cable car.'),
(45, 20, 4, 'Shibuya Crossing - Meiji Shrine - Ginza', 'Walk across world famous Shibuya Scramble Crossing, visit serene Meiji Jingu Shrine inside Yoyogi Park, and luxury shopping in Ginza.'),
(46, 20, 5, 'Tsukiji Outer Seafood Market - Departure', 'Morning fresh sushi breakfast at Tsukiji Outer Seafood Market. Transfer to Narita Airport for return flight to Vietnam.');
SET IDENTITY_INSERT Itinerary OFF;
GO

-- ============================================================================
-- 6. INSERT TOUR SCHEDULES (32 Open & Closed Schedules with explicit IDs)
-- ============================================================================
SET IDENTITY_INSERT TourSchedule ON;
INSERT INTO TourSchedule (schedule_id, tour_id, departure_date, return_date, price, total_slots, available_slots, status, assigned_staff_id) VALUES
-- Tour 1 (Ha Long)
(1, 1, '2026-06-10', '2026-06-11', 3500000.00, 44, 42, 'Closed', 2),
(2, 1, '2026-08-15', '2026-08-16', 3500000.00, 44, 44, 'Open', 2),
-- Tour 2 (Sapa)
(3, 2, '2026-06-01', '2026-06-03', 2800000.00, 44, 42, 'Closed', 2),
(4, 2, '2026-08-20', '2026-08-22', 2800000.00, 44, 44, 'Open', 2),
-- Tour 3 (Hanoi Foodie)
(5, 3, '2026-06-05', '2026-06-05', 650000.00, 44, 42, 'Closed', 2),
(6, 3, '2026-08-25', '2026-08-25', 650000.00, 44, 44, 'Open', 2),
-- Tour 4 (Trang An)
(7, 4, '2026-06-20', '2026-06-20', 850000.00, 44, 42, 'Closed', 2),
-- Tour 5 (Ha Giang)
(8, 5, '2026-06-10', '2026-06-13', 4200000.00, 44, 42, 'Closed', 2),
(9, 5, '2026-10-10', '2026-10-13', 4200000.00, 44, 44, 'Open', 2),
-- Tour 6 (Cat Ba)
(10, 6, '2026-06-25', '2026-06-26', 1950000.00, 44, 42, 'Closed', 2),
-- Tour 7 (Ba Na Hills)
(11, 7, '2026-06-15', '2026-06-16', 2100000.00, 44, 42, 'Closed', 2),
(12, 7, '2026-09-02', '2026-09-03', 2100000.00, 44, 42, 'Open', 2),
-- Tour 8 (Hoi An)
(13, 8, '2026-08-14', '2026-08-14', 750000.00, 44, 44, 'Open', 2),
-- Tour 9 (Hue)
(14, 9, '2026-08-28', '2026-08-29', 1600000.00, 44, 44, 'Open', 2),
-- Tour 10 (Nha Trang)
(15, 10, '2026-08-16', '2026-08-16', 950000.00, 44, 44, 'Open', 2),
-- Tour 11 (Da Lat)
(16, 11, '2026-06-20', '2026-06-22', 2650000.00, 44, 42, 'Closed', 2),
(17, 11, '2026-10-20', '2026-10-22', 2650000.00, 44, 44, 'Open', 2),
-- Tour 12 (Phong Nha)
(18, 12, '2026-06-28', '2026-06-29', 3100000.00, 44, 42, 'Closed', 2),
-- Tour 13 (HCMC Site Visit)
(19, 13, '2026-08-20', '2026-08-20', 550000.00, 88, 88, 'Open', 2),
-- Tour 14 (Phu Quoc)
(20, 14, '2026-09-01', '2026-09-03', 4900000.00, 44, 44, 'Open', 2),
(21, 14, '2026-10-15', '2026-10-17', 4900000.00, 44, 44, 'Open', 2),
-- Tour 15 (Cai Rang)
(22, 15, '2026-08-11', '2026-08-11', 450000.00, 44, 44, 'Open', 2),
-- Tour 16 (Ha Tien)
(23, 16, '2026-08-29', '2026-08-30', 1200000.00, 44, 44, 'Open', 2),
-- Tour 17 (Vung Tau)
(24, 17, '2026-08-15', '2026-08-16', 1350000.00, 44, 44, 'Open', 2),
-- Tour 18 (Bangkok)
(25, 18, '2026-06-25', '2026-06-28', 6800000.00, 44, 42, 'Closed', 2),
(26, 18, '2026-10-22', '2026-10-25', 6800000.00, 44, 44, 'Open', 2),
-- Tour 19 (Singapore)
(27, 19, '2026-10-01', '2026-10-04', 9500000.00, 44, 42, 'Open', 2),
(28, 19, '2026-11-12', '2026-11-15', 9500000.00, 44, 44, 'Open', 2),
-- Tour 20 (Tokyo)
(29, 20, '2026-10-15', '2026-10-19', 18500000.00, 44, 44, 'Open', 2),
(30, 20, '2026-11-20', '2026-11-24', 18500000.00, 44, 44, 'Open', 2),
(31, 1, '2026-10-05', '2026-10-06', 3500000.00, 44, 44, 'Open', 2),
(32, 2, '2026-10-10', '2026-10-12', 2800000.00, 44, 44, 'Open', 2);
SET IDENTITY_INSERT TourSchedule OFF;
GO

-- ============================================================================
-- 7. INSERT PROMOTIONS (20 Event & Holiday Promotions with explicit IDs)
-- ============================================================================
SET IDENTITY_INSERT Promotion ON;
INSERT INTO Promotion (promotion_id, promotion_name, discount_percent, start_date, end_date, status) VALUES
(1, 'Tet Grand Lunar New Year Festival', 20, '2026-01-15', '2026-02-28', 'Active'),
(2, 'Spring Flower & Pilgrimage Season', 10, '2026-02-15', '2026-03-31', 'Active'),
(3, 'Hung Kings Ancestor Commemoration Day', 15, '2026-04-10', '2026-04-25', 'Active'),
(4, 'Reunification & Labor Day Super Sale', 25, '2026-04-25', '2026-05-05', 'Active'),
(5, 'Summer Sun & Beach Vacation Bash', 15, '2026-06-01', '2026-08-31', 'Active'),
(6, 'Youth & Student Summer Break Promo', 12, '2026-06-15', '2026-08-31', 'Active'),
(7, 'Vietnam National Day Grand Celebration', 20, '2026-08-25', '2026-09-05', 'Active'),
(8, 'Mid-Autumn Lantern & Mooncake Festival', 10, '2026-09-10', '2026-09-30', 'Active'),
(9, 'Golden Autumn Leaf & Rice Harvest Promo', 15, '2026-09-15', '2026-10-31', 'Active'),
(10, 'Vietnamese Women Day Special', 18, '2026-10-15', '2026-10-25', 'Active'),
(11, 'Teachers Day Heritage Honor Promo', 15, '2026-11-15', '2026-11-25', 'Active'),
(12, 'Black Friday Super Travel Deals', 30, '2026-11-20', '2026-11-30', 'Active'),
(13, 'Cyber Week Booking Madness', 25, '2026-12-01', '2026-12-10', 'Active'),
(14, 'Christmas Magic & Winter Getaways', 20, '2026-12-15', '2026-12-26', 'Active'),
(15, 'New Year Countdown Gala Sale', 22, '2026-12-27', '2027-01-05', 'Active'),
(16, 'International Women Day Tribute', 15, '2026-03-01', '2026-03-10', 'Active'),
(17, 'Mekong Fruit Harvest & Floating Market Sale', 10, '2026-05-15', '2026-07-15', 'Active'),
(18, 'Da Lat Flower Festival Extravaganza', 15, '2026-11-01', '2026-12-15', 'Active'),
(19, 'End-of-Year Corporate Holiday Package', 12, '2026-11-01', '2026-12-31', 'Active'),
(20, 'Year-Round Family Discovery Discount', 8, '2026-01-01', '2026-12-31', 'Active');
SET IDENTITY_INSERT Promotion OFF;
GO

-- ============================================================================
-- 8. INSERT TOUR PROMOTIONS (Linking All Active Promotions to Tours)
-- ============================================================================
INSERT INTO TourPromotion (promotion_id, tour_id) VALUES
-- Promotion 1: Tet Grand Lunar New Year Festival
(1, 1), (1, 2), (1, 8), (1, 9), (1, 20),
-- Promotion 2: Spring Flower & Pilgrimage Season
(2, 2), (2, 4), (2, 9), (2, 11),
-- Promotion 3: Hung Kings Ancestor Commemoration Day
(3, 3), (3, 4), (3, 9),
-- Promotion 4: Reunification & Labor Day Super Sale
(4, 1), (4, 7), (4, 10), (4, 14), (4, 18),
-- Promotion 5: Summer Sun & Beach Vacation Bash
(5, 1), (5, 6), (5, 7), (5, 10), (5, 14), (5, 17),
-- Promotion 6: Youth & Student Summer Break Promo
(6, 3), (6, 5), (6, 6), (6, 10), (6, 16),
-- Promotion 7: Vietnam National Day Grand Celebration
(7, 2), (7, 5), (7, 9), (7, 11), (7, 18),
-- Promotion 8: Mid-Autumn Lantern & Mooncake Festival
(8, 3), (8, 8), (8, 15),
-- Promotion 9: Golden Autumn Leaf & Rice Harvest Promo
(9, 2), (9, 5), (9, 11), (9, 20),
-- Promotion 10: Vietnamese Women Day Special
(10, 7), (10, 8), (10, 11), (10, 19),
-- Promotion 11: Teachers Day Heritage Honor Promo
(11, 4), (11, 8), (11, 9), (11, 12),
-- Promotion 12: Black Friday Super Travel Deals
(12, 1), (12, 14), (12, 18), (12, 19), (12, 20),
-- Promotion 13: Cyber Week Booking Madness
(13, 5), (13, 7), (13, 12), (13, 19),
-- Promotion 14: Christmas Magic & Winter Getaways
(14, 2), (14, 11), (14, 14), (14, 19), (14, 20),
-- Promotion 15: New Year Countdown Gala Sale
(15, 1), (15, 7), (15, 14), (15, 18), (15, 20),
-- Promotion 16: International Women Day Tribute
(16, 7), (16, 11), (16, 14), (16, 19),
-- Promotion 17: Mekong Fruit Harvest & Floating Market Sale
(17, 13), (17, 15), (17, 16),
-- Promotion 18: Da Lat Flower Festival Extravaganza
(18, 2), (18, 11),
-- Promotion 19: End-of-Year Corporate Holiday Package
(19, 1), (19, 7), (19, 13), (19, 18), (19, 19),
-- Promotion 20: Year-Round Family Discovery Discount
(20, 3), (20, 4), (20, 8), (20, 13), (20, 15), (20, 17);
GO

-- ============================================================================
-- 9. INSERT VOUCHERS (20 Holiday & Festival Vouchers with explicit IDs)
-- Rules: Code >= 6 chars, UPPERCASE, minOrder <= maxDiscount, status = 'Active'
-- ============================================================================
SET IDENTITY_INSERT Voucher ON;
INSERT INTO Voucher (voucher_id, voucher_code, discount_percent, minimum_order_value, max_discount_amount, quantity, start_date, end_date, status) VALUES
(1, 'TET2026', 15.00, 1000000.00, 2000000.00, 100, '2026-01-15', '2026-02-28', 'Active'),
(2, 'VALENTINE', 12.00, 800000.00, 1500000.00, 80, '2026-02-01', '2026-02-20', 'Active'),
(3, 'WOMEN83', 10.00, 500000.00, 1000000.00, 150, '2026-03-01', '2026-03-15', 'Active'),
(4, 'HUNGKING', 15.00, 1000000.00, 1800000.00, 90, '2026-04-01', '2026-04-20', 'Active'),
(5, 'LIBERATION', 20.00, 2000000.00, 3000000.00, 120, '2026-04-20', '2026-05-10', 'Active'),
(6, 'SUMMERFEST', 10.00, 600000.00, 1200000.00, 200, '2026-05-15', '2026-06-30', 'Active'),
(7, 'CHILDREN61', 12.00, 800000.00, 1500000.00, 100, '2026-05-25', '2026-06-10', 'Active'),
(8, 'SEAFEST2026', 15.00, 1200000.00, 2000000.00, 75, '2026-06-01', '2026-07-15', 'Active'),
(9, 'MEKONGFEST', 10.00, 500000.00, 1000000.00, 110, '2026-06-15', '2026-07-31', 'Active'),
(10, 'NATDAY29', 20.00, 2000000.00, 3000000.00, 100, '2026-08-20', '2026-09-10', 'Active'),
(11, 'MIDAUTUMN', 10.00, 500000.00, 1000000.00, 130, '2026-09-01', '2026-09-30', 'Active'),
(12, 'WOMEN2010', 18.00, 1500000.00, 2500000.00, 85, '2026-10-10', '2026-10-25', 'Active'),
(13, 'HALLOWEEN', 12.00, 800000.00, 1600000.00, 70, '2026-10-20', '2026-11-05', 'Active'),
(14, 'TEACHER20', 15.00, 1000000.00, 2000000.00, 90, '2026-11-10', '2026-11-25', 'Active'),
(15, 'BLACKFRIDAY', 25.00, 3000000.00, 5000000.00, 50, '2026-11-20', '2026-11-30', 'Active'),
(16, 'FLOWERFEST', 15.00, 1200000.00, 2200000.00, 80, '2026-12-01', '2026-12-20', 'Active'),
(17, 'XMAS2026', 20.00, 2000000.00, 3500000.00, 100, '2026-12-15', '2026-12-26', 'Active'),
(18, 'NEWYEAR27', 22.00, 2500000.00, 4000000.00, 60, '2026-12-25', '2027-01-05', 'Active'),
(19, 'LANTERNFEST', 10.00, 500000.00, 1000000.00, 140, '2026-01-01', '2026-12-31', 'Active'),
(20, 'ANNIVERSARY', 30.00, 4000000.00, 6000000.00, 30, '2026-01-01', '2026-12-31', 'Active');
SET IDENTITY_INSERT Voucher OFF;
GO

-- Ensure Customer 5 (nguyenduy) exists
IF NOT EXISTS (SELECT 1 FROM Customer WHERE username = 'nguyenduy')
BEGIN
    SET IDENTITY_INSERT Customer ON;
    INSERT INTO Customer (customer_id, username, password_hash, email, full_name, phone, status)
    VALUES (5, 'nguyenduy', 'e10adc3949ba59abbe56e057f20f883e', 'nguyenduy.customer@gmail.com', 'Nguyen Van Duy', '0945678901', 'Active');
    SET IDENTITY_INSERT Customer OFF;
END
GO

-- ============================================================================
-- 10. INSERT BOOKINGS (Explicit IDs referencing Customer ID 3, 4 & 5)
-- Customer 3: minhpq, Customer 4: customer_02 (Alex Jones), Customer 5: nguyenduy (Nguyen Van Duy)
-- ============================================================================
SET IDENTITY_INSERT Booking ON;
INSERT INTO Booking (booking_id, customer_id, schedule_id, booking_date, number_of_people, contact_name, contact_phone, total_price, deposit_amount, status) VALUES
(1, 3, 1, '2026-06-01 10:30:00', 2, 'Pham Quoc Minh', '0923456789', 7000000.00, 2100000.00, 'Completed'),
(2, 3, 3, '2026-05-20 09:15:00', 2, 'Pham Quoc Minh', '0923456789', 5600000.00, 1680000.00, 'Completed'),
(3, 3, 11, '2026-06-05 14:00:00', 2, 'Pham Quoc Minh', '0923456789', 4200000.00, 1260000.00, 'Completed'),
(4, 3, 16, '2026-06-10 11:45:00', 2, 'Pham Quoc Minh', '0923456789', 5300000.00, 1590000.00, 'Completed'),
(5, 3, 25, '2026-06-18 16:30:00', 2, 'Pham Quoc Minh', '0923456789', 13600000.00, 4080000.00, 'Completed'),
(6, 3, 27, '2026-07-10 09:00:00', 2, 'Pham Quoc Minh', '0923456789', 19000000.00, 5700000.00, 'Confirmed'),
(7, 4, 5, '2026-06-02 15:20:00', 2, 'Alex Jones', '0934567890', 1300000.00, 390000.00, 'Completed'),
(8, 3, 7, '2026-06-20 08:30:00', 2, 'Pham Quoc Minh', '0923456789', 1700000.00, 510000.00, 'Completed'),
(9, 3, 10, '2026-06-25 11:00:00', 2, 'Pham Quoc Minh', '0923456789', 3900000.00, 1170000.00, 'Completed'),

-- Unreviewed Past Bookings for minhpq (To demo Writing a New Review!)
(10, 3, 8, '2026-06-01 09:00:00', 2, 'Pham Quoc Minh', '0923456789', 8400000.00, 2520000.00, 'Completed'),
(11, 3, 12, '2026-06-05 10:30:00', 2, 'Pham Quoc Minh', '0923456789', 4200000.00, 1260000.00, 'Completed'),
(12, 3, 18, '2026-06-15 15:00:00', 2, 'Pham Quoc Minh', '0923456789', 6200000.00, 1860000.00, 'Completed'),

-- Completed Bookings for nguyenduy (Customer 5)
(13, 5, 1, '2026-06-02 09:00:00', 2, 'Nguyen Van Duy', '0945678901', 7000000.00, 2100000.00, 'Completed'),
(14, 5, 3, '2026-05-22 10:00:00', 2, 'Nguyen Van Duy', '0945678901', 5600000.00, 1680000.00, 'Completed'),
(15, 5, 16, '2026-06-12 14:00:00', 2, 'Nguyen Van Duy', '0945678901', 5300000.00, 1590000.00, 'Completed'),
(16, 5, 11, '2026-06-08 11:00:00', 2, 'Nguyen Van Duy', '0945678901', 4200000.00, 1260000.00, 'Completed'),
(17, 5, 20, '2026-07-01 08:30:00', 2, 'Nguyen Van Duy', '0945678901', 9800000.00, 2940000.00, 'Completed'),

-- Unreviewed Past Bookings for nguyenduy (To demo Writing a New Review!)
(18, 5, 5, '2026-06-03 16:00:00', 2, 'Nguyen Van Duy', '0945678901', 1300000.00, 390000.00, 'Completed'),
(19, 5, 15, '2026-06-14 13:00:00', 2, 'Nguyen Van Duy', '0945678901', 1900000.00, 570000.00, 'Completed'),

-- Additional Bookings for customer_02 (Alex Jones - Customer 4)
(20, 4, 25, '2026-06-18 17:00:00', 2, 'Alex Jones', '0934567890', 13600000.00, 4080000.00, 'Completed'),
(21, 4, 10, '2026-06-20 11:30:00', 2, 'Alex Jones', '0934567890', 3900000.00, 1170000.00, 'Completed'),
(22, 4, 18, '2026-06-22 15:00:00', 2, 'Alex Jones', '0934567890', 6200000.00, 1860000.00, 'Completed'),
(23, 4, 1, '2026-06-01 11:00:00', 2, 'Alex Jones', '0934567890', 7000000.00, 2100000.00, 'Completed');
SET IDENTITY_INSERT Booking OFF;
GO

-- ============================================================================
-- 11. INSERT PAYMENTS (Explicit IDs)
-- ============================================================================
SET IDENTITY_INSERT Payment ON;
INSERT INTO Payment (payment_id, booking_id, amount, payment_type, payment_method, payment_status, transaction_code, payment_date) VALUES
(1, 1, 7000000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260601001', '2026-06-01 10:35:00'),
(2, 2, 5600000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260520002', '2026-05-20 09:20:00'),
(3, 3, 4200000.00, 'Full', 'Bank Transfer', 'Completed', 'BANK20260605003', '2026-06-05 14:10:00'),
(4, 4, 5300000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260610004', '2026-06-10 11:50:00'),
(5, 5, 13600000.00, 'Full', 'Credit Card', 'Completed', 'CARD20260618005', '2026-06-18 16:35:00'),
(6, 6, 5700000.00, 'Deposit', 'Bank Transfer', 'Completed', 'BANK20260710999', '2026-07-10 09:15:00'),
(7, 7, 1300000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260602007', '2026-06-02 15:25:00'),
(8, 8, 1700000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260620008', '2026-06-20 08:35:00'),
(9, 9, 3900000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260625009', '2026-06-25 11:05:00'),
(10, 10, 8400000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260601010', '2026-06-01 09:05:00'),
(11, 11, 4200000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260605011', '2026-06-05 10:35:00'),
(12, 12, 6200000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260615012', '2026-06-15 15:05:00'),
(13, 13, 7000000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260602013', '2026-06-02 09:05:00'),
(14, 14, 5600000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260522014', '2026-05-22 10:05:00'),
(15, 15, 5300000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260612015', '2026-06-12 14:05:00'),
(16, 16, 4200000.00, 'Full', 'Bank Transfer', 'Completed', 'BANK20260608016', '2026-06-08 11:05:00'),
(17, 17, 9800000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260701017', '2026-07-01 08:35:00'),
(18, 18, 1300000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260603018', '2026-06-03 16:05:00'),
(19, 19, 1900000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260614019', '2026-06-14 13:05:00'),
(20, 20, 13600000.00, 'Full', 'Credit Card', 'Completed', 'CARD20260618020', '2026-06-18 17:05:00'),
(21, 21, 3900000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260620021', '2026-06-20 11:35:00'),
(22, 22, 6200000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260622022', '2026-06-22 15:05:00'),
(23, 23, 7000000.00, 'Full', 'VNPay', 'Completed', 'VNPAY20260601023', '2026-06-01 11:05:00');
SET IDENTITY_INSERT Payment OFF;
GO

-- ============================================================================
-- 12. INSERT BOOKING VOUCHERS
-- ============================================================================
INSERT INTO BookingVoucher (booking_id, voucher_id) VALUES
(1, 10),
(2, 5),
(5, 15),
(6, 20),
(13, 8),
(17, 12);
GO

-- ============================================================================
-- 13. INSERT REVIEWS (Approved & Pending Reviews for Customer minhpq, customer_02 & nguyenduy)
-- ============================================================================
SET IDENTITY_INSERT Review ON;
INSERT INTO Review (review_id, booking_id, customer_id, rating, comment, staff_response, response_date, status, created_at) VALUES
-- Approved Reviews (minhpq - Customer 3)
(1, 1, 3, 5, 'The 5-star Ha Long luxury cruise was an unforgettable experience! Friendly crew staff, fresh seafood buffet, and breathtaking Sung Sot cave views.', 'Thank you Mr. Minh! We are glad you enjoyed the Ha Long luxury cruise experience with T-Booking.', '2026-06-12 09:00:00', 'Approved', '2026-06-11 18:30:00'),
(2, 2, 3, 5, 'Sapa Fansipan peak trip was exceptional! The cable car ride above the cloud sea was breathtaking. Homestay dinner with ethnic locals was super cozy.', 'Dear Minh, thank you for sharing your awesome Sapa adventure with us! Hope to welcome you on another mountain trek soon.', '2026-06-04 10:15:00', 'Approved', '2026-06-03 20:10:00'),
(3, 3, 3, 5, 'Visiting Ba Na Hills and walking across the iconic Golden Hands Bridge in the morning mist was a highlight of my holiday. Highly recommended!', 'Thank you Mr. Minh! The Golden Bridge is indeed magical in the morning. We look forward to serving you again!', '2026-06-17 11:30:00', 'Approved', '2026-06-16 19:45:00'),
(4, 4, 3, 4, 'Beautiful cool weather in Da Lat. The flower gardens and pine forests were very scenic and peaceful. Great tour organization by T-Booking!', 'We are thrilled that you enjoyed the cool breeze and flower fields of Da Lat, Mr. Minh! Thank you for choosing T-Booking.', '2026-06-23 14:00:00', 'Approved', '2026-06-22 17:20:00'),
(5, 5, 3, 5, 'Fantastic Bangkok trip! The Grand Palace was magnificent and Chao Phraya river dinner cruise was top notch. Excellent support from tour guide.', 'Thank you so much Minh! We are delighted your Thailand vacation went smoothly and comfortably.', '2026-06-29 09:30:00', 'Approved', '2026-06-28 21:00:00'),

-- Approved Reviews (Alex Jones - Customer 4)
(6, 7, 4, 5, 'The Hanoi street food walk was amazing! Egg coffee at Cafe Giang and authentic Bun Cha were delicious. Highly recommend!', 'Thank you Alex! Egg coffee is a must-try in Hanoi. Safe travels on your next journey!', '2026-06-06 10:00:00', 'Approved', '2026-06-05 19:00:00'),
(14, 20, 4, 5, 'Fantastic Thailand trip! Shopping at Chatuchak market and the Grand Palace tour were incredible. Everything was well organized by T-Booking.', 'Thank you Alex! Glad you enjoyed your Bangkok shopping and cultural adventure!', '2026-06-29 10:00:00', 'Approved', '2026-06-28 21:30:00'),
(15, 21, 4, 5, 'Lan Ha Bay kayaking was spectacular! Calm turquoise waters, hidden lagoons, and a lovely lunch on Cat Ba island. Will book again!', 'Dear Alex, thank you for sharing your Lan Ha Bay kayaking feedback! Hope to see you back soon.', '2026-06-27 09:15:00', 'Approved', '2026-06-26 18:30:00'),

-- Pending Reviews for minhpq (Submitted by customer, waiting for Staff approval)
(7, 8, 3, 5, 'Trang An sampan boat trip in Ninh Binh was extremely peaceful and scenic! Climbing Mua Cave dragon peak was challenging but totally worth the view.', NULL, NULL, 'Pending', '2026-07-25 15:30:00'),
(8, 9, 3, 4, 'Great kayaking experience in Lan Ha Bay! Crystal clear waters and friendly local guides. Cat Ba national park trek was also very refreshing.', NULL, NULL, 'Pending', '2026-07-26 10:15:00'),

-- Pending Review for Alex Jones (Customer 4)
(16, 22, 4, 5, 'Exploring Paradise Cave and Dark Cave in Phong Nha was an absolute thrill! The limestone rock formations were unbelievable.', NULL, NULL, 'Pending', '2026-07-26 14:20:00'),

-- Approved Reviews for nguyenduy (Customer 5)
(9, 13, 5, 5, 'Exceptional overnight cruise in Ha Long Bay! The kayaking through Luon Cave and sunset party on the top deck were absolute highlights.', 'Thank you Mr. Duy! We are delighted to hear you had a wonderful sunset cruise in Ha Long Bay.', '2026-06-12 09:30:00', 'Approved', '2026-06-11 19:00:00'),
(10, 14, 5, 5, 'Unforgettable trekking experience in Sapa! Cat Cat village was culturally rich and riding the cable car to Fansipan summit above clouds was mesmerizing.', 'Dear Mr. Duy, thank you for choosing T-Booking for your Sapa journey. We hope to accompany you on more mountain adventures!', '2026-06-04 10:45:00', 'Approved', '2026-06-03 20:30:00'),
(11, 15, 5, 5, 'Da Lat was super serene and romantic. Pine forests, strawberry gardens, and cool air made it a perfect vacation spot. Seamless service!', 'Thank you Mr. Duy! Da Lat is always a wonderful retreat. Looking forward to welcoming you back!', '2026-06-23 14:30:00', 'Approved', '2026-06-22 17:45:00'),

-- Pending Reviews for nguyenduy (Submitted by customer, waiting for Staff approval)
(12, 16, 5, 5, 'Awesome day trip to Ba Na Hills! The Golden Hands Bridge was stunning and French Village felt like a mini European vacation.', NULL, NULL, 'Pending', '2026-07-25 16:00:00'),
(13, 17, 5, 4, 'Beautiful tropical getaway in Phu Quoc! Grand World canal and Hon Thom cable car were top-tier. Great hotel arrangements.', NULL, NULL, 'Pending', '2026-07-26 11:00:00');
SET IDENTITY_INSERT Review OFF;
GO

-- ============================================================================
-- 14. INSERT WISHLIST
-- ============================================================================
INSERT INTO Wishlist (customer_id, tour_id, added_at) VALUES
(3, 4, GETDATE()),
(3, 5, GETDATE()),
(3, 14, GETDATE()),
(3, 20, GETDATE()),
(4, 1, GETDATE()),
(4, 19, GETDATE()),
(5, 6, GETDATE()),
(5, 12, GETDATE()),
(5, 18, GETDATE());
GO

-- ============================================================================
-- 15. INSERT BOOKING STATUS HISTORY (Explicit IDs)
-- ============================================================================
SET IDENTITY_INSERT BookingStatusHistory ON;
INSERT INTO BookingStatusHistory (history_id, booking_id, status, changed_by, changed_at, note) VALUES
(1, 1, 'Pending', 3, '2026-06-01 10:30:00', 'Booking created by customer'),
(2, 1, 'Completed', 1, '2026-06-11 17:00:00', 'Tour finished successfully. Status updated to Completed.'),
(3, 2, 'Pending', 3, '2026-05-20 09:15:00', 'Booking created by customer'),
(4, 2, 'Completed', 1, '2026-06-03 18:00:00', 'Tour finished successfully.'),
(5, 3, 'Pending', 3, '2026-06-05 14:00:00', 'Booking created by customer'),
(6, 3, 'Completed', 1, '2026-06-16 18:00:00', 'Tour finished successfully.'),
(7, 4, 'Completed', 1, '2026-06-22 18:00:00', 'Tour finished successfully.'),
(8, 5, 'Completed', 1, '2026-06-28 18:00:00', 'International tour completed.'),
(9, 6, 'Confirmed', 1, '2026-07-10 09:20:00', 'Deposit verified by Admin.'),
(10, 7, 'Completed', 1, '2026-06-05 18:00:00', 'Tour completed.'),
(11, 8, 'Completed', 1, '2026-06-20 18:00:00', 'Tour completed.'),
(12, 9, 'Completed', 1, '2026-06-26 18:00:00', 'Tour completed.'),
(13, 10, 'Completed', 1, '2026-06-13 18:00:00', 'Ha Giang Motorbike tour completed.'),
(14, 11, 'Completed', 1, '2026-06-16 18:00:00', 'Ba Na Hills tour completed.'),
(15, 12, 'Completed', 1, '2026-06-29 18:00:00', 'Phong Nha Paradise cave tour completed.'),
(16, 13, 'Completed', 1, '2026-06-11 17:30:00', 'Ha Long Cruise tour completed.'),
(17, 14, 'Completed', 1, '2026-06-03 18:30:00', 'Sapa Fansipan tour completed.'),
(18, 15, 'Completed', 1, '2026-06-22 18:30:00', 'Da Lat tour completed.'),
(19, 16, 'Completed', 1, '2026-06-16 18:30:00', 'Ba Na Hills tour completed.'),
(20, 17, 'Completed', 1, '2026-07-03 18:00:00', 'Phu Quoc tour completed.'),
(21, 18, 'Completed', 1, '2026-06-05 18:30:00', 'Hanoi Foodie tour completed.'),
(22, 19, 'Completed', 1, '2026-06-16 18:30:00', 'Nha Trang Coral Reef tour completed.'),
(23, 20, 'Completed', 1, '2026-06-28 18:30:00', 'Bangkok tour completed.'),
(24, 21, 'Completed', 1, '2026-06-26 18:30:00', 'Cat Ba tour completed.'),
(25, 22, 'Completed', 1, '2026-06-29 18:30:00', 'Phong Nha tour completed.'),
(26, 23, 'Completed', 1, '2026-06-11 18:00:00', 'Ha Long cruise completed.');
SET IDENTITY_INSERT BookingStatusHistory OFF;
GO

-- ============================================================================
-- 16. RESEED IDENTITIES & RE-ENABLE FOREIGN KEY CONSTRAINTS
-- ============================================================================
DBCC CHECKIDENT ('Category', RESEED, 20);
DBCC CHECKIDENT ('Destination', RESEED, 20);
DBCC CHECKIDENT ('Tour', RESEED, 20);
DBCC CHECKIDENT ('TourImage', RESEED, 20);
DBCC CHECKIDENT ('Itinerary', RESEED, 46);
DBCC CHECKIDENT ('TourSchedule', RESEED, 32);
DBCC CHECKIDENT ('Promotion', RESEED, 20);
DBCC CHECKIDENT ('Voucher', RESEED, 20);
DBCC CHECKIDENT ('Booking', RESEED, 23);
DBCC CHECKIDENT ('Payment', RESEED, 23);
DBCC CHECKIDENT ('Review', RESEED, 16);
DBCC CHECKIDENT ('BookingStatusHistory', RESEED, 26);
GO

EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO
