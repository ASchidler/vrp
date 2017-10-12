package com.vrp.generator.generators;

import com.vrp.generator.*;

import java.util.LinkedList;
import java.util.List;
import java.util.Random;

/**
 * Created by asc on 29.08.2017.
 */
public abstract class BaseConnectedGenerator implements IGenerator {

    protected void generate(int size, boolean timeWindowed, int numVehicles, Instance inst, boolean randomizeCosts) {
        //Doesnt make sense with less than 3 nodes
        size += 2;
        Random rand = new Random();

        for(int i=1; i <= numVehicles; i++) {
            inst.getVehicles().add("v"+i);
        }

        List<Integer> timeWindows = new LinkedList<>();
        for(int i=1; i < size * 3; i++) {
            timeWindows.add(i);
        }

        for(int i=1; i <= size; i++) {
            if (timeWindowed)
                inst.getNodes().add(new TimeWindowNode(timeWindows, "n"+i, 1));
            else
                inst.getNodes().add(new Node("n"+i, 1));
        }

        for(int outer=0; outer < inst.getNodes().size(); outer++) {
            for(int inner=outer + 1; inner < inst.getNodes().size(); inner++) {
                Node outerNode = inst.getNodes().get(outer);
                Node innerNode = inst.getNodes().get(inner);
                int cost = randomizeCosts ? rand.nextInt(50) + 1 : 1;
                inst.getEdges().add(new Edge(1,1,outerNode, innerNode));
            }
        }
    }

}
