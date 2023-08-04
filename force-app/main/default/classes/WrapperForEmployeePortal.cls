public class WrapperForEmployeePortal {
    Public class WrapperClass{
        @AuraEnabled 
        Public List<Employee__c> Employee_dataBirthday;
        @AuraEnabled 
        Public Employee__c EmployeeData;
        @AuraEnabled
        Public Availability__c showTaskList;
        @AuraEnabled
        public Decimal totBillableHour;
        @AuraEnabled
        public Date todaysdate;
        @AuraEnabled
        public Date FirstDate;
        @AuraEnabled
        public Employee__c EmployeePD;
        @AuraEnabled
        public Employee__c Hod_RMData;
        @AuraEnabled
        Public Integer avgYesterdayAvl;
        @AuraEnabled
        Public Integer YesterdayBillableHR;
        @AuraEnabled
        Public Integer ThisMonthBilableHr;
        @AuraEnabled
        Public List<Employee__c> wrapperTeam;
        @AuraEnabled
        Public map<Id, Integer> wrapperMap;
        @AuraEnabled
        Public List<Employee__c> ProjectWillingEmp;
    }
    Public class Availability_wrapperCalss{
        @AuraEnabled
        public Availability__c showPreviousTasks;
        @AuraEnabled
        public List<Availability__c> InsertandUpdateTasks;
        
    }
    Public class TeamStructure_wrapperClass{
        @AuraEnabled 
        public List<Employee__c> Employee_RMData;
        @AuraEnabled 
        public List<Employee__c> Employee_TLData;
        @AuraEnabled 
        public List<Employee__c> EmployeeData;
        @AuraEnabled
        public String BillableMonthHours;
         @AuraEnabled 
        public Employee__c HODdata;
		@AuraEnabled
		public List<Employee__c> rmTeamInfo;
        @AuraEnabled
		public List<Employee__c> EmployeeInfo;
		@AuraEnabled 
		public Integer teamBillableHours;
        @AuraEnabled
        Public Integer HodTeamCount;
        @AuraEnabled
        Public Integer EmployeeCount;
        @AuraEnabled
        Public Boolean Is_TL_Emp_Trainee;
    }
    
    Public class Date_wrapperClass{
        @AuraEnabled 
        Public Date DateofFirstMonth;
        @AuraEnabled
        Public Date TodaysDate;
    }
    Public class Task_cmp_wrapper{
        @AuraEnabled
        Public List<Availability__c> AvailDataListForEmp;
        @AuraEnabled
        Public Employee__c EmployeeData;
        @AuraEnabled
		public List<Employee__c> EmpUnderRm;
        @AuraEnabled
		public List<Employee__c> RmUnderHOd;
    }
    
    public class TeamCertification{
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String CertificationLink;
        @AuraEnabled
        public Date CompletionDate;
        @AuraEnabled
        public String EmployeeName;
        @AuraEnabled
        public String ReportingManager;
   
    }
    
    public class AllDataforCertificationComponent{
        @AuraEnabled
        public List<Certification__c> certificationList;
        @AuraEnabled
        public Employee__c currentEmployee;
        @AuraEnabled
        public List<String> certificationNames;
        @AuraEnabled
        public List<WrapperForEmployeePortal.TeamCertification> teamCertificationList;
    }
    
    public class PolicyComponent{
        @AuraEnabled
        public List<Policy__c> PolicyData;
        @AuraEnabled
        public Boolean isNewButton;
        @AuraEnabled
        public Boolean isCurrentEmployee;
        @AuraEnabled
        public Employee__c currentEmployee;
    }
    
    public class projectStatus{
        @AuraEnabled
        Public List<Project__c> projectList;
    }
    
    public class projectDetails{
        @AuraEnabled public string Id;
        @AuraEnabled public string Name;
        @AuraEnabled public string ClientName;
        @AuraEnabled public decimal totalBillableHours;
        @AuraEnabled public decimal totalActualHours;
        @AuraEnabled public string teamName;
        @AuraEnabled public string employeeName;
        @AuraEnabled public date workDate;
        
    }
}