import { LightningElement, track } from 'lwc';
import getAlltteamMembers from "@salesforce/apex/PortalAllData.methodName";
// import getBillableMonth from "@salesforce/apex/PortalAllData.getBillableHours";
export default class AllTeam extends LightningElement {
    @track HODData = true;
    @track RMData =[] ;
    @track TlData = [];
    @track allTeamData =[];
    @track showAllTL = false;
    @track showEmployee = false;
    @track selectedOption = "1";
    @track Epmcount=0;
    @track RMTeamInformation = [];
    @track EmployeeInformation = [];
    @track teamBillableHoursData;
    @track HodTeamCountAll;
    @track showBillableHours;

    loading = false;
    
    constructor() {
        try {       
            super()
            console.log(sessionStorage.getItem('id'));
            this.loading = true;
            getAlltteamMembers({ 
                "empId": sessionStorage.getItem('id'),
                "selectedOption" : this.selectedOption
             }).then(result => {
                this.loading = false;
            // console.log(result);
            this.HODData = result.HODdata;
            // console.log('result hoddata'+JSON.stringify(result.HODdata));
            this.RMData = result.Employee_RMData;
            this.TlData = result.Employee_TLData;
            this.allTeamData = result.EmployeeData;
            //this.Epmcount = result.EmployeeData.length();
            //HOD Variable
            this.RMTeamInformation = result.rmTeamInfo;
            this.showBillableHours = result.Is_TL_Emp_Trainee;
            // console.log("SHowing If Billable Hours to be Display ::: ",this.showBillableHours)
            // console.log('Reporting Manager Related Hod&&&&&'+JSON.stringify(this.RMTeamInformation));
            this.EmployeeInformation = result.EmployeeInfo;
            // console.log('Employee Information Related HOD&&&&'+JSON.stringify(this.EmployeeInformation));
            this.teamBillableHoursData = result.teamBillableHours;
            // console.log('All Team Billable Hours&&&&&&'+JSON.stringify(this.teamBillableHoursData));
            this.HodTeamCountAll = result.HodTeamCount;
            // console.log('All Team Count Members&&&&&'+JSON.stringify(this.HodTeamCountAll));
            // console.log('HOD data'+JSON.stringify(this.HODData));
            })
        }
        catch(error){
           console.log("some error in code:", error);
           this.loading = true;
        };   
        
    }
    changeHandler(event) 
    {
    try{
        console.log("Changed Value >>> ",event.target.value);
        this.selectedOption = event.target.value;

        console.log(sessionStorage.getItem('id'));
        this.loading = true;
        getAlltteamMembers({ 
            "empId": sessionStorage.getItem('id'),
            "selectedOption" : this.selectedOption
            }).then(result => {
                this.loading = false;
        console.log(result);
        this.HODData = result.HODdata;
        console.log('result hoddata'+JSON.stringify(result.HODdata));
        this.RMTeamInformation = result.rmTeamInfo;
        this.EmployeeInformation = result.EmployeeInfo;
        //this.Epmcount=result.EmployeeData.length;
        console.log('HOD data'+JSON.stringify(this.HODData));
        })
    }
    catch(error){
            console.log("some error in code:",error);
            this.loading = true;
        };
        
        // try{

        //     const field = event.target.value;
        //     if (field === 'optionSelect') {
        //     this.selectedOption = event.target.value;
        // } 
        // getBillableMonth({"billableMonth" : selectedOption})
        
        // }catch(error){
        //     console.log("some error in code:",error);
        // };
    }
}