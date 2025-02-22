package com.vrp.generator.generators;

import com.vrp.generator.Instance;

/**
 * Created by asc on 29.08.2017.
 */
public class IncreasingVehiclesConnectedGenerator extends BaseConnectedGenerator {

    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance((10 * 3) / size + 3, true);
        generate(10, timeWindowed,size, inst, false);
        return inst;
    }

    @Override
    public String getName() {
        return "connectedVehicles";
    }
}
