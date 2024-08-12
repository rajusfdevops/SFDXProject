@isTest
private class AccountManagerTest {
    @isTest static void testCreateAccount() {
        // Test data setup
        String testAccountName = 'Test Account';
        
        // Test createAccount method
        Test.startTest();
        Id accountId = AccountManager.createAccount(testAccountName);
        Test.stopTest();
        
        // Verify the results
        Account resultAccount = [SELECT Id, Name FROM Account WHERE Id = :accountId];
        System.assertNotEquals(null, resultAccount, 'Account should not be null');
        System.assertEquals(testAccountName, resultAccount.Name, 'Account name should match the test data');
    }
}