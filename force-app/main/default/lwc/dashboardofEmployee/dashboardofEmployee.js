import { LightningElement, track, wire, api } from 'lwc';
import Cloud_Image from '@salesforce/resourceUrl/CloudImage';
import logindata from '@salesforce/apex/Employee_login.EmployeeData';
import TaskMethod from '@salesforce/apex/Employee_login.TaskMethod';
import updateAvilability from '@salesforce/apex/Employee_login.updateAvilability';

const columns = [
{label : 'Name', fieldName : 'Obj', type : 'text'},
{label : 'Employee Code', fieldName : 'Empcode'},
{label : 'Designation', fieldName : 'Role'},
{label : 'Average Availability', fieldName : 'Avl'}
];

const colForEmp = [
{label : 'Name', fieldName : 'Name', type : 'text'},
{label : 'Employee Code', fieldName : 'Emp_Code__c'},
{label : 'Designation', fieldName : 'Role__c'},
{label : 'Availability in %', fieldName : 'Availability__c', type : 'percentage'}
]

export default class DashboardofEmployee extends LightningElement {

cloudfulImg = Cloud_Image + '/logo.png';
cakeImg = Cloud_Image + '/imgcake.png';
birthdayImg = Cloud_Image + '/background.jpg';
@track updateAvil = false;
ShowBirthday = false;
showTaskTable = true;
innnerDataofCard = false;
innnerDataofCardBH = false;
@track mployeeIddata;
@api employeeId;
@track listOfAccounts;
columns = columns;
colForEmp = colForEmp;
rowOffset = 0;

//Objects that Show data in dashboard
@track EmployeeName;
@track EmployeeDOJ;
@track DesignationOfEmp;
@track EmployeeTeam;
@track EmployeeCode;
@track Experience;
@track AvilabilityOfEmp;
@track cardDesig;
@track birthdayEmployee = [];
@track ThisMonthbillableHr = 0;
@track showTabTwo = false;
//Task List / Status Update Variable
@track taskListValue;
@track statusUpdatevalue;
@track BillableHourValue;
@track DateofTaskValue;

@track PreDateValue;
@track preStatusValue;
@track preTaskValue;
@track preBillablevalue;
@track preActualvalue;

@track TotalBillable = 0;
@track slogan;
@track employeeDatatableList = [];
@track ProjectWillingEmp = [];
ShowProjectWillingEmp = false;

loading = false;
showTaskDataUpdated = true;

constructor() {
    super();
    //console.log('Session Id-------->'+sessionStorage.getItem('id'));
    this.employeeId = sessionStorage.getItem('id');
    this.slogangenerator()
}



slogangenerator() {
    var cars = ["There are four ingredients in true leadership: brains, soul, heart, and good nerves.",
        "The only thing worse than starting something and failing… is not starting something.",
        "In the end, a great leader is only known by the impact he or she has on others.",
        "Teamwork divides the task and multiplies the success.",
        "Individually, we are one drop. Together, we are an ocean.",
        "Teamwork is the secret that makes common people achieve uncommon results.",
        "Individual commitment to a group effort–that is what makes a teamwork, a company work, a society work, a civilization work.",
        "It always seems impossible until it’s done.",
        "Failure is not the opposite of success; it’s part of success.",
    ];
    var numbert = Math.floor(Math.random() * 10) + 1
    cars.map((item, index) => {
        if (index + 1 == numbert) {
            this.slogan = item;
        }
    })
    console.log(this.slogan);
}
togalClass() {
    this.updateAvil == true ? this.updateAvil = false : this.updateAvil = true

}
togalClass2(){
    let searchCmp = this.template.querySelector(".InputClass");
    let searchvalue = searchCmp.value;
    // console.log('--------- '+this.AvilabilityOfEmp);
    // console.log('---------searchvalue '+searchvalue);
    if(searchvalue.length === 0){
        searchCmp = this.AvilabilityOfEmp;
        this.updateAvil == true ? this.updateAvil = false : this.updateAvil = true;
        //console.log('Length is null');
    }
    if(searchvalue === this.AvilabilityOfEmp){
        console.log('Apex Not Called n changes are caughted in Availability');
        this.updateAvil == true ? this.updateAvil = false : this.updateAvil = true;
    }else{
        if (searchvalue > 100){
            searchCmp.setCustomValidity("Value Not greater than 100");
        }else
        if(searchvalue){
            console.log('Yup Changes occur apex is called');
            searchCmp.setCustomValidity("");
            updateAvilability({ "id": sessionStorage.getItem('id'), "avil": searchvalue })
            .then(item => {
                // console.log('----'+item);
                //this.getloginUserData()
            })
            this.AvilabilityOfEmp = searchvalue ;
            this.updateAvil == true ? this.updateAvil = false : this.updateAvil = true;
        }
    }
    searchCmp.reportValidity();
}

connectedCallback() {
        try {
            //console.log('Session Id CALBACK-------->'+sessionStorage.getItem('id'));
            //console.log('Emp Id----->'+this.employeeId);
            if (this.employeeId) {
                this.employeeIddata = this.employeeId;
            } else
            if (sessionStorage.getItem('id')) {
                this.employeeIddata = sessionStorage.getItem('id');
            }
            //console.log('EmpDAta>>'+employeeIddata);
            this.getloginUserData();
            // var utc = new Date().toJSON().slice(0,10).replace(/-/g,'/');
            // console.log('Date------------->'+new Date(utc));

            //console.log('<<<<<<END>>>>>>');
        } catch (error) {
            console.log('error>>>> ' + error);
        }
    }
    //Task List And Status Update 
TaskList(event) {
    this.preTaskValue = event.target.value;
}
StatusUpdate(event) {
    this.preStatusValue = event.target.value;
}
billablehours(event) {
    this.preBillablevalue = event.target.value;
}

actualhours(event) {
    this.preActualvalue = event.target.value;
}

DateofTask(event) {
    this.PreDateValue = event.target.value;

}
getloginUserData() {
    this.loading = true;
    logindata({
            employeeId: this.employeeIddata
        })
        .then(result => {
            this.loading = false;
            //console.log('=-__==__++'+JSON.stringify(result));
            //console.log('dATE '+result.todaysdate);
            let modifiedBirthdayData = [];
            if (result.Employee_dataBirthday) {
                if (result.Employee_dataBirthday.length > 0) {
                    console.log('In If Method >>>>>>>>');
                    this.ShowBirthday = true;
                    for (let i in result.Employee_dataBirthday) {
                        modifiedBirthdayData.push({
                            Name: result.Employee_dataBirthday[i].Name + ' (' + result.Employee_dataBirthday[i].Emp_Code__c + ')',
                            description: result.Employee_dataBirthday[i].Role__c
                        })
                    }
                } else {
                    modifiedBirthdayData.push({
                        Name: 'Huh!!!     ',
                        description: 'No Birthday'
                    })
                }
                this.birthdayEmployee = modifiedBirthdayData;
            } else {
                this.ShowBirthday = false;
            }
            if(! result.Hod_RMData){
                console.log('Not found Rm data');
                if (result.EmployeeData) {
                    this.EmployeeName = result.EmployeeData.Name;
                    this.EmployeeDOJ = result.EmployeeData.Date_Of_Joining__c;
                    this.DesignationOfEmp = result.EmployeeData.Role__c;
                    this.cardDesig = result.EmployeeData.designation__c;
                    this.Experience = result.EmployeeData.Experience__c;
                    // this.EmployeeTeam = result.EmployeeData.Team__r.Name;
                    this.EmployeeCode = result.EmployeeData.Emp_Code__c;
                    this.AvilabilityOfEmp = result.EmployeeData.Availability__c;
                    this.areLoginPageVisible = false;
                }
                // console.log(result.showTaskList);
                if (result.showTaskList) {
                    console.log('Todays taskList nd Status ----> '+JSON.stringify(result.showTaskList));
                    this.PreDateValue = result.showTaskList.Date__c;
                    this.preStatusValue = result.showTaskList.Status_Update__c;
                    this.preTaskValue = result.showTaskList.Task_List__c;
                    this.preBillablevalue = result.showTaskList.Billable_Hours__c;
                    this.preActualvalue = result.showTaskList.Actual_Hours__c;
                }
                if (result.totBillableHour) {
                    // console.log('!!!!!!!!!!!' + result.totBillableHour);
                    this.TotalBillable = result.totBillableHour;
                }
                if (result.todaysdate) {
                    //console.log('!!!!!!!!!!!' + result.todaysdate);
                    this.PreDateValue = result.todaysdate;
                }
            }
            else
                if (result.Hod_RMData != null) {
                    console.log('RM and HOD Data is Catched');
                    this.showTaskTable = false;
                    // this.innnerDataofCard = false;
                    // this.innnerDataofCardBH = false;
                    //console.log('Print result>>>>>> '+JSON.stringify(result.wrapperMap));
                    this.EmployeeName = result.Hod_RMData.Name;
                    if(result.avgYesterdayAvl){
                        this.innnerDataofCard = true;
                        this.AvilabilityOfEmp = result.avgYesterdayAvl;
                    }
                    if(result.YesterdayBillableHR){
                        this.innnerDataofCardBH = true;
                        this.TotalBillable = result.YesterdayBillableHR;
                    }
                    if(result.ThisMonthBilableHr){
                        this.ThisMonthbillableHr = result.ThisMonthBilableHr;
                    }
                    if(result.wrapperMap){
                        // const newMap = new Map();
                        //console.log('Employee Dataa------->'+JSON.stringify(result.wrapperTeam));
                        for(var key in result.wrapperTeam){
                            
                            let tempObj = {
                                Obj : result.wrapperTeam[key].Name,
                                Empcode : result.wrapperTeam[key].Emp_Code__c,
                                Role : result.wrapperTeam[key].Role__c,
                                Avl : result.wrapperMap[result.wrapperTeam[key].Id]+'%'
                            };
                            this.employeeDatatableList.push(tempObj);
                            // newMap.set(result.wrapperTeam[key] , result.wrapperMap[result.wrapperTeam[key].Id] );
                        }
                        //console.log(JSON.stringify(this.employeeDatatableList));
                    }
                    if(result.ProjectWillingEmp){
                        this.ShowProjectWillingEmp = true;
                        this.ProjectWillingEmp = result.ProjectWillingEmp;
                        //console.log(JSON.stringify(result.ProjectWillingEmp));

                    }
            }
        })
        .catch(error => {
            console.log('error>>>> ' + JSON.stringify(error))
        });
}

////////////////////////////////////////////////////////////////////////////////////////
 createRow(listOfAccounts) {
        let accountObject = {};
        if(listOfAccounts.length > 0) {
            accountObject.index = listOfAccounts[listOfAccounts.length - 1].index + 1;
        } else {
            accountObject.index = 1;
        }
        accountObject.Name = null;
        accountObject.Website = null;
        accountObject.Phone = null;
        listOfAccounts.push(accountObject);
    }
    /**
     * Adds a new row
     */
    addNewRow() {
        this.createRow(this.listOfAccounts);
    }
    /**
     * Removes the selected row
     */
    removeRow(event) {
        let toBeDeletedRowIndex = event.target.name;
        let listOfAccounts = [];
        for(let i = 0; i < this.listOfAccounts.length; i++) {
            let tempRecord = Object.assign({}, this.listOfAccounts[i]); //cloning object
            if(tempRecord.index !== toBeDeletedRowIndex) {
                listOfAccounts.push(tempRecord);
            }
        }
        for(let i = 0; i < listOfAccounts.length; i++) {
            listOfAccounts[i].index = i + 1;
        }
        this.listOfAccounts = listOfAccounts;
    }
    /**
     * Removes all rows
     */
    removeAllRows() {
        let listOfAccounts = [];
        this.createRow(listOfAccounts);
        this.listOfAccounts = listOfAccounts;
    }
    handleInputChange(event) {
        let index = event.target.dataset.id;
        let fieldName = event.target.name;
        let value = event.target.value;
        for(let i = 0; i < this.listOfAccounts.length; i++) {
            if(this.listOfAccounts[i].index === parseInt(index)) {
                this.listOfAccounts[i][fieldName] = value;
            }
        }
    }


/////////////////////////////////////////////////////////////
taskListUpdate(event) {
    try{
    console.log('billableclass value>>>>>>' + this.preBillablevalue);
    console.log(' Actual Hour value>>>>>>>' + this.preActualvalue);
    console.log('list Value---->' + this.preTaskValue);
    console.log('Status Update Value---->' + this.preStatusValue);
    console.log('Employee Id ' + this.employeeIddata);
    console.log('Billable Hour' + this.preBillablevalue);
    console.log('date ' + this.PreDateValue);

    let billable = this.template.querySelector(".billClass");
    let actualhrs = this.template.querySelector(".actualbillClass");
    if(! this.preBillablevalue ){
        billable.setCustomValidity("billable hour should not be Null");
    }else
    if(this.preBillablevalue > 12){
        billable.setCustomValidity("Hours should not be greater than 12");
    }else
    if(! this.preActualvalue){
        actualhrs.setCustomValidity("billable hour should not be Null");
    }
    else 
    if( this.preActualvalue > 12){
            actualhrs.setCustomValidity("Hours should not be greater than 12");
    }
    else{
        billable.setCustomValidity(""); 
        actualhrs.setCustomValidity("");
        this.showTaskDataUpdated = false;
        TaskMethod({
            taskListValue: this.preTaskValue,
            statusUpdatevalue: this.preStatusValue,
            EmployeeID: this.employeeIddata,
            Billablehour: this.preBillablevalue,
            TodaysDate: this.PreDateValue,
            ActualHour: this.preActualvalue
        })
        .then(resultvar => {
            if (resultvar.InsertandUpdateTasks) {
                this.showTaskDataUpdated = true;
                //console.log('taskList Inserted ' + JSON.stringify(resultvar.InsertandUpdateTasks));
                this.getloginUserData();
            }
        })
    }
    billable.reportValidity();
    }catch(err){
        console.log(err);
    }
    
}

}