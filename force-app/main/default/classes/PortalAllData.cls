public without sharing class PortalAllData {
    @AuraEnabled(cacheable = false)
    public static WrapperForEmployeePortal.TeamStructure_wrapperClass methodName(string empId, String selectedOption){
        try {
            system.debug('empId:::'+empId); 
            system.debug('SelectedOption ::: '+selectedOption);
            List<Employee__c> getAllData = [SELECT Id, Name, Team__c, Emp_Code__c,designation__c, Team_Lead__c,  Role__c, Reporting_Manager__c, Head_of_Department__c FROM Employee__c
                                            where Id =: empId];
            Set<Id> setHODId = new Set<Id>();
            Set<Id> SetRmId = new Set<Id>();
            Set<Id> SetTlId = new Set<Id>();
            Set<Id> SetEmployeeId = new Set<Id>();
            Set<Id> SetTLRMData = new Set<ID>();
            WrapperForEmployeePortal.TeamStructure_wrapperClass wrpClassOBJ = New WrapperForEmployeePortal.TeamStructure_wrapperClass();           
            if(getAllData != null)
            {
                for(Employee__c allDataOBJ : getAllData)
                {
                    if(allDataOBJ.designation__c == 'HOD')
                    {
                        setHODId.add(allDataOBJ.Id);
                        system.debug('HOD>>>>>>');
                        wrpClassOBJ.Is_TL_Emp_Trainee = true;
                    }   
                    else if(allDataOBJ.designation__c == 'Reporting Manager')
                    {
                        System.debug('Reporting Manager******');
                        SetRmId.add(allDataOBJ.Id);
                        wrpClassOBJ.Is_TL_Emp_Trainee = true;
                    }else if(allDataOBJ.designation__c == 'Team Lead'){
                        System.debug('Team Lead*****');
                        SetTlId.add(allDataOBJ.Id);
                        wrpClassOBJ.Is_TL_Emp_Trainee = false;
                    }else {
                        System.debug('EMployee&&&&&&&');
                        SetEmployeeId.add(allDataOBJ.Id);
                        wrpClassOBJ.Is_TL_Emp_Trainee = false;
                    }
                }
            }
                        
            Map<Id, Integer> empIdVsBillableHours =  getBillableHours(selectedOption);
            Map<Id, Integer> RMVsEmployeeData = new Map<Id, Integer>();
            Map<Id, Integer> RMVsEmployeeCount = new Map<Id, Integer>();
            system.debug('EMP Map ::: '+empIdVsBillableHours);
            if(! setHODId.isEmpty()){
                Employee__c getHOD = [SELECT Id, Name, Team__c, Designation__c, Team_Lead__c, Reporting_Manager__c,Role__c, Head_of_Department__c,Head_of_Department__r.Name, Tech_BillableHours__c FROM Employee__c WHERE Id IN: setHODId limit 1];
                System.debug('getHoddata>>>'+getHOD);
                if( getHOD != Null){
                    Integer totalBillableHours = 0;                    
                    List<Employee__c> getReportingManagerData = [SELECT Id, Name, Team__c, Designation__c, Team_Lead__c,Date_Of_Joining__c, Head_of_Department__c,Role__c, Reporting_Manager__c, Tech_BillableHours__c,Tech_TeamCountforRM__c FROM Employee__c WHERE Head_of_Department__c =: getHOD.Id AND Designation__c = 'Reporting Manager' ORDER BY Date_Of_Joining__c ASC limit 50000];
                    System.debug('getReportingManager>>>>'+getReportingManagerData);
                    if(! getReportingManagerData.isEmpty())
                    {
                        List<Employee__c> getEmployeeData = [SELECT Id, Name, Team__c, Designation__c, Team_Lead__c,Date_Of_Joining__c, Head_of_Department__c,Role__c, Reporting_Manager__c, Reporting_Manager__r.Name, Tech_BillableHours__c FROM Employee__c WHERE  Reporting_Manager__c IN: getReportingManagerData AND (Designation__c = 'Team Lead' Or Designation__c = 'Employee' Or Designation__c = 'Trainee' ) ORDER BY Date_Of_Joining__c ASC limit 50000];
                        System.debug('EmployeeData>>>>>'+getEmployeeData);
                        if(! getEmployeeData.isEmpty())
                        {              
                            wrpClassOBJ.EmployeeInfo = getEmployeeData;
                            for(Employee__c each : getEmployeeData){
                                if(empIdVsBillableHours != Null && each.Id != Null && empIdVsBillableHours.keyset() != Null && empIdVsBillableHours.get(each.Id) != Null){
                                    each.Tech_BillableHours__c = empIdVsBillableHours.get(each.Id);
                                    System.debug('employee-----'+ each.Tech_BillableHours__c);
                                }                               
                                Integer employeeCount = RMVsEmployeeCount.keyset().contains(each.Reporting_Manager__c)? RMVsEmployeeCount.get(each.Reporting_Manager__c):0;
                                employeeCount+=1;
                                RMVsEmployeeCount.put(each.Reporting_Manager__c, employeeCount);                                
                                
                                Integer teamBillableHours = RMVsEmployeeData.keyset().contains(each.Reporting_Manager__c)? RMVsEmployeeData.get(each.Reporting_Manager__c):0;                              
                                if(each.Tech_BillableHours__c == Null){
                                    each.Tech_BillableHours__c = 0;
                                }
                                teamBillableHours+=Integer.valueOf(each.Tech_BillableHours__c);
                                System.debug('TeamBillableHoursadd>>>'+teamBillableHours);
                                RMVsEmployeeData.put(each.Reporting_Manager__c, teamBillableHours);
                            }                       
                            wrpClassOBJ.rmTeamInfo = getReportingManagerData;
                            wrpClassOBJ.teamBillableHours = 0;
                            for(Employee__c each : getReportingManagerData){                                                           
                                if(RMVsEmployeeData  != Null && RMVsEmployeeData.keyset() != Null && each.Id != Null && RMVsEmployeeData.get(each.Id) != Null){
                                    each.Tech_BillableHours__c = RMVsEmployeeData.get(each.Id);                                  
                                    if(each.Tech_TeamCountforRM__c == Null){
                                        each.Tech_TeamCountforRM__c = 0;
                                    }
                                    each.Tech_TeamCountforRM__c = RMVsEmployeeCount.get(each.Id);                                   
                                    totalBillableHours+=Integer.valueOf(each.Tech_BillableHours__c);
                                    System.debug('TotalBillableHours&&&&'+totalBillableHours);
                                }
                            }                           
                            wrpClassOBJ.HodTeamCount = wrpClassOBJ.rmTeamInfo.size()+wrpClassOBJ.EmployeeInfo.size();
                            System.debug('HoDTeamCount&&&&'+wrpClassOBJ.HodTeamCount);
                        }
                    }
                    wrpClassOBJ.HODdata = getHOD;
                    getHOD.Tech_BillableHours__c = totalBillableHours;
                    wrpClassOBJ.teamBillableHours = Integer.valueOf(getHOD.Tech_BillableHours__c);
                    System.debug('HodBillableData'+getHOD.Tech_BillableHours__c);                   
                }                            
            }
       
            // All Reporting Manager
            
            else if(! setRMId.isEmpty()){
                List<Employee__c> getRMData = [SELECT Id, Name, Team__c, Designation__c, Team_Lead__c, Reporting_Manager__c,Role__c,Tech_BillableHours__c,Date_Of_Joining__c, Head_of_Department__c,Tech_TeamCountforRM__c FROM Employee__c WHERE ID IN: SetRmId limit 1];
               // System.debug('Reporting Manager>>>'+getRMData);
                if(getRMData != null){
                    Integer totalBillableHours = 0;
                    
                    List<Employee__c> getSingleRMEmployeeData = [SELECT Id, Name, Team__c, Designation__c, Team_Lead__c, Head_of_Department__c,Role__c,Tech_BillableHours__c,Date_Of_Joining__c, Reporting_Manager__c FROM Employee__c WHERE Reporting_Manager__c =: getRMData[0].Id ORDER BY Date_Of_Joining__c ASC limit 50000];
                    //System.debug('EmployeeData>>>>'+getSingleRMEmployeeData);
                    if(! getSingleRMEmployeeData.isEmpty())
                    {
                        wrpClassOBJ.EmployeeData = getSingleRMEmployeeData;
                        for(Employee__c each : getSingleRMEmployeeData){
                                if(each.Tech_BillableHours__c == Null)
                                {
                                    each.Tech_BillableHours__c = 0;
                                }
                            if(empIdVsBillableHours != Null && each.Id != Null && empIdVsBillableHours.keyset() != Null && empIdVsBillableHours.get(each.Id) != Null){
                                each.Tech_BillableHours__c = empIdVsBillableHours.get(each.Id);
                                totalBillableHours+= empIdVsBillableHours.get(each.Id);
                               // System.debug('totalBillableHours::::'+totalBillableHours);
                            }
                            Integer employeeCount = RMVsEmployeeCount.keyset().contains(each.Reporting_Manager__c)? RMVsEmployeeCount.get(each.Reporting_Manager__c):0;
                            employeeCount+=1;
                            RMVsEmployeeCount.put(each.Reporting_Manager__c, employeeCount); 
                        }
                    }      
                    wrpClassOBJ.Employee_RMData = getRMData;
                    //System.debug('empIdVsBillableHours>>>>>'+empIdVsBillableHours);
                    for(Employee__c each : getRMData){
                        if(empIdVsBillableHours != Null && each.Id != Null && empIdVsBillableHours.keyset() != Null){
                        
                            each.Tech_BillableHours__c = totalBillableHours;
                            if(each.Tech_TeamCountforRM__c == Null){
                                each.Tech_TeamCountforRM__c = 0;
                            }
                            each.Tech_TeamCountforRM__c = RMVsEmployeeCount.get(each.Id); 
                            // System.debug('billableall::::'+each.Tech_BillableHours__c);
                        }
                    }
                    //System.debug('wrapperClass>>>>'+wrpClassOBJ.Employee_RMData);
                    System.debug('wrapperReportingManager>>>'+getRMData[0]);
                }
            }
            
            //All Team Lead 
            else if(! SetTlId.isEmpty())
            {
                Employee__c getTLData = [SELECT Id, Name, Team__c, Designation__c, Team_Lead__c,Role__c, Reporting_Manager__c FROM Employee__c WHERE Id IN: SetTlId limit 1];
                //System.debug('TLDataSet>>>>>>'+getTLData);
                List<Employee__c> getTLRmID = [SELECT id,Name,Team__c, Designation__c, Team_Lead__c,Role__c, Reporting_Manager__c,Tech_TeamCountforRM__c FROM Employee__c WHERE id =: getTLData.Reporting_Manager__c limit 1];
                //System.debug('TLReportingManager>>>'+getTLRMId);
                if(getTLRmID != null){
                    
                    List<Employee__c> getEmployeeAllData = [SELECT Id, Name, Team__c, Designation__c, Team_Lead__c, Head_of_Department__c,Role__c,Date_Of_Joining__c, Reporting_Manager__c FROM Employee__c WHERE Reporting_Manager__c =: getTLRmID[0].Id ORDER BY Date_Of_Joining__c ASC limit 50000];
                    //System.debug('EmployeeData>>>>'+getEmployeeAllData);
                    if(! getEmployeeAllData.isEmpty())
                    {
                        wrpClassOBJ.EmployeeData = getEmployeeAllData;
                        for(Employee__c each : getEmployeeAllData)
                        {
                            Integer employeeCount = RMVsEmployeeCount.keyset().contains(each.Reporting_Manager__c)? RMVsEmployeeCount.get(each.Reporting_Manager__c):0;
                            employeeCount+=1;
                            RMVsEmployeeCount.put(each.Reporting_Manager__c, employeeCount); 
                        }
                    }
                    wrpClassOBJ.Employee_RMData = getTLRmID;
                    for(Employee__c each : getTLRmID)
                    {
                        if(each.Tech_TeamCountforRM__c == Null){
                            each.Tech_TeamCountforRM__c = 0;
                        }
                        each.Tech_TeamCountforRM__c = RMVsEmployeeCount.get(each.Id);
                    }
                }
            }      
            
            //All Employee
            else if(SetEmployeeId != null)
            {
                Employee__c getsingleEmployeeData = [SELECT Id, Name, Team__c, Designation__c, Team_Lead__c,Role__c, Reporting_Manager__c FROM Employee__c WHERE Id IN: SetEmployeeId limit 1];
                //System.debug('EmployeeData******'+getsingleEmployeeData);
                List<Employee__c> getEmployeeRmID = [SELECT id,Name,Team__c, Designation__c, Team_Lead__c,Role__c, Reporting_Manager__c,Tech_TeamCountforRM__c FROM Employee__c WHERE id =: getsingleEmployeeData.Reporting_Manager__c limit 1];
                //System.debug('EmployeeReportingManagerData>>>'+getEmployeeRMId);
                if(getEmployeeRmID != null){    
                    List<Employee__c> getEmployeeInfo = [SELECT Id, Name, Team__c, Designation__c, Team_Lead__c, Head_of_Department__c,Role__c,Date_Of_Joining__c, Reporting_Manager__c FROM Employee__c WHERE Reporting_Manager__c =: getEmployeeRmID[0].Id ORDER BY Date_Of_Joining__c ASC limit 50000];
                    //System.debug('EmployeeData>>>>'+getEmployeeInfo);
                    if(! getEmployeeInfo.isEmpty())
                    {
                        wrpClassOBJ.EmployeeData = getEmployeeInfo;
                        for(Employee__c each : getEmployeeInfo)
                        {
                            Integer employeeCount = RMVsEmployeeCount.keyset().contains(each.Reporting_Manager__c)? RMVsEmployeeCount.get(each.Reporting_Manager__c):0;
                            employeeCount+=1;
                            RMVsEmployeeCount.put(each.Reporting_Manager__c, employeeCount); 
                        }
                    }
                    wrpClassOBJ.Employee_RMData = getEmployeeRmID;
                    for(Employee__c each : getEmployeeRmID)
                    {
                        if(each.Tech_TeamCountforRM__c == Null){
                            each.Tech_TeamCountforRM__c = 0;
                        }
                        each.Tech_TeamCountforRM__c = RMVsEmployeeCount.get(each.Id);
                    }
                } 
            }
            if(wrpClassOBJ != Null){
                return wrpClassOBJ;
            }
            return null;
        } catch (Exception e) {
            system.debug('Exception:::::'+ e.getMessage()+'at'+ e.getLineNumber()+ 'cause'+e.getCause());
            return null;
        }
    }
    
    @AuraEnabled(cacheable=false)
    public static Map<Id, Integer> getBillableHours(String selectedOption){
        system.debug('selectedOption : '+ selectedOption);
        try{
            //List<Employee__c> employeeList = [select Id, Name from Employee__c limit 50000 ];   //CreatedDate >=: prevdate AND CreatedDate <=:todaydate
            Integer getPicklistMonth = Integer.valueOf(selectedOption);
            date prevdate=System.today().addMonths(-getPicklistMonth);
            //system.debug('prevdate : '+ prevdate);
            date todaydate=System.today();
            //system.debug('todaydate : '+ todaydate);
            Integer daysBw = prevdate.daysBetween(todaydate);
            system.debug('Days Between ::: '+daysBw);
            String query = 'Select Id, Name, Date__c, Employee__c, Billable_Hours__c from Availability__c where CreatedDate = LAST_N_DAYS:'+daysBw+' Limit 50000';
            List<Availability__c> availabilityList = Database.query(query);
            //List<Availability__c> availabilityListList<Availability__c> availabilityList = [select Id, Name, Date__c, Employee__c, Billable_Hours__c from Availability__c where CreatedDate = LAST_N_DAYS:31  Limit 50000];  
            System.debug('avaibilityList>>>>'+availabilityList);
            Map<Id,Integer> EmpIdVsBillableHoursMap = new Map<Id, Integer>();
            for(Availability__c obj:availabilityList)
            {
                system.debug('AVL >>> '+obj);
                if(obj.Billable_Hours__c == null){
                    obj.Billable_Hours__c = 0;  
                }
                
                if(EmpIdVsBillableHoursMap.containsKey(obj.Employee__c))
                {
                    //system.debug('map : '+ EmpIdVsBillableHoursMap.get(obj.Employee__c));
                    Integer addhours=EmpIdVsBillableHoursMap.get(obj.Employee__c)+Integer.valueOf(obj.Billable_Hours__c);
                    System.debug('addhours'+addhours);
                    EmpIdVsBillableHoursMap.put(obj.Employee__c,addhours);
                    
                }
                else
                {
                    EmpIdVsBillableHoursMap.put(obj.Employee__c,Integer.valueOf(obj.Billable_Hours__c));
                }
            }
            system.debug('Map >>> '+EmpIdVsBillableHoursMap);
            if(EmpIdVsBillableHoursMap != Null){
                return EmpIdVsBillableHoursMap;
            }
        }
        catch(Exception ex){
            System.debug('Found Error '+ex.getMessage()+' at Line '+ex.getLineNumber());
            //throw new AuraHandledException(ex.getMessage());
        }
        return Null;
    }   
}