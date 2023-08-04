public without sharing class Employee_login {
    @AuraEnabled(cacheable = false)
    Public Static WrapperForEmployeePortal.WrapperClass employee_IdAndPassword(String username, String password){
        try{
            string IdOfEmployee;
            Employee__c employeeObj = New Employee__c();
            Date datefirstOfMonth = date.newInstance(system.today().year(), system.today().month(), 01);
            Date Currentdate = system.today();
            
            system.debug('Username>>>> '+username+'password>>>>> '+password);
            List<Employee__c> employeeList = New List<Employee__c>();
            employeeList = [Select Id,Name,Email__c,Password__c from Employee__c where Email__c != Null AND Password__c != Null Limit 50000];
            if(username != null && password != null){
                if(! employeeList.isEmpty()){
                    for(Employee__c each : employeeList){
                        if(each.Email__c == username){
                            system.debug('Username is Matched');
                            if(each.Password__c == password){
                                system.debug('Username ---> '+each.Email__c+' Parsword ----> '+each.Password__c);
                                IdOfEmployee = each.Id;
                            }
                        }
                    } 
                }
            }
            if(IdOfEmployee != Null){
                employeeObj=[SELECT Id, Name, Date_Of_Joining__c, DOB__c, Emp_Code__c, Billable_Status__c, Experience__c, Role__c, Team__r.Name, Availability__c, Password__c, Email__c, Communication_Level_Out_of_10__c, Graduation_Passing_Year_and_Degree__c, Post_Graduation_Passing_Year_and_Degree__c, Resume_Link__c, Actual_Experience__c, How_much_extended_experience_can_be_show__c, Team_Lead__c, Reporting_Manager__c, Head_of_Department__c FROM Employee__c 
                             where Id =: IdOfEmployee Limit 1];
                
            }
            system.debug('Employe name-----> '+IdOfEmployee);
            
            WrapperForEmployeePortal.WrapperClass wrpclass = New WrapperForEmployeePortal.WrapperClass();
            if(employeeObj != Null){
                wrpclass.EmployeeData = employeeObj; 
                wrpclass.todaysdate = Currentdate;
                wrpclass.FirstDate = datefirstOfMonth;
            }
            return wrpclass;
        }Catch(Exception ex){
            system.debug('Exception is '+ex.getMessage()+' At Line No. '+ex.getLineNumber());
        }
        return Null;
    }
    @AuraEnabled(cacheable = false)
    public static WrapperForEmployeePortal.WrapperClass EmployeeData(String employeeId){
        try{
            system.debug('EmpId>>>>>>>'+employeeId);
            system.debug('Data Method');
            List<Employee__c> EmpBirthListvalue = New List<Employee__c>();
            EmpBirthListvalue = [Select Id, Name, DOB__c, Emp_Code__c, Team__r.Name,Role__c, designation__c From Employee__c Where DOB__c != Null Limit 50000];
            List<Employee__c> EmpBirthList = New List<Employee__c>();
            if(! EmpBirthListvalue.isEmpty()){
                for(Employee__c each : EmpBirthListvalue){
                    if(each.DOB__c.day() == system.today().day() && each.DOB__c.month() == system.today().month()){
                        EmpBirthList.add(each);
                        system.debug('birthday today '+each.Name);
                    }
                }
            }
            Employee__c employeeObj = New Employee__c();
            employeeObj=[SELECT Id, Name, Date_Of_Joining__c, DOB__c, Emp_Code__c, designation__c, Billable_Status__c, Experience__c, Role__c, Team__r.Name, Availability__c, Password__c, Email__c, Communication_Level_Out_of_10__c, Graduation_Passing_Year_and_Degree__c, Post_Graduation_Passing_Year_and_Degree__c, Resume_Link__c, Actual_Experience__c, How_much_extended_experience_can_be_show__c, Team_Lead__c, Reporting_Manager__c, Head_of_Department__c FROM Employee__c 
                         where Id =: employeeId Limit 1];
            
            Employee__c employeeObjForPersonaldetail = New Employee__c();
            employeeObjForPersonaldetail = [SELECT Id, Name, Date_Of_Joining__c, Billable_Status__c, Resume_Link__c, Experience__c, Role__c, Team__c, Team__r.Name, Availability__c, Password__c, Email__c, Communication_Level_Out_of_10__c, Graduation_Passing_Year_and_Degree__c, Post_Graduation_Passing_Year_and_Degree__c, Actual_Experience__c, How_much_extended_experience_can_be_show__c, Team_Lead__c, Team_Lead__r.Name, Reporting_Manager__c, Reporting_Manager__r.Name, Head_of_Department__c, Head_of_Department__r.Name, Emp_Code__c, DOB__c, designation__c, Tech_BillableHours__c, Owner.Name FROM Employee__c where Id =: employeeId Limit 1];
            
            WrapperForEmployeePortal.WrapperClass wrpclass = New WrapperForEmployeePortal.WrapperClass();
            
            //Today's Date To This month Starting date;
            Date datefirstOfMonth = date.newInstance(system.today().year(), system.today().month(), 01);
            Date Currentdate = system.today();
            List<Date> dateList = New List<Date>();
            if(datefirstOfMonth != Null && Currentdate != Null){
                for(Integer i=0;i<=datefirstOfMonth.daysBetween(Currentdate);i++){
                    dateList.add(datefirstOfMonth.addDays(i));
                }
            }
            
            if(employeeObj != Null){
                Integer YesterdayAvgAvailability = 0;
                Integer yesterdayBillableHr = 0;
                Integer MonthbillableHr = 0;
                if(employeeObj.designation__c == 'Reporting Manager' || employeeObj.designation__c == 'HOD')
                {	
                    if(employeeObj.designation__c == 'Reporting Manager'){
                        wrpclass.Hod_RMData = employeeObj;
                        List<Employee__c> RmandHODteam = New List<Employee__c>();
                        RmandHODteam = [SELECT Id, Name, Date_Of_Joining__c, DOB__c, Emp_Code__c, Billable_Status__c, Experience__c, Role__c, Team__r.Name, Availability__c, Password__c, Email__c, Communication_Level_Out_of_10__c, Graduation_Passing_Year_and_Degree__c, Post_Graduation_Passing_Year_and_Degree__c, Resume_Link__c, Actual_Experience__c, How_much_extended_experience_can_be_show__c, Team_Lead__c, Reporting_Manager__c, Head_of_Department__c FROM Employee__c
                                        Where Reporting_Manager__r.Id =: employeeObj.Id Limit 50000];
                        //For Yesterday Availability
                        AggregateResult[] groupedResults = [SELECT Employee__r.Reporting_Manager__c, AVG(Availability__c) FROM Availability__c WHERE 
                                                            Employee__r.Reporting_Manager__c =: employeeObj.Id AND Date__c =: System.today().addDays(-1) GROUP BY Employee__r.Reporting_Manager__c];
                        System.debug('groupedResults>>>>> '+groupedResults);
                        if(! groupedResults.isEmpty()){
                            YesterdayAvgAvailability = integer.valueof(groupedResults[0].get('expr0'));
                            System.debug('YesterdayAvgAvailability>>>>> of RM '+YesterdayAvgAvailability);
                            wrpclass.avgYesterdayAvl = YesterdayAvgAvailability;
                        }
                        //for Yesterday Billable Hours
                        AggregateResult[] totalBillableYesterday = [SELECT Employee__r.Reporting_Manager__c, SUM(Billable_Hours__c) FROM Availability__c WHERE 
                                                                    Employee__r.Reporting_Manager__c =: employeeObj.Id AND Date__c =: System.today().addDays(-1) GROUP BY Employee__r.Reporting_Manager__c];
                        system.debug('Yesterday billable Hours'+totalBillableYesterday);
                        if(! totalBillableYesterday.isEmpty()){
                            yesterdayBillableHr = integer.valueOf(totalBillableYesterday[0].get('expr0'));
                            System.debug('yesterdayBillableHr of RM >>>>>>'+yesterdayBillableHr);
                            wrpclass.YesterdayBillableHR = yesterdayBillableHr;
                        }
                        //This Month Billable Hours
                        if(! RmandHODteam.isEmpty()){
                            List<Availability__c> avalList = New List<Availability__c>();
                            avalList = [SELECT Id, Employee__c, Employee__r.Name, Date__c, Billable_Hours__c, Availability__c FROM Availability__c Where Employee__c != Null AND Employee__r.Id In: RmandHODteam And Date__c In: dateList Limit 50000];
                            if(! avalList.isEmpty()){
                                for(Availability__c avl : avalList){
                                    system.debug('Date-- '+avl.Date__c+' Name: '+avl.Employee__r.Name+' Billable hr-- '+avl.Billable_Hours__c);
                                    if(avl.Billable_Hours__c != Null){
                                        MonthbillableHr += Integer.valueOf(avl.Billable_Hours__c); 
                                    }
                                }
                                if(MonthbillableHr != Null && !(MonthbillableHr < 0)){
                                    system.debug('Total billable hr-----'+MonthbillableHr);
                                    wrpclass.ThisMonthBilableHr = MonthbillableHr;
                                }
                            }
                        }
                    }else
                        If(employeeObj.designation__c == 'HOD'){
                            wrpclass.Hod_RMData = employeeObj;
                            List<Employee__c> RmandHODteam = New List<Employee__c>();
                            RmandHODteam = [SELECT Id, Name, Date_Of_Joining__c, DOB__c, Emp_Code__c, Billable_Status__c, Experience__c, Role__c, Team__r.Name, Availability__c, Password__c, Email__c, Communication_Level_Out_of_10__c, Graduation_Passing_Year_and_Degree__c, Post_Graduation_Passing_Year_and_Degree__c, Resume_Link__c, Actual_Experience__c, How_much_extended_experience_can_be_show__c, Team_Lead__c, Reporting_Manager__c, Head_of_Department__c FROM Employee__c
                                            Where Head_of_Department__r.Id =: employeeObj.Id Limit 50000];
                            
                            AggregateResult[] groupedResults = [SELECT Employee__r.Head_of_Department__c, AVG(Availability__c) FROM Availability__c WHERE 
                                                                Employee__r.Head_of_Department__c =: employeeObj.Id AND Date__c =: System.today().addDays(-1) GROUP BY Employee__r.Head_of_Department__c];
                            System.debug('groupedResults>>>>> of HOD '+groupedResults);
                            if(! groupedResults.isEmpty()){
                                YesterdayAvgAvailability = integer.valueof(groupedResults[0].get('expr0'));
                                System.debug('YesterdayAvgAvailability>>>>> of HOD '+YesterdayAvgAvailability);
                                wrpclass.avgYesterdayAvl = YesterdayAvgAvailability;
                            }
                            
                            //for Yesterday Billable Hours
                            AggregateResult[] totalBillableYesterday = [SELECT Employee__r.Head_of_Department__c, SUM(Billable_Hours__c) FROM Availability__c WHERE 
                                                                        Employee__r.Head_of_Department__c =: employeeObj.Id AND Date__c =: System.today().addDays(-1) GROUP BY Employee__r.Head_of_Department__c];
                            system.debug('Yesterday billable Hours'+totalBillableYesterday);
                            if(! totalBillableYesterday.isEmpty()){
                                yesterdayBillableHr = integer.valueOf(totalBillableYesterday[0].get('expr0'));
                                System.debug('yesterdayBillableHr of RM >>>>>>'+yesterdayBillableHr);
                                wrpclass.YesterdayBillableHR = yesterdayBillableHr;
                            }
                            //This month Billable Hours
                            
                            if(! RmandHODteam.isEmpty()){
                                List<Availability__c> avalList = New List<Availability__c>();
                                avalList = [SELECT Id, Employee__c, Employee__r.Name, Date__c, Billable_Hours__c,Actual_Hours__c, Availability__c FROM Availability__c Where Employee__c != Null AND Employee__r.Id In: RmandHODteam And Date__c In: dateList Limit 50000];
                                if(! avalList.isEmpty()){
                                    for(Availability__c avl : avalList){
                                        system.debug('Date-- '+avl.Date__c+' Name: '+avl.Employee__r.Name+' Billable hr-- '+avl.Billable_Hours__c);
                                        if(avl.Billable_Hours__c != Null){
                                            MonthbillableHr += Integer.valueOf(avl.Billable_Hours__c); 
                                        }
                                    }
                                    if(MonthbillableHr != Null && !(MonthbillableHr < 0)){
                                        system.debug('Total billable hr-----'+MonthbillableHr);
                                        wrpclass.ThisMonthBilableHr = MonthbillableHr;
                                    }
                                }
                            }
                            
                        }
                    Map<Id, Decimal> empIdVsAvgAvailability = new Map<Id, Decimal>();
                    Map<Id, Integer> IdVsCountMap = new Map<Id, Integer>();
                    List<Employee__c> TeamData = New List<Employee__c>();
                    TeamData = [SELECT Id, Name, Date_Of_Joining__c, DOB__c, Emp_Code__c, Billable_Status__c, Experience__c, Role__c, Team__r.Name, Availability__c, Password__c, Email__c, Communication_Level_Out_of_10__c, Graduation_Passing_Year_and_Degree__c, Post_Graduation_Passing_Year_and_Degree__c, Resume_Link__c, Actual_Experience__c, How_much_extended_experience_can_be_show__c, Team_Lead__c, Reporting_Manager__c, Head_of_Department__c FROM Employee__c
                                Where Head_of_Department__r.Id =: employeeObj.Id OR Reporting_Manager__r.Id =: employeeObj.Id Limit 50000];
                    List<Availability__c> RmandHodTeamAvailList = New List<Availability__c>();
                    if(! TeamData.isEmpty()){
                        RmandHodTeamAvailList = [SELECT Id, Employee__c, Employee__r.Name, Date__c, Billable_Hours__c, Actual_Hours__c ,Availability__c FROM Availability__c Where Employee__c != Null AND Employee__r.Id In: TeamData And Date__c = THIS_MONTH Limit 50000];
                        if(! RmandHodTeamAvailList.isEmpty()){
                            //Integer availabilityCount = 0;
                            for(Availability__c each : RmandHodTeamAvailList){
                                Decimal avg = empIdVsAvgAvailability.keyset().contains(each.Employee__c) ? empIdVsAvgAvailability.get(each.Employee__c) : 0;
                                Integer count = IdVsCountMap.keyset().contains(each.Employee__c) ? IdVsCountMap.get(each.Employee__c) : 0;
                                count+=1;
                               // availabilityCount+=1;
                                avg=(avg*(count-1)+each.Availability__c)/count;
                                empIdVsAvgAvailability.put(each.Employee__c, avg);
                                IdVsCountMap.put(each.Employee__c, count);
                            }
                        }
                    }
                    List<Employee__c> Emp_willingToProject = New List<Employee__c>();
                    List<Employee__c> TempList = New List<Employee__c>();
                    Map<Id, Integer> finalMap = New Map<Id, Integer>();
                    SYstem.debug('Printing All the Avg Availability Map...');
                    if(TeamData != Null){
                        for(Employee__c each : TeamData){
                        if(empIdVsAvgAvailability != Null && empIdVsAvgAvailability.keyset() != Null && each.Id != Null && empIdVsAvgAvailability.get(each.Id) != Null ){
                            if(empIdVsAvgAvailability.get(each.Id) >=30){
                                System.debug('Employee  >> '+each.Name+'  :  Avg  >> '+empIdVsAvgAvailability.get(each.Id));
                                TempList.add(each);
                                finalMap.put(each.id,integer.valueOf(empIdVsAvgAvailability.get(each.Id)));
                            }
                        }
                            if(each.Availability__c > 10){
                                Emp_willingToProject.add(each);
                            }
                        }
                        
                    }
                    if(! finalMap.isEmpty() && finalMap != Null && finalMap.keyset() != Null && TempList != Null){
                        system.debug('Yessssss Exist');
                        wrpclass.wrapperMap = finalMap;
                        wrpclass.wrapperTeam = TempList;
                    }
                    if(! Emp_willingToProject.isEmpty()){
                        wrpclass.ProjectWillingEmp = Emp_willingToProject;
                    }
                }
            }
            
            List<Availability__c>  AvailabilityBillable = New List<Availability__c>();
            AvailabilityBillable = [Select Id, Task_List__c, Status_Update__c, Employee__c, Date__c, Billable_Hours__c, Actual_Hours__c From Availability__c where Employee__c =: employeeId And Date__c In: dateList  Limit 50000];
            
            List<Availability__c>  AvailabilityView = New List<Availability__c>();
            AvailabilityView = [Select Id, Task_List__c, Status_Update__c, Employee__c, Date__c, Billable_Hours__c, Actual_Hours__c From Availability__c where Employee__c =: employeeId And Date__c =: system.today() Limit 50000];
            if(! AvailabilityView.isEmpty()){
                for(Availability__c av : AvailabilityView){
                    if(av.Task_List__c != Null){
                        wrpclass.showTaskList = av;
                    }
                }
            }
            if(! AvailabilityBillable.IsEmpty()){
                Decimal TotalBillableHours = 0;
                for(Availability__c avb : AvailabilityBillable){
                    if(avb.Billable_Hours__c > 0 && avb.Billable_Hours__c != Null){
                        TotalBillableHours += avb.Billable_Hours__c;
                    }
                }
                wrpclass.totBillableHour = TotalBillableHours;
            }
            if(EmpBirthList != Null){
                wrpclass.Employee_dataBirthday = EmpBirthList;
            }
            if(employeeObjForPersonaldetail != Null){
                wrpclass.EmployeePD = employeeObjForPersonaldetail; 
            }
            if(employeeObj != Null){
                wrpclass.EmployeeData = employeeObj; 
                wrpClass.todaysdate = Currentdate;
            }
            return wrpclass;
            
        }Catch(Exception ex){
            system.debug('Exception is '+ex.getMessage()+' At Line No. '+ex.getLineNumber());
        }
        return Null;
    }
    @AuraEnabled(cacheable = false)
    Public Static WrapperForEmployeePortal.Availability_wrapperCalss TaskMethod(String taskListValue, String statusUpdatevalue, String EmployeeID, Date TodaysDate, Integer Billablehour, Integer ActualHour){
        try{
            system.debug('Task Method Call');
            WrapperForEmployeePortal.Availability_wrapperCalss wrp = New WrapperForEmployeePortal.Availability_wrapperCalss();
            
            List<Availability__c> AvalList = New List<Availability__c>();
            List<Availability__c> avalObjList = New List<Availability__c>();
            avalObjList = [Select Id, Employee__c, Date__c from Availability__c Where Employee__c =: EmployeeID And Date__c =: TodaysDate Limit 1];
            if(avalObjList != Null && !(avalObjList.isEmpty())){
                Availability__c avalObj = New Availability__c();
                avalObj.Id = avalObjList[0].Id;
                avalObj.Employee__c = EmployeeID;
                avalObj.Task_List__c = taskListValue;
                avalObj.Status_Update__c = statusUpdatevalue;
                avalObj.Billable_Hours__c = Billablehour;
                avalObj.Actual_Hours__c = ActualHour;
                AvalList.add(avalObj);
            }else{
                Availability__c avalObjNew = New Availability__c();
                avalObjNew.Employee__c = EmployeeID;
                avalObjNew.Task_List__c = taskListValue;
                avalObjNew.Status_Update__c = statusUpdatevalue;
                avalObjNew.Date__c = TodaysDate;
                avalObjNew.Billable_Hours__c = Billablehour;
                avalObjNew.Actual_Hours__c = ActualHour;
                AvalList.add(avalObjNew);
                
            }
            
            if(AvalList != Null && !(AvalList.isEmpty())){
                system.debug('Upsert Successfully');
                Upsert AvalList;
                wrp.InsertandUpdateTasks = AvalList;
            }
            return wrp;
        }catch(Exception ex){
            system.debug('Exception is '+ex.getMessage()+' At Line No. '+ex.getLineNumber());   
        }
        return Null;
    }
    @AuraEnabled(cacheable = false)
    public static List<Employee__c> fatchEmployeeDetails(String empId){
        try{
            system.debug('empId:::::::::'+empId);
            Set<Id> teamLeadId=new Set<Id>();
            List<Employee__c> getTeamLeadId=new List<Employee__c>();
            getTeamLeadId=[SELECT Team_Lead__c FROM Employee__c Where Id =:empId];
            System.debug('-----'+getTeamLeadId);
            for(Employee__c emp:getTeamLeadId){
                teamLeadId.add(emp.Team_Lead__c);
            }
            List<Employee__c> listOfEmployeeDetails=new List<Employee__c>();
            listOfEmployeeDetails=[SELECT Id, Name, Team_Lead__c, Emp_Code__c, Role__c ,Team_Lead__r.Name,
                                   Team_Lead__r.Role__c,Team_Lead__r.Emp_Code__c
                                   FROM Employee__c Where Team_Lead__c in:teamLeadId];
            System.debug('>>>>'+listOfEmployeeDetails);
            return listOfEmployeeDetails;
        }
        catch(Exception ex){
            System.debug('Exception--'+ex.getMessage()+''+ex.getLineNumber());
        }
        return null;
    }
   
    @AuraEnabled(cacheable = false)
    public static void updateAvilability(string id , Decimal avil){
        Employee__c emp = new Employee__c();
        emp.Id =id;
        emp.Availability__c=avil;
        update emp;
    }
    @AuraEnabled(cacheable = false)
    public static WrapperForEmployeePortal.Task_cmp_wrapper ViewTasksOfEmployee(string EmpId, date StartDate, date Enddate){
        try{
            WrapperForEmployeePortal.Task_cmp_wrapper wrp = New WrapperForEmployeePortal.Task_cmp_wrapper();
            Employee__c empData = [SELECT Id, Name, Date_Of_Joining__c, DOB__c, Emp_Code__c, designation__c, Billable_Status__c, Experience__c, Role__c, Team__r.Name, Availability__c, Password__c, Email__c, Communication_Level_Out_of_10__c, Graduation_Passing_Year_and_Degree__c, Post_Graduation_Passing_Year_and_Degree__c, Resume_Link__c, Actual_Experience__c, How_much_extended_experience_can_be_show__c, Team_Lead__c, Reporting_Manager__c, Head_of_Department__c FROM Employee__c 
                                   where Id =: EmpId Limit 1];
            if(empData != Null){
                wrp.EmployeeData = empData;
            }
            List<Employee__c> EmpList = New List<Employee__c>();
            
            List<Employee__c> RmListforHOD = New List<Employee__c>();
            If(empData.designation__c == 'HOD' || empData.designation__c == 'Reporting Manager'){
                EmpList = [SELECT Id, Name, Date_Of_Joining__c, DOB__c, Emp_Code__c, designation__c, Billable_Status__c, Experience__c, Role__c, Team__r.Name, Availability__c, Password__c, Email__c, Communication_Level_Out_of_10__c, Graduation_Passing_Year_and_Degree__c, Post_Graduation_Passing_Year_and_Degree__c, Resume_Link__c, Actual_Experience__c, How_much_extended_experience_can_be_show__c, Team_Lead__c, Reporting_Manager__c, Head_of_Department__c FROM Employee__c 
                                   where Reporting_Manager__r.Id =: empData.Id OR Head_of_Department__r.Id =: empData.Id  Limit 50000];
                if(empData.designation__c == 'HOD'){
                    if(! EmpList.isEmpty()){
                        for(Employee__c each : EmpList){
                            if(each.designation__c == 'Reporting Manager'){
                               RmListforHOD.add(each);
                            }
                        }
                    }
                }
                if(! EmpList.isEmpty()){
                    wrp.EmpUnderRm = EmpList;
                    wrp.RmUnderHOd = RmListforHOD;
                }
                
            }else{
                List<Availability__c> availList = New List<Availability__c>();
                Set<Date> datesBetweenStartEnd = new Set<Date>();
                if(EmpId != Null){
                    if(StartDate != Null && Enddate != Null){
                        for(Integer i=0;i<=StartDate.daysBetween(Enddate);i++){
                            datesBetweenStartEnd.add(StartDate.addDays(i));
                        } 
                        availList = [SELECT Id, Billable_Hours__c, Actual_Hours__c , Date__c, Availability__c, Employee__c, Task_List__c, Status_Update__c FROM Availability__c where Employee__c =: EmpId AND Date__C In : datesBetweenStartEnd ORDER BY Date__c DESC Limit 50000];
                    }else{
                        availList = [SELECT Id, Billable_Hours__c, Actual_Hours__c , Date__c, Availability__c, Employee__c, Task_List__c, Status_Update__c FROM Availability__c where Employee__c =: EmpId ORDER BY Date__c DESC Limit 50000];
                    }
                }
                if(! availList.isEmpty()){
                    wrp.AvailDataListForEmp = availList;
                    //return availList;
                }
            }
            if(wrp != Null){
                return wrp;
            }   
        }catch(exception ee){
            System.debug('Error>>>' + ee.getMessage() +'at'+ee.getLineNumber());
        }
        return Null;
    }
    @AuraEnabled(cacheable=true)
    Public static List<Employee__c> TeamOfRm(string RMId){
        try{
            if(RMId != Null && RMId != ''){
                List<Employee__c> empData = New List<Employee__c>();
                empData = [Select Id, Name, Reporting_Manager__c From Employee__c Where Reporting_Manager__r.Id =: RMId AND Reporting_Manager__c != Null Limit 50000];
                if(! empData.isEmpty()){
                    return empData;
                }
            }
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return Null;
    }
    
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    @AuraEnabled
    public static WrapperForEmployeePortal.AllDataforCertificationComponent GetAllDataforCertificationComponent (String empId){
        try{
            System.debug('Current Record Id >>> '+ empId);
            if(empId != Null){
                WrapperForEmployeePortal.AllDataforCertificationComponent wrapperObj = new WrapperForEmployeePortal.AllDataforCertificationComponent();
                Employee__c employeeObj = [select Id, Name, designation__c, DOB__c from Employee__c where Id =: empId limit 1];
                List<Certification__c> certificationList = new List<Certification__c>();
                certificationList = [select Id, Name, Certification_Link__c, CompletionDate__c from Certification__c where Employee__c =: empId limit 50000];
                if(!certificationList.isEmpty()){
                    System.debug(certificationList);
                    wrapperObj.certificationList = certificationList;
                    // return certificationList;
                }
                if(employeeObj != Null){
                    wrapperObj.currentEmployee = employeeObj;
                    if(employeeObj.designation__c == 'HOD' || employeeObj.designation__c == 'Reporting Manager'){
                        List<AggregateResult> distinctCertifications = [select count(Id), Name from Certification__c Group By Name limit 50000];
                        if(distinctCertifications != Null){
                            List<String> tempList = new List<String>();
                            for(AggregateResult rs : distinctCertifications){
                                String tempName = String.valueOf(rs.get('Name'));
                                system.debug('Name >> '+tempName);
                                tempList.add(tempName);
                            }
                            System.debug('UNITQUE NAMESS>... '+tempList);
                            wrapperObj.certificationNames = tempList;
                        }
                        List<Certification__c> teamCertificationList = [select Id, Name, Certification_Link__c, CompletionDate__c, Employee__r.Name, Employee__r.Reporting_Manager__r.Name from Certification__c
                                                                        where  (Employee__r.Head_of_Department__c =: empId) OR (Employee__r.Reporting_Manager__c =: empId) limit  50000];
                        
                        
                        if(teamCertificationList != Null){
                            List<WrapperForEmployeePortal.TeamCertification> wrapperObjList = new List<WrapperForEmployeePortal.TeamCertification>();
                            for(Certification__c each: teamCertificationList){
                                WrapperForEmployeePortal.TeamCertification teamCertificationWrapper = new WrapperForEmployeePortal.TeamCertification();
                                teamCertificationWrapper.Name = each.Name;
                                teamCertificationWrapper.CertificationLink = each.Certification_Link__c;
                                teamCertificationWrapper.CompletionDate = each.CompletionDate__c;
                                teamCertificationWrapper.EmployeeName = each.Employee__r.Name;
                                teamCertificationWrapper.ReportingManager = each.Employee__r.Reporting_Manager__r.Name;
                                wrapperObjList.add(teamCertificationWrapper);
                                system.debug('Name : '+each.Name+' , Employee : '+each.Employee__r.Name+' , Team Head : '+each.Employee__r.Reporting_Manager__r.Name);
                            }
                              
                            if(wrapperObjList != Null){
                                wrapperObj.teamCertificationList = wrapperObjList;
                            }
                        }
                    }
                }
                if(wrapperObj != Null){
                    return wrapperObj;
                }
            }
        }catch(Exception ex){
            System.debug('Found Error in Get All Data :: '+ex.getMessage()+' at Line :: '+ex.getLineNumber());
                        throw new AuraHandledException(ex.getMessage());
        }
        return Null;
    }
    
    
    @AuraEnabled
    public static String createCertificationRecord(String name, String link, String empId, Date dateOfCompletion){
        try {
            System.debug('Create Certification Called....');
            if(name != Null && empId != Null && dateOfCompletion != Null){
                Certification__c certificationObj = new Certification__c();
                certificationObj.Name = name;
                certificationObj.Certification_Link__c = link;
                certificationObj.Employee__c = empId;
                certificationObj.CompletionDate__c = dateOfCompletion;
                
                insert certificationObj;
                return certificationObj.Id;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return Null;
        
    }
    
    
    @AuraEnabled
    public static boolean deleteCertification(String cerId){
        try{
            if(cerId != Null){
                List<Certification__c> certificationList = [select Id, Name from Certification__c where Id =: cerId];
                if(!certificationList.isEmpty()){
                    delete certificationList;
                    return true;
                }
            }    
        }catch(Exception ex){
            System.debug('Found Error in Deletion Method ::: '+ex.getMessage()+' at Line '+ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        return false;
    }
    
    @AuraEnabled
    public static boolean updateCertification(String parameterString){
        try{
            if(parameterString != Null){
             	List<Certification__c> certificationList = (List<Certification__c>)JSON.deserialize(parameterString, List<Certification__c>.class);
                if(!certificationList.isEmpty()){
                    update certificationList;
                    return true;
                }
            }
        }catch(Exception ex){
            System.debug('Found Error in Deletion Method ::: '+ex.getMessage()+' at Line '+ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
        return false;
    }
    
    
    
   
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
    @AuraEnabled(cacheable=true)
    Public static WrapperForEmployeePortal.WrapperClass Dateclass(){
        try{
            Date datefirstOfMonth = date.newInstance(system.today().year(), system.today().month(), 01);
            Date Currentdate = system.today();
            WrapperForEmployeePortal.WrapperClass wpObj = New WrapperForEmployeePortal.WrapperClass();
            wpObj.todaysdate = Currentdate;
            wpObj.FirstDate = datefirstOfMonth;
            if(wpObj != Null){
                return wpObj;
            }
            
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return Null;
    }

//-------------------------------------------------------------------------- For Project status---------------------------------------------------------
    
    @AuraEnabled(cacheable=true)
    public static List<WrapperForEmployeePortal.projectDetails> getProjectStatus(){
        try{
            List<WrapperForEmployeePortal.projectDetails> projectList = new List<WrapperForEmployeePortal.projectDetails>();
            List<Project__c> AllprojectName = New List<Project__c>(); // try to query record on availability.
            AllprojectName = [Select Id, Name, Client_Name__c , (Select Id,Actual_Hours__c, Availability__c, Billable_Hours__c, Date__c, Employee__c, Employee__r.Name, Employee__r.Team__r.Name, RecordTypeId, RecordType.Name from Availability__r ) from Project__c  Limit 50000];
            if(! AllprojectName.isEmpty()){
                Decimal totalBillableHours = 0, totalActualHours = 0;
                for(Project__c pObj : AllprojectName){
                    WrapperForEmployeePortal.projectDetails detailObj = new WrapperForEmployeePortal.projectDetails();
                    detailObj.Id = pObj.Id;
                    detailObj.Name = pObj.Name;
                    detailObj.ClientName = pObj.Client_Name__c;
                    
                    for(Availability__c avlObj : pObj.Availability__r){
                        totalBillableHours+= avlObj.Billable_Hours__c;
                        totalActualHours+= avlObj.Actual_Hours__c;
                    }
                    
                    detailObj.totalBillableHours = totalBillableHours;
                    detailObj.totalActualHours = totalActualHours;
                    
                    projectList.add(detailObj);
                }
                
                
                return projectList;
            }
            
            /*List<Assigned_Project__c> assignedProject = [select Id, Name , Project__c, Employee__c from Assigned_Project__c where Project__c IN: AllprojectName limit 50000];
if(!assignedProject.isEmpty()){

}*/
            
            
        }catch (Exception e) {
            throw new AuraHandledException(e.getMessage());            
        }
        return null;
    }
    
}