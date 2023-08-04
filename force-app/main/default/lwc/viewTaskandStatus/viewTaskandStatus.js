import { api, LightningElement, track } from 'lwc';
import taskData from '@salesforce/apex/Employee_login.ViewTasksOfEmployee';
import datevalue from '@salesforce/apex/Employee_login.Dateclass';
import Rm_HoD_Data from '@salesforce/apex/Employee_login.ViewTasksOfEmployee';
export default class ViewTaskandStatus extends LightningElement {
    @track EmployeeId;
    @track data = [];
    @track Enddt;
    @track startdt;

    @track findEmpReladedRm = [];

    @track Rm_HOd_Login = [];
    @track TempdataOfRMLogin = [];
    showTaskListofEmp = true;

    showRmdataforHod = false;
    //Rm DropDown
    @track showRMonlyforHOD = [];
    @track TempshowRMonlyforHOD = [];
    @track selectedRmvalue;
    @track RmIDviaHod = '';
    @track ListofRMteam = [];
    @track TempListofRMteam = [];
    @track SelectTeamMemberunderRm = '';
    //@track storeIdofRM;
    ShowRmDropdown = false;
    TeamMemberDropDown = false;
    ShowTaskListHeader = true;
    showTaskHistoryTeam = false;
    showCard = false;
    RmdataTruebyHOD = false;


    //Emp dropdown for Rm
    @track SelectValueForRm = '';
    @track selectedEmpvalue = '';
    @track EmpIdviaRm;

    loading = false;
    loadingcard = false;

    TaskofEmployee = true;
    loadingcardforEmp = false;

    StartdateTask(event){
        this.startdt = event.target.value;
        console.log(this.startdt);
    }
    EndDateofTask(event){
        this.Enddt = event.target.value;
        console.log(this.Enddt);
    }

    RmOnClick(event){
        console.log("Rm for HOD ON CLick Handler..");
        this.ShowRmDropdown = true;
        this.SelectTeamMemberunderRm = '';
        this.showTaskHistoryTeam = false;
        this.TeamMemberDropDown = false;
    }
    RmOnchangeListHandler(event){
        var input = event.target.value;
        var searchStr = input.toLowerCase();
        // console.log('   '+searchStr);
        var iteratable = [];
        for(var i in this.TempshowRMonlyforHOD){
            if(this.TempshowRMonlyforHOD[i].Name.toLowerCase().startsWith(searchStr)){
                iteratable.push(this.TempshowRMonlyforHOD[i]);
            }
        }
        this.showRMonlyforHOD = iteratable;
    }
    handleSelectRecord(event){
       // console.log('Rm selected By HOD----'+ event.currentTarget.dataset.id);
        this.RmIDviaHod = event.currentTarget.dataset.id;
       // console.log('3545275472____________---?> '+event.currentTarget.dataset.name);
        this.SelectValueForRm = event.currentTarget.dataset.name; 
        this.ShowRmDropdown = false;
        this.ListofRMteam = [];
        if(this.RmIDviaHod){
            for(var i in this.findEmpReladedRm){
                //console.log('Employee Name Are' + this.findEmpReladedRm[i].Reporting_Manager__c);
                if(this.findEmpReladedRm[i].Reporting_Manager__c === this.RmIDviaHod){
                    //console.log('Rm is ----> '+this.findEmpReladedRm[i].Reporting_Manager__c +'Employeee under Rm---'+this.findEmpReladedRm[i].Name);
                    let tempObj = {
                        Name : this.findEmpReladedRm[i].Name,
                        Id : this.findEmpReladedRm[i].Id
                    };
                    this.ListofRMteam.push(tempObj);
                    this.TempListofRMteam.push(tempObj);
                }
            }
            //this.callApexforEmployeeofRm();
        }
        this.RmdataTruebyHOD = true;
    }
    ClickedOnTemserch(event){
        console.log(' log ------ '+this.RmIDviaHod);
        this.TeamMemberDropDown = true;
        this.ShowRmDropdown = false;
    }
    EmpOfRmOnchange(event){
        //console.log(event.target.value);
        var input = event.target.value;
        var searchStr = input.toLowerCase();
        // console.log('   '+searchStr);
        var iteratable = [];
        for(var i in this.TempListofRMteam){
            if(this.TempListofRMteam[i].Name.toLowerCase().startsWith(searchStr)){
                iteratable.push(this.TempListofRMteam[i]);
            }
        }
        this.ListofRMteam = iteratable;

    }
    handleSelectRecordForRMEmp(event){
        //console.log('Emp selected By RM----'+ event.currentTarget.dataset.id);
        this.EmpIdviaRm = event.currentTarget.dataset.id;
        this.SelectTeamMemberunderRm = event.currentTarget.dataset.name;
        this.TeamMemberDropDown = false;
        this.Filtertask();
    }

