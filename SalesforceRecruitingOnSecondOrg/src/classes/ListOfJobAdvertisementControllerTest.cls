@isTest
public class ListOfJobAdvertisementControllerTest {
    @isTest
    public static void listOfJobAdvertisementControllerConstructorTest(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        Boolean testDataFlag = false;
        if(test.activeCheckBox == false && test.archivedCheckBox == false && test.onHoldCheckBox == false) testDataFlag = true;
        List<SelectOption> testRecordOnPageList = new List<SelectOption>();
        testRecordOnPageList.add(new SelectOption('5','5'));
        testRecordOnPageList.add(new SelectOption('10','10'));
        testRecordOnPageList.add(new SelectOption('15','15'));
        testRecordOnPageList.add(new SelectOption('20','20'));
        testRecordOnPageList.add(new SelectOption('25','25'));
        System.assert(testDataFlag);
        System.assertEquals(testRecordOnPageList, test.paginationSizeOption);
        System.assertEquals(3, test.totalRecs);
    }
    @isTest
    public static void testForUpdateTotalRecords(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.updateTotalRecords();
        System.assertEquals(3, test.totalRecs);
    }
    @isTest
    public static void testForUpdateTotalRecordsWhenAreNotRecords(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.updateTotalRecords();
        System.assertEquals(0, test.totalRecs);
    }
    @isTest
    public static void searchByNameTest(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchByNameString = 'test';
        String expextedFirst = ' where Name LIKE \'%test%\'';
        System.assertEquals(expextedFirst, test.searchByName(test.searchquery));
    }
    @isTest
    public static void searchByNameTestWhenSearchQueryIsNotEmpty(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchByNameString = 'test';
        test.searchquery = 'testquery +';
        String expextedFirst = 'testquery + AND Name LIKE \'%test%\'';
        System.assertEquals(expextedFirst, test.searchByName(test.searchquery));
    }
    @isTest
    public static void testForClearMethod(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchquery = 'test search';
        test.clear();
        Boolean testFlag = false;
        if(test.noRecords == false && test.activeCheckBox == false && test.archivedCheckBox == false && test.onHoldCheckBox == false && test.searchquery == '' &&
          test.searchByNameString == '' && test.searchBySalaryString == '' && test.selectedOperator == null) testFlag = true;
        System.assert(testFlag);
        System.assertEquals(3, test.jobAdvertisements.size());
    }
    @isTest
    public static void searchBySalaryTestWhenSelectLessOperator(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '50';
        test.selectedOperator = '<';
        String expectedValue = ' where ( Maximum_Salary__c <50)';
        String actualSearchQuery = test.searchBySalary(test.searchquery);
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    @isTest
    public static void searchBySalaryWhenSelectMoreOperator(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '50';
        test.selectedOperator = '>';
        String expectedValue = ' where ( Minimum_Salary__c >50)';
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    @isTest
    public static void searchBySalaryWhenSelectMoreOrEqualsOperator(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '50';
        test.selectedOperator = '>=';
        String expectedValue = ' where ( Minimum_Salary__c >=50)';
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    
    @isTest
    public static void searchBySalaryWhenSelectLessOrEqualsOperator(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '50';
        test.selectedOperator = '<=';
        String expectedValue = ' where ( Maximum_Salary__c <=50)';
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    @isTest
    public static void searchBySalaryWhenSelectEqualOperator(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '50';
        test.selectedOperator = '=';
        String expectedValue = ' where ( Minimum_Salary__c <= 50 and Maximum_Salary__c >= 50)';
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    @isTest
    public static void searchBySalaryWhenSelectNotEqualOperator(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '50';
        test.selectedOperator = '<>';
        String expectedValue = ' where ( Minimum_Salary__c > 50 OR Maximum_Salary__c <50)';
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    @isTest
    public static void searchBySalaryWhenSearchQueryStringNotEmptyOperator(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '50';
        test.searchquery = 'test +';
        test.selectedOperator = '<';
        string expectedValue = 'test + AND ( Maximum_Salary__c <50)';
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    @isTest
    public static void searchBySalaryWhenUserNotChooseOperator(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '50';
        test.selectedOperator = null;
        string expectedValue = '';
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    @isTest
    public static void searchBySalaryWhenUserNotEnterSalary(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '';
        test.selectedOperator = '<';
        string expectedValue = '';
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    @isTest
    public static void searchBySalaryWhenUserNotEnterSalaryAndNotChooseOperator(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '';
        test.selectedOperator = null;
        string expectedValue = '';
        System.assertEquals(expectedValue, test.searchBySalary(test.searchquery));
    }
    @isTest
    public static void filterByStatusWhenAllCheckBoxesChecked(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = true;
        test.archivedCheckBox = true;
        test.onHoldCheckBox = true;
        String searchQueryTest = test.filterByStatus(test.searchquery);
        String expectedValue = ' where ( Status__c = \'Active\'  OR  Status__c = \'Archived\'  OR  Status__c = \'On Hold\')';
        System.assertEquals(expectedValue, searchQueryTest);
    }
    @isTest
    public static void filterByStatusWhenSearchQueryStringNotEmpty(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = true;
        test.archivedCheckBox = true;
        test.onHoldCheckBox = true;
        test.searchquery = 'test + ';
        String expectedValue = 'test +  AND ( Status__c = \'Active\'  OR  Status__c = \'Archived\'  OR  Status__c = \'On Hold\')';
        String searchQueryTest = test.filterByStatus(test.searchquery);
        System.assertEquals(expectedValue, searchQueryTest);
    }
    @isTest
    public static void filterByStatusWhenAllCheckboxesNotChecked(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = false;
        test.archivedCheckBox = false;
        test.onHoldCheckBox = false;
        test.searchquery = '';
        String searchQueryTest = test.filterByStatus(test.searchquery);
        String expectedValue = '';
        System.assertEquals(expectedValue, searchQueryTest);
    }
    @isTest
    public static void filterByStatusWhenCheckedOnlyActiveCheckBox(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = true;
        test.archivedCheckBox = false;
        test.onHoldCheckBox = false;
        String searchQueryTest = test.filterByStatus(test.searchquery);
        String expectedValue = ' where ( Status__c = \'Active\' )';
        System.assertEquals(expectedValue, searchQueryTest);
    }
    @isTest
    public static void filterByStatusWhenCheckedOnlyArchivedCheckbox(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = false;
        test.archivedCheckBox = true;
        test.onHoldCheckBox = false;
        String searchQueryTest = test.filterByStatus(test.searchquery);
        String expectedValue = ' where ( Status__c = \'Archived\' )';
        System.assertEquals(expectedValue, searchQueryTest);
    }
    @isTest
    public static void filterByStatusWhenCheckedOnlyOnHoldCheckbox(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = false;
        test.archivedCheckBox = false;
        test.onHoldCheckBox = true;
        String searchQueryTest = test.filterByStatus(test.searchquery);
        String expectedValue = ' where ( Status__c = \'On Hold\')';
        System.assertEquals(expectedValue, searchQueryTest);
    }
    @isTest
    public static void filterByStatusWhenCheckedActiveAndArchivedCheckboxes(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = true;
        test.archivedCheckBox = true;
        test.onHoldCheckBox = false;
        String searchQueryTest = test.filterByStatus(test.searchquery);
        String expectedValue = ' where ( Status__c = \'Active\'  OR  Status__c = \'Archived\' )';
        system.debug('expect query: ' + expectedValue);
        System.debug('search query: ' + searchQueryTest);
        System.assertEquals(expectedValue, searchQueryTest);
    }
    @isTest
    public static void filterByStatusWhenCheckedActiveAndOnHoldCheckboxes(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = true;
        test.archivedCheckBox = false;
        test.onHoldCheckBox = true;
        String searchQueryTest = test.filterByStatus(test.searchquery);
        String expectedValue = ' where ( Status__c = \'Active\'  OR  Status__c = \'On Hold\')';
        system.debug('expect query: ' + expectedValue);
        System.debug('search query: ' + searchQueryTest);
        System.assertEquals(expectedValue, searchQueryTest);
    }
    @isTest
    public static void filterByStatusWhenCheckedArchivedAndOnHoldChecboxes(){
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = false;
        test.archivedCheckBox = true;
        test.onHoldCheckBox = true;
        String searchQueryTest = test.filterByStatus(test.searchquery);
        String expectedValue = ' where ( Status__c = \'Archived\'  OR  Status__c = \'On Hold\')';
        system.debug('expect query: ' + expectedValue);
        System.debug('search query: ' + searchQueryTest);
        System.assertEquals(expectedValue, searchQueryTest);
    }
    @isTest
    public static void searchRecordsTest(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 80, 120);
        TestDataFactory.createJobAdvertisements(3, 'Archived', 75, 120);
        TestDataFactory.createJobAdvertisements(1, 'On Hold', 85, 100);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchByNameString = 'test';
        test.searchBySalaryString = '90';
        test.selectedOperator = '=';
        test.searchRecords();
        System.assertEquals(7, test.jobAdvertisements.size());
    }
    @isTest
    public static void searchRecordTestWhenAllCriteriasIsEmpty(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchByNameString = '';
        test.searchBySalaryString = '';
        test.selectedOperator = '';
        test.searchRecords();
        System.assertEquals(3, test.jobAdvertisements.size());
        System.assert(String.isEmpty(test.searchquery));
    }
    @isTest
    public static void searchRecordWhenUserEnterOnlyName(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchByNameString = 'test';
        test.searchRecords();
        System.assertEquals(3, test.jobAdvertisements.size());
    }
    @isTest
    public static void searchRecordWhenUserEnterNameAndSalary(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 80, 120);
        TestDataFactory.createJobAdvertisements(3, 'Archived', 75, 120);
        TestDataFactory.createJobAdvertisements(1, 'On Hold', 50, 86);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchByNameString = 'test';
        test.searchBySalaryString = '90';
        test.selectedOperator = '=';
        test.searchRecords();
        System.assertEquals(6, test.jobAdvertisements.size());
    }
    @isTest
    public static void searchRecordWhenUserEnterOnlySalary(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 80, 120);
        TestDataFactory.createJobAdvertisements(3, 'Archived', 75, 120);
        TestDataFactory.createJobAdvertisements(1, 'On Hold', 50, 86);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '90';
        test.selectedOperator = '=';
        test.searchRecords();
        System.assertEquals(6, test.jobAdvertisements.size());
    }
    @isTest
    public static void searchRecordWhenUserOnlyCheckedCheckbox(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 80, 120);
        TestDataFactory.createJobAdvertisements(3, 'Archived', 75, 120);
        TestDataFactory.createJobAdvertisements(1, 'On Hold', 50, 86);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.activeCheckBox = true;
        test.archivedCheckBox = false;
        test.onHoldCheckBox = true;
        test.searchRecords();
        System.assertEquals(4, test.jobAdvertisements.size());
    }
    @isTest
    public static void searchRecordWhenUserEnterNameAndCheckCheckbox(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 80, 120);
        TestDataFactory.createJobAdvertisements(3, 'Archived', 75, 120);
        TestDataFactory.createJobAdvertisements(1, 'On Hold', 50, 86);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchByNameString = 'Test';
        test.activeCheckBox = true;
        test.archivedCheckBox = false;
        test.onHoldCheckBox = true;
        test.searchRecords();
        System.assertEquals(4, test.jobAdvertisements.size());
    }
    @isTest
    public static void searchRecordWhenUserEnterSalaryAndCheckCheckbox(){
        TestDataFactory.createJobAdvertisements(3, 'Active', 80, 120);
        TestDataFactory.createJobAdvertisements(3, 'Archived', 75, 120);
        TestDataFactory.createJobAdvertisements(1, 'On Hold', 50, 86);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchBySalaryString = '60';
        test.selectedOperator = '=';
        test.activeCheckBox = true;
        test.archivedCheckBox = false;
        test.onHoldCheckBox = true;
        test.searchRecords();
        System.assertEquals(1, test.jobAdvertisements.size());
    }
    @isTest
    public static void updatePageTest(){
        TestDataFactory.createJobAdvertisements(20, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.searchByNameString = 'Test';
        test.rec = 5;
        test.updatePage();
        System.assertEquals(20, test.totalRecs);
        System.assertEquals(5, test.jobAdvertisements.size());
    }
    @isTest
    public static void goToFirstPageTest(){
        TestDataFactory.createJobAdvertisements(20, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.first();
        System.assertEquals(0, test.pageNumber);
        System.assertEquals(0, test.OffsetSize);
    }
    @isTest
    public static void goToNextPageTest(){
        TestDataFactory.createJobAdvertisements(15, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.rec = 5;
        test.next();
        System.assertEquals(1, test.pageNumber);
        System.assertEquals(5, test.OffsetSize);
    }
    @isTest
    public static void goToPreviousPageTest(){
        TestDataFactory.createJobAdvertisements(15, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.rec = 5;
        test.next();
        test.next();
        test.previous();
        System.assertEquals(1, test.pageNumber);
        System.assertEquals(5, test.OffsetSize);
    }
    @isTest
    public static void goToLastPageTest(){
        TestDataFactory.createJobAdvertisements(15, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.rec = 5;
        test.last();
        System.assertEquals(2, test.pageNumber);
        System.assertEquals(10, test.OffsetSize);
    }
    @isTest
    public static void lastPageNumberTest(){
        TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.rec = 5;
        System.assertEquals(4, test.lastPageNumber());
    }
    @isTest
    public static void disableNextButtonTest(){
        TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.rec = 5;
        test.next();
        test.next();
        test.next();
        test.next();
        test.next();
        System.assert(test.getDisableNxt());
    }
    @isTest
    public static void notDisableNextButton(){
        TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.rec = 5;
        test.next();
        test.next();
        System.assert(!test.getDisableNxt());
    }
    @isTest
    public static void disablePreviousButton(){
        TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.rec = 5;
        System.assert(test.getDisablePrv());
    }
    @isTest
    public static void notDisablePreviousButton(){
        TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        test.rec = 5;
        test.next();
        System.assert(!test.getDisablePrv());
    }
    @isTest
    public static void getListOfOperators(){
        List<SelectOption> listOfOperators = new List<SelectOption>();
        listOfOperators.add(new SelectOption('', '--NONE--'));
        listOfOperators.add(new SelectOption('=', 'EQUAL'));
        listOfOperators.add(new SelectOption('<', 'LESS'));
        listOfOperators.add(new SelectOption('>', 'MORE'));
        listOfOperators.add(new SelectOption('<=', 'LESSOREQUAL'));
        listOfOperators.add(new SelectOption('>=', 'MOREOREQUAL'));
        listOfOperators.add(new SelectOption('<>', 'NOTEQUAL'));
        ListOfJobAdvertisementController test = new ListOfJobAdvertisementController();
        System.assertEquals(listOfOperators, test.getListOfOperators());
    }
}