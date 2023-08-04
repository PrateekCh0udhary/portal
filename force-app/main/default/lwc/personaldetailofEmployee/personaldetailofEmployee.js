import { LightningElement, track } from 'lwc';
import EmployeeObj from '@salesforce/apex/Employee_login.EmployeeData';
export default class PersonaldetailofEmployee extends LightningElement {
    @track employeeId;
    @track empName;
    @track DOJ;
    @track IdOFEmployee;
    @track Employeecode;
    @track EmplDOb;
    @track deignation;
    @track role;
    @track hod;
    @track rm;
    @track email;
    @track tl;
    @track team;
    @track availability;
    @track experience;
    @track resume;
    @track comm;
    @track gradutaion;
    @track postgrad;
    @track actualExperience;
    @track Extendexperience;
    @track Company;

    loading = false;

    constructor(){
        super()
        sessionStorage.getItem("PDid");
        this.employeeId = sessionStorage.getItem('id');
        sessionStorage.setItem("PDid","PersonalDetail");
        console.log("Session Id Personal Detail-------->",this.employeeId);
        this.loading = true;
        this.ApexCalling();
    }
    ApexCalling(){
        this.loading = true;
        EmployeeObj({
            employeeId: this.employeeId
        })
        .then(result => {
            this.loading = false;
            console.log(JSON.stringify(result.EmployeePD));
            this.empName = result.EmployeePD.Name;
            this.DOJ = result.EmployeePD.Date_Of_Joining__c;
            this.IdOFEmployee = result.EmployeePD.Id;
            this.Employeecode = result.EmployeePD.Emp_Code__c;
            this.EmplDOb = result.EmployeePD.DOB__c;
            this.role = result.EmployeePD.Role__c;
            this.deignation = result.EmployeePD.designation__c;
            if(result.EmployeePD.Head_of_Department__c == null){
                this.hod = 'Not Mentioned';
            }else{
                this.hod = result.EmployeePD.Head_of_Department__r.Name;
            }
            if(result.EmployeePD.Reporting_Manager__c == null){
                this.rm = 'Not Mentioned';
            }else{
                this.rm = result.EmployeePD.Reporting_Manager__r.Name;
            }
            this.email = result.EmployeePD.Email__c;
            if(result.EmployeePD.Team_Lead__c == null){
                this.Tl = 'Not Mentioned';
            }else{
                this.Tl = result.EmployeePD.Team_Lead__r.Name;
            }
            if(result.EmployeePD.designation__c == 'HOD'){
                this.team = 'Head Of Department';
            }else if(result.EmployeePD.designation__c == 'Reporting Manager'){
                this.team = result.EmployeePD.Team__r.Name+'(Head Of Team)';
            }else{
                this.team = result.EmployeePD.Team__r.Name;
            }
            this.availability = result.EmployeePD.Availability__c+' %';
            this.experience = result.EmployeePD.Experience__c;
            this.resume = result.EmployeePD.Resume_Link__c;
            this.comm = result.EmployeePD.Communication_Level_Out_of_10__c;
            this.gradutaion = result.EmployeePD.Graduation_Passing_Year_and_Degree__c;
            this.postgrad = result.EmployeePD.Post_Graduation_Passing_Year_and_Degree__c;
            this.actualExperience = result.EmployeePD.Actual_Experience__c;
            this.Extendexperience = result.EmployeePD.How_much_extended_experience_can_be_show__c;
            this.Company = result.EmployeePD.Owner.Name;
        })
        .then(error => {
            console.log('error>>>> ' + JSON.stringify(error));
            //this.loading = true;
        } )
    }
}