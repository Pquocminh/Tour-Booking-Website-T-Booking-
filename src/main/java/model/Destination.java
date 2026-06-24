package model;

public class Destination {
    private int destinationId;
    private String destinationName;
    private String province;
    private String region;
    private String description;
    private String imageUrl;

    public Destination() {
    }

    public Destination(int destinationId, String destinationName, String province, String region, String description, String imageUrl) {
        this.destinationId = destinationId;
        this.destinationName = destinationName;
        this.province = province;
        this.region = region;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    public int getDestinationId() {
        return destinationId;
    }

    public void setDestinationId(int destinationId) {
        this.destinationId = destinationId;
    }

    public String getDestinationName() {
        return destinationName;
    }

    public void setDestinationName(String destinationName) {
        this.destinationName = destinationName;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
