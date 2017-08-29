package com.vrp.generator;

import java.util.List;

/**
 * Created by asc on 29.08.2017.
 */
public class TimeWindowNode extends Node {
    private List<Integer> timeWindows;

    public TimeWindowNode(List<Integer> timeWindows, String name, int serviceTime) {
        super(name, serviceTime);
        this.timeWindows = timeWindows;
    }

    public List<Integer> getTimeWindows() {
        return timeWindows;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder(super.toString());
        for(Integer i : timeWindows) {
            sb.append(String.format("available(%s,%d).", getName(), i));
        }
        sb.append("\n");

        return sb.toString();
    }
}
