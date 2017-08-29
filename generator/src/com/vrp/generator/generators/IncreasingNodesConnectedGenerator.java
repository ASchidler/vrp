package com.vrp.generator.generators;

import com.vrp.generator.IGenerator;
import com.vrp.generator.Instance;

/**
 * Created by asc on 29.08.2017.
 */
public class IncreasingNodesConnectedGenerator extends BaseConnectedGenerator {


    @Override
    public Instance generate(int size, boolean timeWindowed) {
        Instance inst = new Instance((size * 3) / 5 + 3, true);
        generate(size, true, 5, inst);
        return inst;
    }

    @Override
    public String getName() {
        return "connectedNodes";
    }
}
