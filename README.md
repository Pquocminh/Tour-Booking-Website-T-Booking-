# Tour-Booking-Website-T-Booking-
cấu trúc

TBooking
│
├── src
│   └── main
│
│       ├── java
│       │   └── com.tbooking
│       │
│       │       ├── controller
│       │       │
│       │       │   ├── auth
│       │       │   │   ├── LoginServlet.java
│       │       │   │   ├── LogoutServlet.java
│       │       │   │   ├── RegisterServlet.java
│       │       │   │   └── ForgotPasswordServlet.java
│       │       │   │
│       │       │   ├── guest
│       │       │   │   ├── HomeServlet.java
│       │       │   │   ├── TourListServlet.java
│       │       │   │   ├── TourDetailServlet.java
│       │       │   │   ├── PromotionServlet.java
│       │       │   │   ├── FeedbackServlet.java
│       │       │   │   ├── SearchTourServlet.java
│       │       │   │   └── FilterTourServlet.java
│       │       │   │
│       │       │   ├── customer
│       │       │   │   ├── ProfileServlet.java
│       │       │   │   ├── BookingHistoryServlet.java
│       │       │   │   ├── BookingStatusServlet.java
│       │       │   │   ├── CancelBookingServlet.java
│       │       │   │   ├── WishlistServlet.java
│       │       │   │   ├── BillServlet.java
│       │       │   │   ├── VoucherServlet.java
│       │       │   │   ├── RatingServlet.java
│       │       │   │   └── ReviewServlet.java
│       │       │   │
│       │       │   ├── staff
│       │       │   │   ├── TourManagementServlet.java
│       │       │   │   ├── BookingManagementServlet.java
│       │       │   │   ├── CustomerManagementServlet.java
│       │       │   │   ├── PromotionManagementServlet.java
│       │       │   │   └── VoucherManagementServlet.java
│       │       │   │
│       │       │   └── admin
│       │       │       ├── StaffManagementServlet.java
│       │       │       ├── FeedbackManagementServlet.java
│       │       │       └── ReportManagementServlet.java
│       │       │
│       │       ├── dao
│       │       │   ├── UserDAO.java
│       │       │   ├── TourDAO.java
│       │       │   ├── BookingDAO.java
│       │       │   ├── WishlistDAO.java
│       │       │   ├── ReviewDAO.java
│       │       │   ├── PromotionDAO.java
│       │       │   ├── VoucherDAO.java
│       │       │   ├── BillDAO.java
│       │       │   ├── FeedbackDAO.java
│       │       │   └── ReportDAO.java
│       │       │
│       │       ├── model
│       │       │   ├── User.java
│       │       │   ├── Role.java
│       │       │   ├── Tour.java
│       │       │   ├── Booking.java
│       │       │   ├── Wishlist.java
│       │       │   ├── Review.java
│       │       │   ├── Promotion.java
│       │       │   ├── Voucher.java
│       │       │   ├── Bill.java
│       │       │   ├── Feedback.java
│       │       │   └── Report.java
│       │       │
│       │       ├── service
│       │       │   ├── AuthService.java
│       │       │   ├── TourService.java
│       │       │   ├── BookingService.java
│       │       │   ├── WishlistService.java
│       │       │   ├── ReviewService.java
│       │       │   ├── PromotionService.java
│       │       │   ├── VoucherService.java
│       │       │   └── ReportService.java
│       │       │
│       │       └── utils
│       │           ├── DBContext.java
│       │           ├── Validation.java
│       │           ├── DateUtil.java
│       │           ├── Constants.java
│       │           └── SecurityUtil.java
│       │
│       ├── resources
│       │   └── META-INF
│       │       └── persistence.xml
│       │
│       └── webapp
│
│           ├── assets
│           │   ├── css
│           │   ├── js
│           │   └── images
│           │
│           ├── index.html
│           │
│           └── WEB-INF
│               │
│               ├── web.xml
│               │
│               └── views
│                   │
│                   ├── auth
│                   │   ├── login.jsp
│                   │   ├── register.jsp
│                   │   └── forgot-password.jsp
│                   │
│                   ├── guest
│                   │   ├── home.jsp
│                   │   ├── tours.jsp
│                   │   ├── tour-detail.jsp
│                   │   ├── promotions.jsp
│                   │   └── feedbacks.jsp
│                   │
│                   ├── customer
│                   │   ├── profile.jsp
│                   │   ├── booking-history.jsp
│                   │   ├── booking-status.jsp
│                   │   ├── wishlist.jsp
│                   │   ├── bills.jsp
│                   │   └── reviews.jsp
│                   │
│                   ├── staff
│                   │   ├── tour-management.jsp
│                   │   ├── booking-management.jsp
│                   │   ├── customer-management.jsp
│                   │   ├── promotion-management.jsp
│                   │   └── voucher-management.jsp
│                   │
│                   └── admin
│                       ├── staff-management.jsp
│                       ├── feedback-management.jsp
│                       └── report-management.jsp
│
├── database
│   ├── TBooking.sql
│   └── SampleData.sql
│
├── docs
│   ├── RDS.docx
│   ├── SDS.docx
│   ├── ERD.png
│   └── UseCaseDiagram.png
│
├── pom.xml
├── README.md
└── .gitignore
