package com.vrp.generator.generators;

import com.vrp.generator.Instance;

/**
 * Created by asc on 29.08.2017.
 */
public class IncreasingVehiclesConnectedGenerator extends BaseConnectedGenerator {

    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance((size * 3) / size + 1, true);
        generate(30, true,size, inst);
        return inst;
    }

    @Override
    public String getName() {
        return "connectedVehicles";
    }
}
