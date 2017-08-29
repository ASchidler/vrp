package com.vrp.generator;

import com.vrp.generator.generators.IncreasingCycleNumberGenerator;
import com.vrp.generator.generators.IncreasingCycleSizeGenerator;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

public class Main {

    public static void main(String[] args) throws IOException{
        List<IGenerator> generators = new LinkedList<>();
        generators.add(new IncreasingCycleNumberGenerator());
        generators.add(new IncreasingCycleSizeGenerator());
        generate(true, generators);
        generate(false, generators);

    }

    private static void generate(boolean timeWindowed, List<IGenerator> generators) throws IOException {
        String type = timeWindowed ? "vrptw" : "vrp";

        File baseDir = new File("generated");
        if (! baseDir.exists()) baseDir.mkdir();
        File subDir = new File("generated\\"+type);
        if (!subDir.exists()) subDir.mkdir();


        for(IGenerator generator : generators) {
            File generatorDir = new File(String.format("generated\\%s\\%s", type, generator.getName()));
            if (! generatorDir.exists())
                generatorDir.mkdir();

            for(int size=1; size <= 10; size++) {
                File f = new File(String.format("generated\\%s\\%s\\%s-%d.lp", type, generator.getName(), generator.getName(), size));
                if (f.exists())
                    f.delete();

                Instance inst = generator.generate(size, true);

                BufferedWriter writer = new BufferedWriter(new FileWriter(f));
                writer.write(inst.toString());
                writer.close();
            }
        }
    }
}
