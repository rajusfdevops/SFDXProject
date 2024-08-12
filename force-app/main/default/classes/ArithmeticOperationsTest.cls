@IsTest
public class ArithmeticOperationsTest {
    @IsTest
    static void testAdd() {
        ArithmeticOperations ao = new ArithmeticOperations();
        Integer result = ao.add(5, 3);
        System.assertEquals(8, result, 'Addition result is incorrect');
    }

    @IsTest
    static void testSubtract() {
        ArithmeticOperations ao = new ArithmeticOperations();
        Integer result = ao.subtract(5, 3);
        System.assertEquals(2, result, 'Subtraction result is incorrect');
    }

    @IsTest
    static void testMultiply() {
        ArithmeticOperations ao = new ArithmeticOperations();
        Integer result = ao.multiply(5, 3);
        System.assertEquals(15, result, 'Multiplication result is incorrect');
    }

    @IsTest
    static void testDivide() {
        ArithmeticOperations ao = new ArithmeticOperations();
        Integer result = ao.divide(6, 3);
        System.assertEquals(2, result, 'Division result is incorrect');
    }

    @IsTest
    static void testDivideByZero() {
        ArithmeticOperations ao = new ArithmeticOperations();
        try {
            ao.divide(6, 0);
            System.assert(false, 'Expected exception was not thrown');
        } catch (IllegalArgumentException e) {
            System.assertEquals('Division by zero is not allowed.', e.getMessage());
        }
    }
}