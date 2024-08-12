public class ArithmeticOperations {
    // Method to add two numbers
    public Integer add(Integer a, Integer b) {
        return a + b;
    }

    // Method to subtract two numbers
    public Integer subtract(Integer a, Integer b) {
        return a - b;
    }

    // Method to multiply two numbers
    public Integer multiply(Integer a, Integer b) {
        return a * b;
    }

    // Method to divide two numbers
    public Integer divide(Integer a, Integer b) {
        if (b == 0) {
            throw new IllegalArgumentException('Division by zero is not allowed.');
        }
        return a / b;
    }
}