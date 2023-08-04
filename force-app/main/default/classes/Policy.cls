public without sharing class Policy {
    @AuraEnabled
    public static WrapperForEmployeePortal.PolicyComponent getPolicyData (String empId){
        try{
            system.debug('Policy Apex is Calling' + empId);
            if(empId != Null){
                System.debug('recordId>>>> '+ empId);
                WrapperForEmployeePortal.PolicyComponent wrpClassOBJ = New WrapperForEmployeePortal.PolicyComponent();    
                Employee__c getLoggedInEmployee = [SELECT Id, Name, Team_Lead__c, Reporting_Manager__c, Head_of_Department__c, designation__c FROM Employee__c where Id =: empId];
                wrpClassOBJ.currentEmployee = getLoggedInEmployee;
                System.debug('LoggedInEmployee>>>>' +getLoggedInEmployee);
                Id hodId, rmId, employeeId;
                if(getLoggedInEmployee.designation__c == 'HOD'){
                    hodId = getLoggedInEmployee.Id;
                    system.debug('HOD LOGGED IN ...');
                    wrpClassOBJ.isNewButton = true;
                    wrpClassOBJ.isCurrentEmployee = true;
                }
                else if(getLoggedInEmployee.designation__c == 'Reporting Manager'){
                    rmId = getLoggedInEmployee.Id;
                    system.debug('RM LOGGED IN ...');
                    wrpClassOBJ.isNewButton = true;
                    wrpClassOBJ.isCurrentEmployee = false;
                    
                }else if(getLoggedInEmployee.designation__c == 'Team Lead' || getLoggedInEmployee.designation__c == 'Employee' || getLoggedInEmployee.designation__c == 'Trainee'){
                    employeeId = getLoggedInEmployee.Id;
                    system.debug('EMP LOGGED IN ...');
                    wrpClassOBJ.isNewButton = false;
                }
                List<Policy__c> policyList = new List<Policy__c>();
                if(hodId != Null){
                    policyList = [select Id, Name, Apply_to_under_Team_of__r.Name, Description__c,Policy_Created_By__r.Name,Policy_Created_By__r.designation__c from Policy__c where Policy_Created_By__c =: hodId order BY createdDate DESC limit 1000];
                    System.debug('PolicyData for HOD>>>'+policyList);
                    
                }
                else if(rmId != Null){
                    policyList = [select Id, Name, Apply_to_under_Team_of__r.Name, Description__c,Policy_Created_By__r.Name,Policy_Created_By__r.designation__c from Policy__c where Policy_Created_By__c =: rmId OR Apply_to_under_Team_of__c =: rmId OR Apply_to_under_Team_of__c =: getLoggedInEmployee.Head_of_Department__c order BY createdDate DESC limit 1000];
                    System.debug('PolicyData for RM>>>'+policyList);
                }
                else if(employeeId != Null){
                    policyList = [select Id, Name, Apply_to_under_Team_of__r.Name, Description__c,Policy_Created_By__r.Name,Policy_Created_By__r.designation__c from Policy__c where Apply_to_under_Team_of__c =: getLoggedInEmployee.Reporting_Manager__c OR Apply_to_under_Team_of__c =: getLoggedInEmployee.Head_of_Department__c order BY createdDate DESC limit 1000];
                    System.debug('PolicyData for EMP>>>'+policyList);
                }
                system.debug('FINAL RETURNED POLICY ... '+policyList); 
                if(! policyList.isEmpty())
                {
                    wrpClassOBJ.PolicyData = policyList;
                }
                if(wrpClassOBJ != Null)
                {
                    return wrpClassOBJ;
                }
            }
        }catch(exception ee)
        {
            System.debug('Error>>>' + ee.getMessage() +'at'+ee.getLineNumber());
        }
        return Null;
    }
    
    @AuraEnabled
    public static List<Employee__c> getRMData(){
        try {
            List<Employee__c> rmDataList = [select Id, Name from Employee__c where designation__c = 'Reporting Manager' limit 1000];
            if(! rmDataList.isEmpty()){
                system.debug('RM >>> '+rmDataList);
                return rmDataList;
            } 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return Null;
    }
    
    @AuraEnabled
    public static List<Policy__c> createPolicy(String name, List<String> pickValue, String empId, String description)  
    {
        try 
        { 
            System.debug('EMployeeID>>>'+empID);
            List<Policy__c> polOBJ = new List<Policy__c>();
            if(name != null && pickValue != null && empId != null && description != null)
            {
                for(String each: pickValue)
                {
                    Policy__c policyOBJ = new Policy__c();
                    policyOBJ.Name = name;
                    policyOBJ.Description__c = description;
                    policyOBJ.Apply_to_under_Team_of__c = each;
                    policyOBJ.Policy_Created_By__c = empID;
                    polOBJ.add(policyOBJ);
                }                
                if(polOBJ != null)
                {
                    insert polOBJ;
                    return polOBJ;
                }
            } 
        }catch (Exception ex) 
        {
            System.debug('Error>>>' + ex.getMessage() +'at'+ex.getLineNumber()); 
        }
        return Null;  
    }    
    @AuraEnabled
    public static Boolean deletePolicy(String PolicyID)
    {
        try{
            if(PolicyID!=null)
            {
                Policy__c deletePolicyOBJ = [SELECT Id, Name, Apply_to_under_Team_of__r.Name, Description__c,Policy_Created_By__r.Name,Policy_Created_By__r.designation__c FROM Policy__c WHERE Id =: PolicyID];
                if(deletePolicyOBJ != Null)
                {
                    Delete deletePolicyOBJ;
                    System.debug('Delete Policy Data>>>>'+deletePolicyOBJ);
                    return true;
                }
            }
        }catch(Exception ee)
        {
            System.debug('Error>>>' +ee.getMessage()+ 'Line Number' +ee.getLineNumber());
        }
        return false;
    }
}