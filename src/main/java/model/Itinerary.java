package model;

public class Itinerary {
    private int itineraryId;
    private int tourId;
    private int dayNumber;
    private String title;
    private String description;

    public Itinerary() {
    }

    public Itinerary(int itineraryId, int tourId, int dayNumber, String title, String description) {
        this.itineraryId = itineraryId;
        this.tourId = tourId;
        this.dayNumber = dayNumber;
        this.title = title;
        this.description = description;
    }

    public int getItineraryId() {
        return itineraryId;
    }

    public void setItineraryId(int itineraryId) {
        this.itineraryId = itineraryId;
    }

    public int getTourId() {
        return tourId;
    }

    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    public int getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
