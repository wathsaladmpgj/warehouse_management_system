package model;
public class Staff {
    private int id;
    private int count;  //just for future usage
    private String name;
    private String role;
    private String location;

    public Staff(String name, String role, String location) {
        this.name = name;
        this.role = role;
        this.location = location;
    }


    public Staff() {
    }
    
    

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
