package com.vrp.generator.generators;

import com.vrp.generator.Instance;
import com.vrp.generator.Node;

/**
 * Created by asc on 29.08.2017.
 */
public class IncreasingCycleNumberGenerator extends BaseCycleGenerator {
    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance(30, true);

        for(int i = 1; i <= size; i++) {
            inst.getVehicles().add("v"+ i);
            generatorCycle(10, String.format("c%dx", i),inst, timeWindowed);
        }

        return inst;
    }

    @Override
    public String getName() {
        return "cycleNumber";
    }
}
