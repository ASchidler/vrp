package com.vrp.generator.generators;

import com.vrp.generator.Instance;

/**
 * Created by asc on 29.08.2017.
 */
public class IncreasingNodesConnectedRandomGenerator extends BaseConnectedGenerator {


    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance((size * 3) / 5 + 3, true);
        generate(size, timeWindowed, 5, inst, true);
        return inst;
    }

    @Override
    public String getName() {
        return "connectedNodesRandom";
    }
}
