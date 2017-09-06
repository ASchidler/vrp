package com.vrp.generator.generators;

import com.vrp.generator.*;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by asc on 29.08.2017.
 */
public abstract class BaseCycleGenerator implements IGenerator {
    protected void generatorCycle(int cycleSize, String cycleName, Instance instance, boolean timeWindowed) {
        Node lastNode = instance.getBaseNode();

        for(int i=1; i <= cycleSize; i++) {
            Node n = null;

            if (timeWindowed) {
                List<Integer> windows = new LinkedList<>();
                windows.add(i*2);
                n = new TimeWindowNode(windows, cycleName + i, 1);
            } else {
                n = new Node(cycleName + i, 1);
            }

            instance.getNodes().add(n);
            Edge e = new Edge(1,1, lastNode, n);
            instance.getEdges().add(e);
            lastNode = n;
        }

        instance.getEdges().add(new Edge(1,1, lastNode, instance.getBaseNode()));
    }
}
