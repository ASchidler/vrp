package com.vrp.generator.generators;

import com.vrp.generator.Instance;
import com.vrp.generator.Node;

/**
 * Created by asc on 29.08.2017.
 */
public class SimpleCycleGenerator extends BaseCycleGenerator {
    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance(20 * size, true);
        inst.getVehicles().add("v");
        generatorCycle(size * 5, "n", inst, timeWindowed);

        return inst;
    }

    @Override
    public String getName() {
        return "simpleCycle";
    }
}
