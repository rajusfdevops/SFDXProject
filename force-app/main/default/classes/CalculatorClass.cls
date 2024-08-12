public with sharing class CalculatorClass {
    public CalculatorClass() {
    }

    public Integer addition(Integer num1, Integer num2) {
        return num1 + num2;
    }

    public Integer subtraction(Integer num1, Integer num2) {
        return num1 - num2;
    }

    public Integer multiplication(Integer num1, Integer num2) {
        return num1 * num2;
    }

    public Decimal division(Integer num1, Integer num2) {
        if (num2 != 0) {
            return num1 / num2;
        } else {
            // import System.DivideByZeroException;

            // throw new DivideByZeroException('Cannot divide by zero');
            return null;
        }
    }
}