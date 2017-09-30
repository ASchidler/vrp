package com.vrp.generator.generators;

import com.vrp.generator.*;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

/**
 * Created by asc on 30.09.2017.
 */
public abstract class BaseConnectednessGenerator implements IGenerator {
    protected void generate(int numNodes, int connectedness, int numVehicles, Instance inst, boolean timeWindowed) {
        Random rand = new Random();

        for(int i=1; i <= numNodes; i++) {
            inst.getNodes().add(new Node("n"+i,1));
        }

        for(int i=1; i <= numVehicles; i++) {
            inst.getVehicles().add("v"+i);
        }

        //connect all nodes (this includes the base node)
        for(int i=0; i < inst.getNodes().size(); i++) {
            Node firstNode = inst.getNodes().get(i);
            Node secondNode = inst.getNodes().get(nextRand(rand, inst.getNodes().size(), i));
            inst.getEdges().add(new Edge(1,1,firstNode, secondNode));
        }

        //Achieve connectedness
        int maxEdges = numNodes * (numNodes-1);
        while(inst.getEdges().size() < maxEdges) {
            int target = rand.nextInt(inst.getNodes().size());
            Node firstNode = inst.getNodes().get(target);
            Node secondNode = inst.getNodes().get(nextRand(rand,inst.getNodes().size(), target));
            inst.getEdges().add(new Edge(1,1,firstNode, secondNode));

            int numEdge = inst.getEdges().size();
            double ratio = ((double)maxEdges) / ((double)numEdge);

            if (ratio * 100.0d >= connectedness)
                break;
        }


        HashSet<Node> connectedNodes = new HashSet<Node>();
        do {
            connectedNodes.clear();
            CheckConnectedness(inst, inst.getBaseNode(), connectedNodes);

            //Achieve a connected graph
            for (Node n : inst.getNodes()) {
                if (!connectedNodes.contains(n)) {
                    inst.getEdges().add(new Edge(1, 2, n, inst.getBaseNode()));
                    break;
                }
            }
        } while(connectedNodes.size() != inst.getNodes().size());
    }

    private int nextRand(Random rand, int bound, int exclude) {
        int result = rand.nextInt(bound);
        while (result == exclude)
            result = rand.nextInt(bound);
        return result;
    }

    private void CheckConnectedness(Instance inst, Node start, HashSet<Node> connectedNodes) {
        if (connectedNodes.contains(start))
            return;

        connectedNodes.add(start);
        for (Edge e: inst.getEdges()) {
            if (e.getStartNode() == start) {
                CheckConnectedness(inst, e.getEndNode(), connectedNodes);
            } else if (e.getEndNode() == start) {
                CheckConnectedness(inst, e.getStartNode(), connectedNodes);
            }
        }
    }
}
