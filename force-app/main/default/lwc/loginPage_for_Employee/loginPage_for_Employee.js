import { LightningElement, track, wire, api } from 'lwc';
import Cloud_Image from '@salesforce/resourceUrl/CloudImage';
import logindata from '@salesforce/apex/Employee_login.employee_IdAndPassword';
import LightningConfirm from "lightning/confirm";
export default class LoginPage_for_Employee extends LightningElement {
    CloudImg = Cloud_Image + '/logo2.png';
    cloudfulImg = Cloud_Image + '/logo.png';
    LoginImg = Cloud_Image + '/Project.jpg';
    facebook = Cloud_Image + '/facebook.jpg';
    instagram = Cloud_Image + '/instagram.jpg';
    skype = Cloud_Image + '/skype.png';
    youtube = Cloud_Image + '/youtube.png';
    twitter = Cloud_Image + '/twitter.png';
    //Login main page Visibility By this var
    areLoginPageVisible = true;
    openSettingchecker = false

    DashBoardisVisible = true;
    personaldetailisVisible = false;
    cerAndspesisVisible = false;
    teamStructureisVisible = false;
    projectStatusisVisible = false;
    GoalisVisible = false;
    policyisVisible = false;
    viewtasklistVisible = false;

    ShowBirthday = false;

    loading = false;

    @track printDate;

    @track username;
    @track password;
    @track success;
    @track employeeId
    @track error;

    @track cleartime;

    //Objects that Show data in dashboard
    @track EmployeeName;
    @track EmployeeDOJ;
    @track DesignationOfEmp;
    @track EmployeeTeam;
    @track EmployeeCode;
    @track AvilabilityOfEmp;
    @track birthdayEmployee = [];

    //Task List / Status Update Variable
    @track taskListValue;
    @track statusUpdatevalue;

    @track todayDt;

    OnclickDashBoard(event) {
        this.DashBoardisVisible = true;
        this.personaldetailisVisible = false;
        this.cerAndspesisVisible = false;
        this.teamStructureisVisible = false;
        this.projectStatusisVisible = false;
        this.GoalisVisible = false;
        this.policyisVisible = false;
        this.viewtasklistVisible = false;

    }
    OnclickpersonalDetail(event) {
        this.personaldetailisVisible = true;
        this.DashBoardisVisible = false;
        this.cerAndspesisVisible = false;
        this.teamStructureisVisible = false;
        this.projectStatusisVisible = false;
        this.GoalisVisible = false;
        this.policyisVisible = false;
        this.viewtasklistVisible = false;
    }
    OnclickcerAndspes(event) {
        this.cerAndspesisVisible = true;
        this.DashBoardisVisible = false;
        this.personaldetailisVisible = false;
        this.teamStructureisVisible = false;
        this.projectStatusisVisible = false;
        this.GoalisVisible = false;
        this.policyisVisible = false;
        this.viewtasklistVisible = false;
    }
    Onclickteamstr(event) {
        this.teamStructureisVisible = true;
        this.DashBoardisVisible = false;
        this.personaldetailisVisible = false;
        this.cerAndspesisVisible = false;
        this.projectStatusisVisible = false;
        this.GoalisVisible = false;
        this.policyisVisible = false;
        this.viewtasklistVisible = false;
    }
    Onclickprojectstatus(event) {
        console.log('project status clicked..');
        this.projectStatusisVisible = true;
        this.teamStructureisVisible = false;
        this.DashBoardisVisible = false;
        this.personaldetailisVisible = false;
        this.cerAndspesisVisible = false;
        this.GoalisVisible = false;
        this.policyisVisible = false;
        this.viewtasklistVisible = false;
    }
    Onclickgoal(event) {
        this.GoalisVisible = true;
        this.projectStatusisVisible = false;
        this.teamStructureisVisible = false;
        this.DashBoardisVisible = false;
        this.personaldetailisVisible = false;
        this.cerAndspesisVisible = false;
        this.policyisVisible = false;
        this.viewtasklistVisible = false;
    }
    Onclickpolicy(event) {
        this.policyisVisible = true;
        this.teamStructureisVisible = false;
        this.DashBoardisVisible = false;
        this.personaldetailisVisible = false;
        this.cerAndspesisVisible = false;
        this.projectStatusisVisible = false;
        this.GoalisVisible = false;
        this.viewtasklistVisible = false;
    }
    onclicktaskView(event) {
        this.viewtasklistVisible = true;
        this.policyisVisible = false;
        this.teamStructureisVisible = false;
        this.DashBoardisVisible = false;
        this.personaldetailisVisible = false;
        this.cerAndspesisVisible = false;
        this.projectStatusisVisible = false;
        this.GoalisVisible = false;
    }

