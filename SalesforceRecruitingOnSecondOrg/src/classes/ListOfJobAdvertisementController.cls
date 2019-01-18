public class ListOfJobAdvertisementController {
    public List<Job_Advertisement__c> jobAdvertisements {get; set;}
    public List<SelectOption> paginationSizeOption {get; set;}
    public String searchByNameString {get; set;}
    public String searchBySalaryString {get; set;}
    public String selectedOperator {get; set;}
    public boolean activeCheckBox {get; set;}
    public boolean archivedCheckBox {get; set;}
    public boolean onHoldCheckBox {get; set;}
    public boolean noRecords {get; set;}
    public Integer rec { get; set; }
    public integer totalRecs = 0;
    @TestVisible
    integer OffsetSize= 0;
    @TestVisible
    Integer pageNumber = 0;
    public String searchquery = '';
    public String searchQueryMainPart = 'select Name, Minimum_Salary__c, Maximum_Salary__c, Manager_name__c, Phone__c, Status__c from Job_Advertisement__c';
    public String searchQueryFinishPart = ' LIMIT :rec OFFSET :OffsetSize';
    public String allSearchQuery = '';

    public ListOfJobAdvertisementController(){
        rec = 10;
        allSearchQuery = searchQueryMainPart + searchquery + searchQueryFinishPart;
        jobAdvertisements = Database.query(allSearchQuery);
        activeCheckBox = false;
        archivedCheckBox = false;
        onHoldCheckBox = false;
        paginationSizeOption = new List<SelectOption>();
        paginationSizeOption.add(new SelectOption('5','5'));
        paginationSizeOption.add(new SelectOption('10','10'));
        paginationSizeOption.add(new SelectOption('15','15'));
        paginationSizeOption.add(new SelectOption('20','20'));
        paginationSizeOption.add(new SelectOption('25','25'));
        updateTotalRecords();
    }
    @TestVisible
    private void updateTotalRecords() {
        totalRecs = Database.countQuery('select count() from Job_Advertisement__c ' + searchquery);
        if(totalRecs == 0){
            noRecords= true;
        }
        else{
           pageNumber = 0;
           updateOffset(); 
        }
    }
    
    private void updateRecordList() {
        allSearchQuery = searchQueryMainPart + searchquery + searchQueryFinishPart;
        updateTotalRecords();
        jobAdvertisements = Database.query(allSearchQuery);
    }

    public String searchByName( String searchQuery){
        if(!String.isEmpty(searchByNameString)){
            if(searchQuery!=''){
            	searchQuery += ' AND ';
            }
            else{
                searchQuery +=' where ';
            }
            searchQuery= searchQuery + 'Name LIKE \'%'+searchByNameString+'%\'';
        }
        return searchQuery;
    }
    public void clear(){
        noRecords = false;
        searchquery = '';
        activeCheckBox = false;
        archivedCheckBox = false;
        onHoldCheckBox = false;
        searchByNameString = '';
        searchBySalaryString = '';
        selectedOperator = null;
        updateRecordList();
    }
    public String searchBySalary(String searchQuery){
        if(String.isEmpty(searchBySalaryString) || selectedOperator == null){
            searchQuery += '';
        }
        else if(!String.isEmpty(searchBySalaryString) && selectedOperator != null){
            if(searchQuery!=''){
                searchQuery += ' AND (';
            }
            else{
                searchQuery +=' where (';
            }
            if(selectedOperator == '<'){
                searchQuery = searchQuery + ' Maximum_Salary__c '
                    + selectedOperator + searchBySalaryString + ')';
            }
            else if(selectedOperator == '>'){
                searchQuery = searchQuery + ' Minimum_Salary__c '
                    + selectedOperator + searchBySalaryString + ')';
            }
            else if(selectedOperator == '>='){
                searchQuery = searchQuery + ' Minimum_Salary__c '
                    + selectedOperator + searchBySalaryString + ')';
            }
            else if(selectedOperator == '<='){
                searchQuery = searchQuery + ' Maximum_Salary__c '
                    + selectedOperator + searchBySalaryString + ')';
            }
            else if(selectedOperator == '=' ){
                searchQuery = searchQuery + ' Minimum_Salary__c <= '
                    + searchBySalaryString + ' and Maximum_Salary__c >= ' + searchBySalaryString + ')';
            }
            else if(selectedOperator == '<>'){
                searchQuery = searchQuery + ' Minimum_Salary__c > '
                    + searchBySalaryString + ' OR Maximum_Salary__c <' + searchBySalaryString  + ')';
            }
        }
        return searchQuery;
    }
    public String filterByStatus( String searchQuery){
        if(activeCheckBox != false || archivedCheckBox != false || onHoldCheckBox != false){
            if(searchQuery != ''){
                searchQuery += ' AND (';
            }
            else{
                searchQuery += ' where (';
            }
            if(activeCheckBox != false){
                searchQuery += ' Status__c = \'Active\' ';
            }
            if(archivedCheckBox != false){
                if(activeCheckBox == true){
                    searchQuery += ' OR ';
                }
                searchQuery += ' Status__c = \'Archived\' ';
            }
            if(onHoldCheckBox != false){
                if(activeCheckBox == true || archivedCheckBox == true){
                    searchQuery += ' OR ';
                }
                searchQuery += ' Status__c = \'On Hold\'';
            }
            searchQuery += ')';
        }
        else{
            searchQuery += '';
        }
        return searchQuery;
    }
    public void searchRecords(){
        searchquery = '';
        noRecords = false;
        if(!String.isEmpty(searchByNameString) || (!String.isEmpty(searchBySalaryString) && selectedOperator != null) || (activeCheckBox != false || archivedCheckBox != false ||onHoldCheckBox != false)){
            searchquery = searchByName(searchquery);
            searchquery = searchBySalary(searchquery);
            searchquery = filterByStatus(searchquery);
            updateRecordList();
        }
        else if(String.isEmpty(searchByNameString) && (String.isEmpty(searchBySalaryString) 
        || selectedOperator == null) && (!activeCheckBox && !archivedCheckBox
                                         && !onHoldCheckBox)){
            clear();
        }
    }
    public PageReference updatePage() {
        jobAdvertisements.clear();
        updateTotalRecords();
        allSearchQuery = searchQueryMainPart + searchquery + searchQueryFinishPart;
        jobAdvertisements = Database.query(allSearchQuery);
        return null;
    }

    public PageReference first() {
        pageNumber = 0;
        updateOffset();
        retrievePageRecords(rec);
        return null;
    }
    public PageReference previous() {
        pageNumber--;
        updateOffset();
        retrievePageRecords(rec);
        return null;
    }
    public PageReference next() {
        pageNumber++;
        updateOffset();
        retrievePageRecords(rec);
        return null;
    }
    public PageReference last() {
        pageNumber = lastPageNumber();
        updateOffset();
        retrievePageRecords(math.mod(totalRecs,rec));
        return null;
    }

    public Boolean getDisableNxt() {
        if(pageNumber >= lastPageNumber())
            return true;
        else
            return false;
    }
    public Boolean getDisablePrv(){
        if(pageNumber <= 0)
            return true;
        else
            return false;
    }

    private void updateOffset() {
        OffsetSize = rec * pageNumber;
    }

    private void retrievePageRecords(integer recordsOnPage) {
        allSearchQuery = searchQueryMainPart + searchquery + searchQueryFinishPart;
        jobAdvertisements = Database.query(allSearchQuery);
    }
    @TestVisible
    private integer lastPageNumber() {
        return (integer)(((totalRecs*1.0) / (rec *1.0)).round(RoundingMode.UP) -1);
    }
    public List<SelectOption> getListOfOperators(){
        List<SelectOption> listOfOperators = new List<SelectOption>();
        listOfOperators.add(new SelectOption('', '--NONE--'));
        listOfOperators.add(new SelectOption('=', 'EQUAL'));
        listOfOperators.add(new SelectOption('<', 'LESS'));
        listOfOperators.add(new SelectOption('>', 'MORE'));
        listOfOperators.add(new SelectOption('<=', 'LESSOREQUAL'));
        listOfOperators.add(new SelectOption('>=', 'MOREOREQUAL'));
        listOfOperators.add(new SelectOption('<>', 'NOTEQUAL'));
        return listOfOperators;
    }
}