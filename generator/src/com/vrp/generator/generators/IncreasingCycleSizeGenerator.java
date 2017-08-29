package com.vrp.generator.generators;

import com.vrp.generator.Instance;
import com.vrp.generator.Node;

/**
 * Created by asc on 29.08.2017.
 */
public class IncreasingCycleSizeGenerator extends BaseCycleGenerator {

    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance(size * 2 + 2, true);

        for(int i = 1; i <= 5; i++) {
            inst.getVehicles().add("v"+ i);
            generatorCycle(size, String.format("c%dx", i), inst, timeWindowed);
        }

        return inst;
    }

    @Override
    public String getName() {
        return "cycleSize";
    }
}
