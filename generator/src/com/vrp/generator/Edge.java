package com.vrp.generator;

/**
 * Created by asc on 29.08.2017.
 */
public class Edge {
    private int cost;
    private int duration;
    private Node startNode;
    private Node endNode;

    public Edge(int cost, int duration, Node startNode, Node endNode) {
        this.cost = cost;
        this.duration = duration;
        this.startNode = startNode;
        this.endNode = endNode;
    }

    public int getCost() {
        return cost;
    }

    public Node getStartNode() {
        return startNode;
    }

    public Node getEndNode() {
        return endNode;
    }

    public void reverse() {
        Node n = startNode;
        startNode = endNode;
        endNode = n;
    }

    @Override
    public String toString() {
        return String.format("cost(%s,%s,%d).", startNode.getName(), endNode.getName(), cost)
                + String.format("duration(%s,%s,%d).\n", startNode.getName(), endNode.getName(), duration);
    }

    public int getDuration() {
        return duration;
    }
}