    ClearRmData(event){
        this.SelectValueForRm = '';
        this.RmIDviaHod = '';
        this.ShowRmDropdown = false;
        this.SelectTeamMemberunderRm = '';
        this.showTaskHistoryTeam = false;
        this.TeamMemberDropDown = false;
        this.RmdataTruebyHOD = false;
    }

    ClearEmpByRMData(event){
        this.EmpIdviaRm = '';
        this.SelectTeamMemberunderRm = '';
        this.TeamMemberDropDown = false;
        this.showTaskHistoryTeam = false;
        this.showCard = false;
    }
    //--------------------------------------------------
    //RM Login
    EmployeeofRmOnchangeListHandler(event){
        var input = event.target.value;
        var searchStr = input.toLowerCase();
        console.log('   '+searchStr);
        var iteratable = [];
        for(var i in this.TempdataOfRMLogin){
            if(this.TempdataOfRMLogin[i].Name.toLowerCase().startsWith(searchStr)){
                iteratable.push(this.TempdataOfRMLogin[i]);
            }
        }
        this.Rm_HOd_Login = iteratable;
    }
    RmOnforEmployeeClick(event){
        this.ShowRmDropdown = true;
        this.EmpIdviaRm = ''
    }
    handleSelectRecordofEmp(event){
        console.log('Emp selected By RM----'+ event.currentTarget.dataset.id);
        this.EmpIdviaRm = event.currentTarget.dataset.id;
        this.selectedEmpvalue = event.currentTarget.dataset.name;
        this.ShowRmDropdown = false;
        this.Filtertask();
    }

