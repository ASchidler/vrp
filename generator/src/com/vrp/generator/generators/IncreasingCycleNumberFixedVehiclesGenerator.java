package com.vrp.generator.generators;

import com.vrp.generator.Instance;

/**
 * Created by asc on 30.09.2017.
 */
public class IncreasingCycleNumberFixedVehiclesGenerator extends BaseCycleGenerator {
    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance(22 * (size/5 + 1), true);

        for (int i = 1; i <= 5; i++) {
            inst.getVehicles().add("v" + i);
        }

        for (int i = 1; i <= size; i++) {

            generatorCycle(10, String.format("c%dx", i), inst, timeWindowed);
        }

        return inst;
    }

    @Override
    public String getName() {
        return "cycleNumberVehicle";
    }
}
