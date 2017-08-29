package com.vrp.generator;

/**
 * Created by asc on 29.08.2017.
 */
public class Node {
    private String name;
    private int serviceTime;

    public Node(String name, int serviceTime) {
        this.name = name;
        this.serviceTime = serviceTime;
    }

    public String getName() {
        return name;
    }

    public int getServiceTime() {
        return serviceTime;
    }

    @Override
    public String toString() {
        return String.format("serviceTime(%s,%d).", name, serviceTime);
    }
}
