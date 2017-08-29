package com.vrp.generator.generators;

import com.vrp.generator.*;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by asc on 29.08.2017.
 */
public class CycleGenerator implements IGenerator {
    private void generatorCycle(int cycleSize, String cycleName, Node baseNode, Instance instance, boolean timeWindowed) {
        Node lastNode = baseNode;

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
        }
    }

    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance(30, true);
        Node base = new Node("0", 0);

        for(int i = 1; i <= size; i++) {
            inst.getVehicles().add("v"+ i);
            generatorCycle(10, String.format("c%dx", i), base, inst, timeWindowed);
        }

        return inst;
    }

    @Override
    public String getName() {
        return "cycle";
    }
}
