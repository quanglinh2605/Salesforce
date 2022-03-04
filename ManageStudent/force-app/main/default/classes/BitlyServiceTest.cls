@IsTest
private class BitlyServiceTest {

    @IsTest
    static void test_shorten() {

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new BitlyHttpCalloutMock());

        BitlyService service = new BitlyService();

        String longURL = 'https://this-is-a-test.example.com';
        String shortURL = service.shorten(longURL);

        Test.stopTest();

        System.assertEquals('https://sforce.co/3rUWGZ8', shortURL);

    }

}