    ClearEmpOFRM(event){
        this.EmpIdviaRm = '';
        this.selectedEmpvalue = '';
        this.ShowRmDropdown = false;
        this.showTaskHistoryTeam = false;
        this.showCard = false;
        this.tempArray = '';
    }
   async connectedCallback(){
    this.loading = true;
        this.EmployeeId = sessionStorage.getItem("id");
        console.log('Policy(EmployeeId) sessionId--------->'+this.EmployeeId);

        await datevalue({})
        .then(result =>{
            this.loading = false;
            if(result.todaysdate)
            {
                this.Enddt = result.todaysdate;
                console.log('Ed---'+this.Enddt);
            }
            if(result.FirstDate){
                this.startdt = result.FirstDate;
                console.log('St--'+this.startdt);
            }
        })

        await Rm_HoD_Data({
            EmpId : this.EmployeeId
        })
        .then(resp => {
            if(resp.EmpUnderRm){
                this.loading = false;
                this.showTaskListofEmp = false;
                this.findEmpReladedRm = resp.EmpUnderRm;
                //console.log('Here is the List of all Employee Under Rm------>'+JSON.stringify(this.findEmpReladedRm))
                if(resp.RmUnderHOd.length > 0){
                    this.showRmdataforHod = true;
                    console.log('Rm Under Hod Is >>>>'+resp.RmUnderHOd+'  Length '+resp.RmUnderHOd.length);
                    if(resp.RmUnderHOd){
                        this.selectedEmpvalue = 'HOD';
                    }
                    for(var key in resp.RmUnderHOd){
                                
                        let tempObj = {
                            Name : resp.RmUnderHOd[key].Name,
                            Id : resp.RmUnderHOd[key].Id
                        };
                        this.showRMonlyforHOD.push(tempObj);
                        this.TempshowRMonlyforHOD.push(tempObj);
                    }
                    //console.log('Rm Under Hod-data _______ >'+JSON.stringify(resp.RmUnderHOd));
                    //console.log('Rm Under Hod-data _______ >'+JSON.stringify(this.showRMonlyforHOD));
                }
                for(var key in resp.EmpUnderRm){
                                
                    let tempObj2 = {
                        Name : resp.EmpUnderRm[key].Name,
                        Id : resp.EmpUnderRm[key].Id
                    };
                    this.Rm_HOd_Login.push(tempObj2);
                    this.TempdataOfRMLogin.push(tempObj2);
                }
                //this.Rm_HOd_Login = resp.EmpUnderRm;
                //console.log('Employee Under RM if it login with Rm-data _______ >'+JSON.stringify(resp.EmpUnderRm));
            } 
        })
        .catch(error => {
            console.log('error in Rm Or Hod data>>>> ' + JSON.stringify(error))
        });
        
    if(this.Rm_HOd_Login.length == 0){
        this.loadingcardforEmp = true;
        await taskData({EmpId : this.EmployeeId,
            StartDate : this.startdt,
            Enddate : this.Enddt
        })
        .then(result =>{
            this.loadingcardforEmp = false;
            if(result.AvailDataListForEmp){
                console.log('Data Exist When Employee Login');
                this.TaskofEmployee = true;
                this.data = result.AvailDataListForEmp;
            }else{
                console.log('Data Exist When Employee Login');
                this.TaskofEmployee = false;
            }
            //console.log('taskList-------->'+JSON.stringify(result));
        })
        .catch(error => {
            console.log('error>>>> ' + JSON.stringify(error))
        });
      }
    }

