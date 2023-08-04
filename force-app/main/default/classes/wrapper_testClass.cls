@isTest
public class wrapper_testClass {
    private static testMethod void testmethod1(){
        test.startTest();
        WrapperForEmployeePortal.WrapperClass wrapperOBJ = new WrapperForEmployeePortal.WrapperClass();
        
        List<Employee__c> empList = wrapperOBJ.Employee_dataBirthday;
        Employee__c emp = wrapperOBJ.EmployeeData;
        
        /*
         WrapperForEmployeePortal.WrapperClass wrapperOBJ = new WrapperForEmployeePortal.WrapperClass();
            WrapperForEmployeePortal.TeamStructure_wrapperClass TSOBJ = New WrapperForEmployeePortal.TeamStructure_wrapperClass();
            WrapperForEmployeePortal.TeamCertification TCertificateOBJ = New WrapperForEmployeePortal.TeamCertification();
            WrapperForEmployeePortal.PolicyComponent policyComOBJ = New WrapperForEmployeePortal.PolicyComponent();
            WrapperForEmployeePortal.Availability_wrapperCalss availableOBJ = New WrapperForEmployeePortal.Availability_wrapperCalss();
            WrapperForEmployeePortal.Date_wrapperClass DataOBJ = New WrapperForEmployeePortal.Date_wrapperClass();
            WrapperForEmployeePortal.Task_cmp_wrapper taskOBJ = New WrapperForEmployeePortal.Task_cmp_wrapper();
            WrapperForEmployeePortal.AllDataforCertificationComponent allDataCertificateOBJ = New WrapperForEmployeePortal.AllDataforCertificationComponent();
            
            wrapperOBJ.Employee_dataBirthday = empList;
            wrapperOBJ.EmployeeData = obj8;
            wrapperOBJ.showTaskList = obj6;
            wrapperOBJ.totBillableHour = 2.3;
            wrapperOBJ.todaysdate = System.today();
            wrapperOBJ.FirstDate = System.today().addDays(-2);
            wrapperOBJ.EmployeePD = obj3;
            wrapperOBJ.Hod_RMData = obj4;
            wrapperOBJ.avgYesterdayAvl = 1;
            wrapperOBJ.YesterdayBillableHR = 1;
            wrapperOBJ.ThisMonthBilableHr = 2;
            wrapperOBJ.wrapperTeam = empList;
            wrapperOBJ.wrapperMap = newMap;
            wrapperOBJ.ProjectWillingEmp = empList;
availableOBJ.showPreviousTasks = obj6;
            availableOBJ.InsertandUpdateTasks = newList2;
            
            TSOBJ.Employee_RMData = empList;
            TSOBJ.Employee_TLData = empList;
            TSOBJ.EmployeeData = empList;
            TSOBJ.BillableMonthHours = '6';
            TSOBJ.HODdata = obj4;
            TSOBJ.rmTeamInfo = empList;
            TSOBJ.EmployeeInfo = empList;
            TSOBJ.EmployeeCount = 15;
            TSOBJ.HodTeamCount = 1;
            TSOBJ.Is_TL_Emp_Trainee = true;
            TSOBJ.teamBillableHours = 21;
            
            DataOBJ.DateofFirstMonth = System.today().addDays(-1);
            DataOBJ.TodaysDate = System.today();
            
            taskOBJ.AvailDataListForEmp = newList2;
            taskOBJ.EmployeeData = obj4;
            taskOBJ.EmpUnderRm = empList;
            taskOBJ.RmUnderHOd = empList;
            
            TCertificateOBJ.CertificationLink = 'Salesforce.com';
            TCertificateOBJ.CompletionDate = System.today().addDays(-1);
            TCertificateOBJ.EmployeeName = 'ABCS';
            TCertificateOBJ.Name = 'C++';
            TCertificateOBJ.ReportingManager = 'a005i0000066JuDAAU';
            
            allDataCertificateOBJ.certificationList = certificateListOBJ;
            allDataCertificateOBJ.certificationNames = new List<String>{'str1', 'str2'};
            allDataCertificateOBJ.currentEmployee = obj4;
            allDataCertificateOBJ.teamCertificationList = new List<WrapperForEmployeePortal.TeamCertification>{TCertificateOBJ}; 
            
            policyComOBJ.isNewButton = true;
            policyComOBJ.PolicyData = policyList;
            policyComOBJ.isCurrentEmployee = true;
            policyComOBJ.currentEmployee = obj;

		*/
        
        test.stopTest();
    }
}