    handleUserNameChange(event) {

        this.username = event.target.value;
    }

    handlePasswordChange(event) {

        this.password = event.target.value;
    }
    async LogOutButton() {
        // window.alert('Are You sure'+'\n'+'Want to Logout!!!!');
        const result = await LightningConfirm.open({
            message: "Are you sure you want to Logout?",
            theme: "inverse",
            label: "Confirmation"
        });
        console.log("OKKK  >> ", JSON.stringify(result));
        if (result) {
            sessionStorage.clear();
            console.log('Clear session------>' + sessionStorage.getItem('id'));
            window.location.reload();
        }
    }



    handleLogin(event) {
        try {
            console.log('UserName is----> ' + this.username);
            console.log('Parsword is----> ' + this.password);
            sessionStorage.getItem('id')
            if (this.username && this.password) {
                this.loading = true;
                event.preventDefault();

                logindata({
                        username: this.username,
                        password: this.password
                    })
                    .then(result => {
                        this.loading = false;
                        //console.log('result>>> '+JSON.stringify(result))
                        var recorddata = result.EmployeeData.Id;
                        this.employeeId = result.EmployeeData.Id;
                        //console.log(result);
                        //this.EmployeeID = recorddata;
                        if (!result.EmployeeData.Id) {
                            sessionStorage.clear();
                            console.log(JSON.stringify(sessionStorage.getItem('id')));
                            window.alert('Check Your Username and Parsword...!!!');
                        } else {
                            sessionStorage.setItem('id', result.EmployeeData.Id);
                            console.log('success-------> ' + JSON.stringify(result.EmployeeData.Id));
                            if (recorddata === sessionStorage.getItem('id')) {
                                this.areLoginPageVisible = false;
                            }
                        }
                    })
                    .catch(error => {
                        console.log('error>>>> 179 ' + JSON.stringify(error))
                        this.loading = true;
                    });
                console.log('<<<<<<END>>>>>>');
            }
        } catch (error) {
            console.log('error>>>> 185' + JSON.stringify(error));
        }
    }
    constructor() {

        super()
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = '  ' + dd + '/' + mm + '/' + yyyy;
        this.printDate = today;

        console.log('success sesion constructor-------> ' + sessionStorage.getItem('id'));
        if (sessionStorage.getItem('id') === null) {
            console.log('Item is Null');
            this.areLoginPageVisible = true;
        } else {
            this.loading = true;
            this.areLoginPageVisible = false;
        }
    }
    openSetting() {
        this.openSettingchecker = true
    }
    closeSetting() {
        this.openSettingchecker = false
    }
    Logout() {
        sessionStorage.clear();
        console.log('Clear By TimeOut session------>' + sessionStorage.getItem('id'));
        window.location.reload();
    }
    MouseLeave(event) {
        // console.log('Mouse Leave is Working');
        // console.log('------->' + event.keyCode);
        // this.timeout = this.timeout+40;
        // setTimeout(() =>{
        //     sessionStorage.clear();
        //     console.log('Clear By TimeOut session------>' + sessionStorage.getItem('id'));
        //     window.location.reload();
        // }, this.timeout*100);
        // this.timeout = 0;
        this.cleartime = setTimeout( this.Logout, 120000);
    }
    onmouseoverfunction(event){
        // console.log('Mouse is on component');
        clearTimeout(this.cleartime);
    }
    Onclickscreen(event) {
    }
}