    callapexdata(){
        
        var utc = new Date().toJSON().slice(0,10).replace(/-/g,'/');
        var EndDat = new Date(this.Enddt).toJSON().slice(0,10).replace(/-/g,'/');
        var stDate = new Date(this.startdt).toJSON().slice(0,10).replace(/-/g,'/');
        // console.log('Date------------->'+EndDat);
        // console.log('Date------------->'+utc);
        let EmployeeClass = this.template.querySelector(".EmployeeListClass");
        let billable = this.template.querySelector(".validateEnddate");
        let billable2 = this.template.querySelector(".validateStartDate");
        let RmClass = this.template.querySelector(".RmClass");
        let RmEmpClass = this.template.querySelector(".RmEmpClass");

        if(stDate > utc){
            billable2.setCustomValidity("Date should not be greater then today's date");
        }else{
            billable2.setCustomValidity("");
        }
        if(EndDat > utc){
            billable.setCustomValidity("Date should not be greater then today's date");
        }else{
            billable.setCustomValidity("");
        }
        if(EndDat < stDate){
            billable.setCustomValidity("End date should be greater than start date");
        }else
        if(EndDat > stDate){
            if((EndDat === utc ||  EndDat < utc) && (stDate === utc || stDate < utc) ){
               
                if(this.Rm_HOd_Login.length > 0){
                    if(this.EmpIdviaRm){
                        if(!(this.selectedEmpvalue === 'HOD')){
                            if(this.selectedEmpvalue){
                                console.log('Done');
                                EmployeeClass.setCustomValidity("");
                                billable.setCustomValidity("");
                                billable2.setCustomValidity("");
                            }
                        }else{
                            billable.setCustomValidity("");
                            billable2.setCustomValidity("");
                            RmClass.setCustomValidity("");
                            if(this.SelectValueForRm){
                                RmEmpClass.setCustomValidity("");
                            }
                        }
                        this.loadingcard = true;
                        this.EmployeeId = this.EmpIdviaRm;
                        // this.showTaskHistoryTeam = true;
                        console.log('///////'+this.EmployeeId);
                        taskData({EmpId : this.EmployeeId,
                            StartDate : this.startdt,
                            Enddate : this.Enddt
                        })
                        .then(result =>{
                            this.loadingcard = false;
                            this.data = result.AvailDataListForEmp;
                            if(! this.data){
                                this.showCard = true;
                                this.showTaskHistoryTeam = false;
                                console.log('There is No list of Employee');
                            }else{
                                this.showTaskHistoryTeam = true;
                                this.showCard = false;
                                console.log('Yes Task List is Exist');
                            }
                            //console.log('taskList-------->'+JSON.stringify(result));
                        })
                        .catch(error => {
                            console.log('error>>>> ' + JSON.stringify(error))
                        });
                        // console.log('success Rm Employee Id');
                        // console.log('EmpIdviaRm ------- > '+this.EmpIdviaRm);

                    }else{
                        if(! this.selectedEmpvalue){
                            EmployeeClass.setCustomValidity(" ");
                        }
                        if(this.selectedEmpvalue === 'HOD'){
                            console.log('Value error');
                            if(! RmClass.value){
                                RmClass.setCustomValidity(" ");
                            }else{
                                RmClass.setCustomValidity("");
                                RmEmpClass.setCustomValidity(" ");
                            }
                        }
                    }
                }else 
                if(this.EmployeeId && this.Rm_HOd_Login.length === 0){
                    this.EmployeeId = sessionStorage.getItem("id");
                    console.log('success Called Apex By EmID');
                    billable.setCustomValidity("");
                    billable2.setCustomValidity("");
                    this.loadingcardforEmp = true;
                    taskData({EmpId : this.EmployeeId,
                        StartDate : this.startdt,
                        Enddate : this.Enddt
                    })
                    .then(result =>{
                        this.loadingcardforEmp = false;
                        if(result.AvailDataListForEmp){
                            this.data = result.AvailDataListForEmp;
                            this.TaskofEmployee = true;
                        }else{
                            this.TaskofEmployee = false;
                        }
                        //console.log('taskList-------->'+JSON.stringify(result));
                    })
                    .catch(error => {
                        console.log('error>>>> ' + JSON.stringify(error))
                    });
                }
            }

        }
        if(this.Rm_HOd_Login.length > 0){
            if(!(this.selectedEmpvalue === 'HOD')){
                console.log('Roadways');
                if(! this.selectedEmpvalue || this.selectedEmpvalue){
                    billable.reportValidity();
                    billable2.reportValidity();
                    EmployeeClass.reportValidity();
                }
            }else 
            if(! this.SelectValueForRm || this.SelectValueForRm){
                console.log('Highways');
                billable.reportValidity();
                billable2.reportValidity();
                RmClass.reportValidity();
                if(RmClass.value){
                    RmEmpClass.reportValidity();
                }
            }
        }else
        if(this.Rm_HOd_Login.length === 0){
            billable.reportValidity();
            billable2.reportValidity();
        }

        // this.loadingcard = true;
        // console.log('Callleddddddddd');
        // if(this.EmpIdviaRm){
        //     this.EmployeeId = this.EmpIdviaRm;
        //     // this.showTaskHistoryTeam = true;
        //     console.log('///////'+this.EmployeeId);
        // }else{
        //     this.EmployeeId = sessionStorage.getItem("id"); 
        //     console.log('session EmpId-----'+this.EmployeeId);
        // }
    }
    Filtertask(event){
        console.log('button Click');
        console.log('StartDate '+this.startdt);
        console.log('End Date '+this.Enddt);

        let startofDate = this.template.querySelector(".validateStartDate");
        let EndofDate = this.template.querySelector(".validateEnddate");

        if(! this.startdt){
            console.log('yessssssss'+this.startdt);
            startofDate.setCustomValidity("Start date not be Null");
        }
        if(! this.Enddt){       
            EndofDate.setCustomValidity("End date not be Null");
        }
        if(this.startdt && this.Enddt){
            startofDate.setCustomValidity("");
            EndofDate.setCustomValidity("");
            this.callapexdata();
        }
        EndofDate.reportValidity();
        startofDate.reportValidity();
    }

}