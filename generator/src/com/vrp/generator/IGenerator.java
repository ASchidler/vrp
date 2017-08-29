package com.vrp.generator;

/**
 * Interface for instance generation
 */
public interface IGenerator {
    /**
     * Generates a VRP instance
     * @param size The size of the instance to generate. The precise meaning depends on the generator
     * @return A VRP instance
     */
    public Instance generate(int size, boolean timeWindowed);

    public String getName();
}
