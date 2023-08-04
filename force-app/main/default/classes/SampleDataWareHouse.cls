public class SampleDataWareHouse {
    
    public static void generateSampleData(){
        try{
            List<Project__c> projectList = [Select Id, Name, Client_Name__c from Project__c ];
            List<Employee__c> empList = [select Id, Name from Employee__c ];
            List<Availability__c> avlList = new List<Availability__c>();
            
            Date startDate = Date.newInstance(2023, 01, 01);
            Date endDate  = Date.newInstance(2023, 12, 31);
            Integer i = 0;
            for(Employee__c empObj : empList){
                if(i==projectList.size()-1){
                    i=0;
                }
                for(Date d = startDate; d <= endDate; d=d.addDays(1)){
                    
                    Availability__c avlObj = new Availability__c();
                    avlObj.Date__c = d;
                    avlObj.Employee__c = empObj.Id;
                    avlObj.Project__c = projectList[i].Id;
                    avlObj.Billable_Hours__c = Integer.valueOf((Math.random()*8)+1);
                    avlObj.Actual_Hours__c = Integer.valueOf((Math.random()*12)+1);
                    avlObj.Status_Update__c = '<p>Hi Team,</p><p>Here&#39;s my status update for today.</p><p><br></p><p>Resource Management (Portal Enhancement)</p><p>Worked on the Project Status Tab.</p><p>Gone through the requirements.</p><p>Created a tabular structure to display the Project details.</p><p>Updated the data modal according to the requirement.</p><p>Created the Apex Method to the Controller Class.</p><p>Updated the Portal Wrapper class for Project Status Data.</p><p>Created the Aggregate Query to fetch all the data.</p><p><br></p><p>Thanks</p>';
                    
                    if(avlList.size() == 1000){
                        insert avlList;
                        avlList = null;
                    }
                    avlList.add(avlObj);
                }
                    i+=1;
            }
            
            // insert avlList;
            
            
        }catch(Exception ex){
            system.debug('Sample Data ---> '+ex.getMessage()+' at Line ---> '+ex.getLineNumber());
        }
    }
    
}