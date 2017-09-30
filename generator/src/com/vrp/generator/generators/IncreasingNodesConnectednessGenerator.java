package com.vrp.generator.generators;

import com.vrp.generator.Instance;

/**
 * Created by asc on 30.09.2017.
 */
public class IncreasingNodesConnectednessGenerator extends BaseConnectednessGenerator {
    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance((size+3)*2, true);
        generate(size+2, 30, 5, inst,timeWindowed);
        return inst;
    }

    @Override
    public String getName() {
        return "connectednessNodes";
    }
}
