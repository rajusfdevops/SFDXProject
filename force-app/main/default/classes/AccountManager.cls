public class AccountManager {
    public static Id createAccount(String accountName) {
        Account newAccount = new Account(Name = accountName);
        insert newAccount;
        return newAccount.Id;
    }
}