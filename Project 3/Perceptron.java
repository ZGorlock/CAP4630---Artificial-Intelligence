/*
 * File:    Perceptron.java
 * Package: PACKAGE_NAME
 * Author:  Zachary Gill
 */

import weka.classifiers.Classifier;
import weka.core.Capabilities;
import weka.core.Instance;
import weka.core.Instances;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Perceptron implements Classifier
{
    
    private String dataFile = "";
    private int epochs = 0;
    private double learningConstant = 0.0;
    
    private List<Double> weights = new ArrayList<>();
    private int weightUpdates = 0;
    
    private final double BIAS_VALUE = 1.0;
    
    
    public Perceptron(String[] options)
    {
        dataFile = options[0];
        epochs = Integer.valueOf(options[1]);
        learningConstant = Double.valueOf(options[2]);
        
        printHeader();
    }
    
    private void printHeader()
    {
        System.out.println("University of Central Florida");
        System.out.println("CAP4630 Artificial Intelligence - Fall 2016");
        System.out.println("Perceptron Classifier by Zachary Gill and Sayeed Tahseen");
        System.out.println();
    }
    
    /**
     * Trains the classifier using the Perceptron algorithm for the input
     * number of epochs, using the learning rate constant supplied, and
     * against the input data set.
     *
     * @param instances
     * @throws Exception
     */
    @Override
    public void buildClassifier(Instances instances) throws Exception
    {
        weights = new ArrayList<>();
        weightUpdates = 0;
        
        int attributeCount = instances.numAttributes() - 1;
        
        //The initial weight values for all inputs, including the bias, should be 0.0.
        for (int i = 0; i < attributeCount; i++) {
            weights.add(0.0);
        }
        weights.add(0.0); //bias weight
        
        for (int epoch = 0; epoch < epochs; epoch++) {
            System.out.printf("Epoch %3d: ", epoch);
            for (Instance n : instances) {
        
                double predicted = (classifyInstance(n) >= 0.0) ? 1 : -1;
                double actual = (n.classValue() == 0.0) ? 1 : -1;
        
                if (predicted == actual) { //prediction correct
                    System.out.print("1");
                } else {
                    System.out.print("0"); //prediction incorrect
                    weightUpdates++;
            
                    //update weights
                    for (int j = 0; j < attributeCount; j++) {
                        weights.set(j, weights.get(j) + ((actual - predicted) * learningConstant * n.value(j)));
                    }
                    weights.set(attributeCount, weights.get(attributeCount) + ((actual - predicted) * learningConstant * BIAS_VALUE));
                }
        
            }
            System.out.println();
        }
    }
    
    /**
     * Translates the two output classification classes in the input data file
     * (which may be letters or numbers) to the values zero and one, which are
     * used by the Weka API methods to distinguish the classification classes.
     *
     * @param instance
     * @return
     * @throws Exception
     */
    @Override
    public double[] distributionForInstance(Instance instance) throws Exception
    {
        if (classifyInstance(instance) >= 0.0) {
            return new double[] {1, 0};
        } else {
            return new double[] {0, 1};
        }
    }
    
    @Override
    public String toString()
    {
        StringBuilder toString = new StringBuilder();
        
        toString.append("Source file: ").append(dataFile).append("\n");
        toString.append("Training epochs: ").append(epochs).append("\n");
        toString.append("Learning rate: ").append(learningConstant).append("\n");
        toString.append("\n");
        toString.append("Total # weight updates = ").append(weightUpdates).append("\n");
        toString.append("Final weights:").append("\n");
    
        for (int i = 0; i < weights.size(); i++) {
            toString.append(String.format("%.3f", weights.get(i)));
            if (i != weights.size() - 1) {
                toString.append("\n");
            }
        }
        
        return toString.toString();
    }
    
    @Override
    public Capabilities getCapabilities()
    {
        return null;
    }
    
    @Override
    public double classifyInstance(Instance instance) throws Exception
    {
        double prediction = 0.0;
        for (int i = 0; i < instance.numValues() - 1; i++) {
            prediction += weights.get(i) * instance.value(i);
        }
        prediction += weights.get(instance.numValues() - 1) * BIAS_VALUE;
        
        return prediction;
    }
    
}
