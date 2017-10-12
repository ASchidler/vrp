package com.vrp.generator.generators;

import com.vrp.generator.Instance;

/**
 * Created by asc on 30.09.2017.
 */
public class IncreasingConnectednessGenerator extends BaseConnectednessGenerator {
    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance((21)*2, true);
        generate(20, 5 * size, 5, inst,timeWindowed);
        return inst;
    }

    @Override
    public String getName() {
        return "connectednessRatio";
    }
}
