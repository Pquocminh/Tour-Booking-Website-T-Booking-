package model;

import java.sql.Timestamp;
import java.util.List;

public class Tour {
    private int tourId;
    private int categoryId;
    private int createdBy;
    private int destinationId;
    private String tourName;
    private String departureLocation;
    private String description;
    private int durationDays;
    private double basePrice;
    private String status;
    private Timestamp createdAt;

    // Associated objects
    private Category category;
    private Destination destination;
    private String thumbnailUrl;
    
    // Lists for detailed view
    private List<String> imageUrls;
    private List<Itinerary> itineraries;
    private List<TourSchedule> schedules;

    public Tour() {
    }

    public Tour(int tourId, int categoryId, int createdBy, int destinationId, String tourName, 
                String departureLocation, String description, int durationDays, double basePrice, 
                String status, Timestamp createdAt) {
        this.tourId = tourId;
        this.categoryId = categoryId;
        this.createdBy = createdBy;
        this.destinationId = destinationId;
        this.tourName = tourName;
        this.departureLocation = departureLocation;
        this.description = description;
        this.durationDays = durationDays;
        this.basePrice = basePrice;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public int getDestinationId() {
        return destinationId;
    }

    public void setDestinationId(int destinationId) {
        this.destinationId = destinationId;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public String getDepartureLocation() {
        return departureLocation;
    }

    public void setDepartureLocation(String departureLocation) {
        this.departureLocation = departureLocation;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDurationDays() {
        return durationDays;
    }

    public void setDurationDays(int durationDays) {
        this.durationDays = durationDays;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Destination getDestination() {
        return destination;
    }

    public void setDestination(Destination destination) {
        this.destination = destination;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public List<String> getImageUrls() {
        return imageUrls;
    }

    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }

    public List<Itinerary> getItineraries() {
        return itineraries;
    }

    public void setItineraries(List<Itinerary> itineraries) {
        this.itineraries = itineraries;
    }

    public List<TourSchedule> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<TourSchedule> schedules) {
        this.schedules = schedules;
    }
}
