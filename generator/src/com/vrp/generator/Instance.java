package com.vrp.generator;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by asc on 29.08.2017.
 */
public class Instance {
    public List<Node> getNodes() {
        return nodes;
    }

    public List<Edge> getEdges() {
        return edges;
    }

    private List<Node> nodes;
    private List<Edge> edges;
    private int limit;
    private boolean symmetric;
    private List<String> vehicles;
    private Node baseNode = new Node("0", 0);

    public Instance(int limit, boolean symmetric) {
        this.nodes = new LinkedList<>();
        this.getNodes().add(baseNode);
        this.edges = new LinkedList<>();
        this.limit = limit;
        this.symmetric = symmetric;
        this.vehicles = new LinkedList<>();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder(String.format("timeLimit(%d).\n", limit));
        int cnt = 1;

        //Add vehicles
        for(String v : vehicles) {
            sb.append(String.format("vehicle(%s).", v));
        }
        sb.append("\n\n");

        //Add nodes
        for(Node n : nodes) {
            sb.append(n.toString());
            if (cnt % 10 == 0)
                sb.append("\n");
            cnt++;
        }
        sb.append("\n\n");

        //Add edges
        cnt = 1;
        for(Edge e : edges) {
            sb.append(e.toString());
            cnt++;
            if (symmetric) {
                e.reverse();
                sb.append(e.toString());
                cnt++;
            }

            if (cnt % 10 == 0)
                sb.append("\n");
        }

        return sb.toString();
    }

    public List<String> getVehicles() {
        return vehicles;
    }

    public Node getBaseNode() {
        return baseNode;
    }
}
