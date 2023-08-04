@isTest(SeeAlldata = true)
public class TestClass_Emp {
@isTest
    public static void Test_Method()
    {
        try{
            
            Employee__c Emp1OBJ = New Employee__c();
            Emp1OBJ.Name = 'Employee12';
            Emp1OBJ.Role__c = 'HOD';
            Emp1OBJ.designation__c = 'HOD';
            Emp1OBJ.Email__c = 'Emp1@gmail.com';
            Emp1OBJ.Password__c = '1234';
            Emp1OBJ.Emp_Code__c = 'CA110095';
            Emp1OBJ.Date_Of_Joining__c = Date.newInstance(2022, 01, 17);
            Emp1OBJ.DOB__c = Date.newInstance(1947, 06, 28);
            Insert Emp1OBJ;
            
            List<Availability__c> newList1 = New List<Availability__c>();
            For(integer i = 0 ; i <=10 ; i++){
                Availability__c Availability1 = New Availability__c();
                Availability1.Employee__c = Emp1OBJ.ID;
                Availability1.Date__c = system.today().addDays(-i);
                Availability1.Billable_Hours__c = 8;
                newList1.add(Availability1);
            }
            Insert newList1; 
            
            
            Employee__c Emp2OBJ = New Employee__c();
            Emp2OBJ.Name = 'Employee2';
            Emp2OBJ.Role__c = 'Reporting Manager';
            Emp2OBJ.designation__c = 'Reporting Manager';
            Emp2OBJ.Head_of_Department__c = Emp1OBJ.Id;
            Emp2OBJ.Email__c = 'Emp2@gmail.com';
            Emp2OBJ.Password__c = '1234';
            Emp2OBJ.Emp_Code__c = 'CA110095';
            Emp2OBJ.Date_Of_Joining__c = Date.newInstance(2022, 01, 17);
            Emp2OBJ.DOB__c = Date.newInstance(1947, 06, 28);
            Insert Emp2OBJ;
            
            List<Availability__c> newList2 = New List<Availability__c>();
            For(integer i = 0 ; i <=10 ; i++){
                Availability__c Availability2 = New Availability__c();
                Availability2.Employee__c = Emp2OBJ.ID;
                Availability2.Date__c = system.today().addDays(-i);
                Availability2.Billable_Hours__c = 8;
                newList2.add(Availability2);
            }
            Insert newList2;
            
           
            
            Employee__c Emp3OBJ = New Employee__c();
            Emp3OBJ.Name = 'Employee3';
            Emp3OBJ.Role__c = 'Team Lead';
            Emp3OBJ.designation__c = 'Team Lead';
            Emp3OBJ.Head_of_Department__c = Emp1OBJ.Id;
            Emp3OBJ.Reporting_Manager__c = Emp2OBJ.Id;
            Emp3OBJ.Email__c = 'Emp3@gmail.com';
            Emp3OBJ.Password__c = '1234';
            Emp3OBJ.Emp_Code__c = 'CA110095';
            Emp3OBJ.Date_Of_Joining__c = Date.newInstance(2022, 01, 17);
            Emp3OBJ.DOB__c = Date.newInstance(1947, 06, 28);
            Insert Emp3OBJ;
            
            List<Availability__c> newList3 = New List<Availability__c>();
            For(integer i = 0 ; i <=10 ; i++){
                Availability__c Availability3 = New Availability__c();
                Availability3.Employee__c = Emp3OBJ.ID;
                Availability3.Date__c = system.today().addDays(-i);
                Availability3.Billable_Hours__c = 8;
                Availability3.Task_List__c = 'ABCD';
                Availability3.Status_Update__c = 'DCBA';
                newList3.add(Availability3);
            }
            Insert newList3;
            
            Employee__c Emp4OBJ = New Employee__c();
            Emp4OBJ.Name = 'Employee4';
            Emp4OBJ.Role__c = 'Employee';
            Emp4OBJ.Head_of_Department__c = Emp1OBJ.Id;
            Emp4OBJ.Reporting_Manager__c = Emp2OBJ.Id;
            Emp4OBJ.Team_Lead__c = Emp3OBJ.Id;
            Emp4OBJ.designation__c = 'Employee';
            Emp4OBJ.Email__c = 'Emp4@gmail.com';
            Emp4OBJ.Password__c = '1234';
            Emp4OBJ.Emp_Code__c = 'CA110095';
            Emp4OBJ.Date_Of_Joining__c = Date.newInstance(2022, 01, 17);
            Emp4OBJ.DOB__c = Date.newInstance(1947, 06, 28);
            Insert Emp4OBJ;
            
            List<Availability__c> newList4 = New List<Availability__c>();
            For(integer i = 0 ; i <=10 ; i++){
                Availability__c Availability4 = New Availability__c();
                Availability4.Employee__c = Emp4OBJ.ID;
                Availability4.Date__c = system.today().addDays(-i);
                Availability4.Billable_Hours__c = 8;
                Availability4.Task_List__c = 'ABCD';
                Availability4.Status_Update__c = 'DCBA';
                newList4.add(Availability4);
            }
            Insert newList4;
            
            Availability__c obj6 = New Availability__c();
            obj6.Employee__c = Emp3OBJ.ID;
            obj6.Date__c = system.today();
            obj6.Billable_Hours__c = 11;
            obj6.Task_List__c = 'ABCD';
            obj6.Status_Update__c = 'DCBA';
            newList2.add(obj6);
            
            List<Employee__c> empList = New List<Employee__C>();
            for(Integer i ; i <= 10 ; i++){
                Employee__c emp = New Employee__c();
                emp.Name = 'Employee5';
                emp.Role__c = 'Employee';
                emp.designation__c = 'Employee';
                emp.Emp_Code__c = 'CA110095';
                emp.Date_Of_Joining__c = system.today().addDays(-i);
                emp.DOB__c = system.today();
                empList.add(emp);
            }
            Insert empList;
            
            Certification__c certificateOBJ = New Certification__c();
            certificateOBJ.Name = 'Developer plateform1';
            certificateOBJ.CompletionDate__c = System.today().addDays(-1);
            Insert certificateOBJ;
            
            List<Certification__c> certificateListOBJ = New List<Certification__c>();
            for(Integer i ; i <= 5 ; i++)
            {
                Certification__c certificateOBJ1 = New Certification__c();
                certificateOBJ1.Name = 'Developer plateform1'+1;
                certificateOBJ1.Employee__c = Emp4OBJ.Id;
                certificateOBJ1.CompletionDate__c = System.today().addDays(-1);
            	certificateListOBJ.add(certificateOBJ1);
            }
            
            for(Integer i ; i <= 5 ; i++)
            {
                Certification__c certificateOBJ12 = New Certification__c();
                certificateOBJ12.Name = 'Developer plateform1'+1;
                certificateOBJ12.Employee__c = Emp1OBJ.Id;
                certificateOBJ12.CompletionDate__c = System.today().addDays(-1);
            	certificateListOBJ.add(certificateOBJ12);
            }
            
            for(Integer i ; i <= 5 ; i++)
            {
                Certification__c certificateOBJ12 = New Certification__c();
                certificateOBJ12.Name = 'Developer plateform1'+1;
                certificateOBJ12.Employee__c = Emp2OBJ.Id;
                certificateOBJ12.CompletionDate__c = System.today().addDays(-1);
            	certificateListOBJ.add(certificateOBJ12);
            }
            
            Insert certificateListOBJ;
            
             Policy__c pol1 = New Policy__c();
            pol1.Policy_Created_By__c = Emp1OBJ.Id;
            Pol1.Name = 'Pol';
            Insert pol1;
            
            List<Policy__c> policyList = New List<Policy__c>();
            for(Integer i ; i <=5; i++)
            {
                Policy__c polOBJ = New Policy__c();
                polOBJ.Policy_Created_By__c = Emp1OBJ.Id;
                polOBJ.Name = 'Pol' + i;
                policyList.add(polOBJ);
            }
            Insert policyList;
            
            List<String> strList = New List<String>();
            strList.add('565767');
            strList.add('738233');
            
        
            
            test.startTest();
            WrapperForEmployeePortal.WrapperClass wrapperOBJ = new WrapperForEmployeePortal.WrapperClass();
            
            Employee_login.employee_IdAndPassword('Emp1@gmail.com','1234');
            Employee_login.EmployeeData(Emp1OBJ.Id);
            Employee_login.employee_IdAndPassword('Emp2@gmail.com','1234');
            Employee_login.EmployeeData(Emp2OBJ.Id);
            Employee_login.employee_IdAndPassword('Emp3@gmail.com','1234');
            Employee_login.EmployeeData(Emp3OBJ.Id);
            Employee_login.employee_IdAndPassword('Emp4@gmail.com','1234');
            Employee_login.EmployeeData(Emp4OBJ.Id);
            
            Employee_login.fatchEmployeeDetails(Emp3OBJ.Id);
            Employee_login.TaskMethod('ABCD', 'ABCD', Emp3OBJ.ID, system.today(), 1);
            Employee_login.updateAvilability(Emp3OBJ.ID,6);
            Employee_login.ViewTasksOfEmployee(Emp3OBJ.ID,System.today().addDays(-1),System.today().addDays(1));
            Employee_login.TeamOfRm(Emp3OBJ.ID);
            Employee_login.GetAllDataforCertificationComponent(Emp3OBJ.ID);
            Employee_login.createCertificationRecord('Plateform1','salesforce.com',Emp3OBJ.ID,System.today().addDays(-1));
            Employee_login.deleteCertification(certificateOBJ.Id);
            Employee_login.Dateclass();
            
            Policy.getPolicyData(Emp1OBJ.Id);
            Policy.getPolicyData(Emp2OBJ.Id);
            Policy.getPolicyData(Emp3OBJ.Id);
            Policy.createPolicy('name', strList , Emp2OBJ.Id, 'description');
            Policy.deletePolicy(pol1.Id);
            Policy.getRMData();
            
            PortalAllData.methodName(Emp1OBJ.Id,'1');
            PortalAllData.methodName(Emp2OBJ.Id,'1');
            PortalAllData.methodName(Emp3OBJ.Id,'1');
            PortalAllData.methodName(Emp4OBJ.Id,'1');
            PortalAllData.getBillableHours('1');            
            
            Employee__c emp1 = wrapperOBJ.EmployeeData;
            List<Employee__c> empList11 = wrapperOBJ.Employee_dataBirthday;
            test.stopTest();           
            
        }catch(Exception ee)
        {
            System.debug('Error: At ROW :::' +ee.getMessage()+ 'Line NO.::'+ee.getLineNumber());
        }
    }
}