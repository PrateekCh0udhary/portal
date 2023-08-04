import { LightningElement, track, api, wire } from 'lwc';
import LightningConfirm from "lightning/confirm";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createCertification from '@salesforce/apex/Employee_login.createCertificationRecord';
import GetAllDataforCertificationComponent from '@salesforce/apex/Employee_login.GetAllDataforCertificationComponent';
import deleteCertification from '@salesforce/apex/Employee_login.deleteCertification';
import updateMethod from '@salesforce/apex/Employee_login.updateCertification';

const columns = [
    {label : 'Certification', fieldName : 'Name', type : 'text', editable: true},
    {label : 'Certification Link', fieldName : 'Certification_Link__c', type : 'url', typeAttributes: {target: '_blank'}, editable: true },
    {label : 'Date Of Completion', fieldName : 'CompletionDate__c', editable: true},
    {type: "button", typeAttributes: {
        iconName : "utility:delete",  
        label: "Delete",
        name: "Delete",  
        title: "Delete",  
        disabled: false,  
        value: "delete",
        iconPosition: "center"
    }}
];

const columns2 = [
    {label : 'Certification', fieldName : 'Name', type : 'text'},
    {label : 'Certification Link', fieldName : 'CertificationLink', type : 'url', typeAttributes: {target: '_blank'} },
    {label : 'Date Of Completion', fieldName : 'CompletionDate'},
    {label : 'Employee', fieldName : 'EmployeeName', type : 'text'},
    {label : 'Team', fieldName : 'ReportingManager', type : 'text'}
];

export default class CertificationOfEmployee extends LightningElement {

    @track draftvalue;
    loading = false;
    columns = columns;
    columns2 = columns2;
    rowOffset = 0;
    @track isOpen = false;
    @track showTeamCertifications = false;
    @track certificationList
    @track uniqueCertificationList = [
        {label : "--All--", value : "--All--"}
    ];
    @track teamCertificationList;
    @track tempListOfCertifications;
    @track selectedCertification; 
    @track certificationName;
    @track completionDate;
    @track showDropDown = false;
    @track certificationLink;
    @track currentEmployeeName;
    @track IdofEmp = sessionStorage.getItem('id');
    @track DobofEmp;
    @track updatedListOfCertification = [];

    async connectedCallback(){
        this.loading = true;
        console.log(sessionStorage.getItem('id'));

            console.log("Connected Call Back Called.. On Page Load");
            GetAllDataforCertificationComponent({
                empId : this.IdofEmp
            })
            .then(result =>{
                this.loading = false;
                // console.log("Data is Fetched... !!! ");
                // console.log("CERTIFICATION LIST ::: \n", JSON.stringify(result.certificationList));
                this.certificationList = result.certificationList;
                // console.log("CURRENT EMPLOYEE DATA ::: \n", JSON.stringify(result.currentEmployee));
                this.DobofEmp = result.currentEmployee.DOB__c;
                // console.log("CURRENT EMPLOYEE DateOFBirth ::: \n", this.DobofEmp);
                this.currentEmployeeName = result.currentEmployee;
                if(this.currentEmployeeName.designation__c === "HOD" || this.currentEmployeeName.designation__c === "Reporting Manager"){
                    this.showTeamCertifications = true;
                    // console.log("TEAM CERTIFICATION LIST ::: \n", JSON.stringify(result.teamCertificationList));
                    this.teamCertificationList = result.teamCertificationList;
                    this.tempListOfCertifications = result.teamCertificationList;

                    for(var index in result.certificationNames){
                        // console.log(result[index]);
                        this.uniqueCertificationList.push({label : result.certificationNames[index], value : result.certificationNames[index]});
                    }
                    // console.log("UNIQUE CERTIFICATION NAMES ::: \n", JSON.stringify(result.certificationNames));
                }
            })
            .catch(error =>{
                this.loading = false;
                console.log("Some Error Occured in Connected Call Back..  : ",error);
            });         
    }


    CertificationOnchangeHandler(event) {
        this.selectedCertification = event.detail.value;
        // console.log(this.selectedCertification);
        if(this.selectedCertification === "--All--"){
            this.tempListOfCertifications = this.teamCertificationList;
        }else{
            let tempList = [];
            for(var index in this.teamCertificationList){
                 if(this.selectedCertification === this.teamCertificationList[index].Name){
                     tempList.push(this.teamCertificationList[index]);
                     console.log("Pushed Item  :: ",this.teamCertificationList[index].Name);
                 }
            }
            // console.log("FINAL LIST ::: ",tempList);
            this.tempListOfCertifications = tempList;
        }

    }

    openModal(){
        console.log("OPEN MODAL CALLED>");
        this.certificationName = '';
        this.completionDate = '';
        this.isOpen = true;
   
    }
    customHideModalPopup(){
        this.isOpen = false;
    }
    nameChangedHandler(event){
        this.certificationName = event.target.value;
        console.log(this.certificationName);     
    }

    urlChangedHandler(event){
        this.certificationLink = event.target.value;
        console.log(this.certificationLink);
    }

    dateChangeHandler(event){
        this.completionDate = event.target.value;
        console.log(this.completionDate)
    }

    async OnRowActionHandler(event){
        //console.log("ON Row Action Called....");
        var certificationId = event.detail.row.Id;
        console.log(certificationId);
        //console.log(event.detail.action.name)

        
        const confirmed = await LightningConfirm.open({
            message: "Do you wish to Delete this Certification ?",
            theme: "inverse",
            label: "Confirmation"
        });
        console.log(confirmed);
        if(confirmed){
                console.log("Deleting Certification ::: ", certificationId);
                this.loading = true;
                await deleteCertification({
                            "cerId" : certificationId
                        })
                        .then(result=>{
                            console.log(JSON.stringify(result))
                            // console.log("Certification Deleted")
                            
                            this.loading = false;
                            console.log(result);
                            if(result){
                                const event = new ShowToastEvent({
                                    title : "Success",
                                    message: "Certification Deleted",
                                    variant : "Success"
                                });
                                this.dispatchEvent(event);
                                GetAllDataforCertificationComponent({
                                    empId : this.IdofEmp
                                })
                                .then(result =>{
                                    // console.log("Data is Fetched... !!! ");
                                    // console.log("CERTIFICATION LIST ::: \n", JSON.stringify(result.certificationList));
                                    this.certificationList = result.certificationList;
                                        // console.log("TEAM CERTIFICATION LIST ::: \n", JSON.stringify(result.teamCertificationList));
                                        this.teamCertificationList = result.teamCertificationList;
                                        this.tempListOfCertifications = result.teamCertificationList;
                                        let tempList =[
                                            {label : "--All--", value : "--All--"}
                                        ];
                                        for(var index in result.certificationNames){
                                            // console.log(result[index]);
                                            tempList.push({label : result.certificationNames[index], value : result.certificationNames[index]});
                                        }
                                        this.uniqueCertificationList = tempList;
                                        // console.log("UNIQUE CERTIFICATION NAMES ::: \n", JSON.stringify(this.uniqueCertificationList));
                                        this.completionDate = '';
                                })
                                .catch(error =>{
                                    console.log("Some Error Occured in Connected Call Back..  : ",error);
                                });
                            
                        }
                            
                        })
                        .catch(error =>{
                            console.log("Some Error Occured in Delete Certification ..  : ",JSON.stringify(error));
                        });  
        }   
    }
    

    async OnSaveHandler(event){
        
        console.log("ONSaveHandler CALLED..")
        var draftValues = event.detail.draftValues;
        console.log(JSON.stringify(draftValues));
        for(var index in draftValues){
            console.log(draftValues[index])
        }
        this.updatedListOfCertification = draftValues;
        this.loading = true;
        await updateMethod({
            parameterString : JSON.stringify(this.updatedListOfCertification)
        })
        .then(result =>{
            this.draftvalue=null;
            this.loading = false;
            console.log(result);
            if(result){
                const event = new ShowToastEvent({
                    title : "Success",
                    message: "Certification Created.. : "+result,
                    variant : "Success"
                });
                this.dispatchEvent(event);
                GetAllDataforCertificationComponent({
                    empId : this.IdofEmp
                })
                .then(result =>{
                    // console.log("Data is Fetched... !!! ");
                    // console.log("CERTIFICATION LIST ::: \n", JSON.stringify(result.certificationList));
                    this.certificationList = result.certificationList;
                        // console.log("TEAM CERTIFICATION LIST ::: \n", JSON.stringify(result.teamCertificationList));
                        this.teamCertificationList = result.teamCertificationList;
                        this.tempListOfCertifications = result.teamCertificationList;
                        let tempList =[
                            {label : "--All--", value : "--All--"}
                        ];
                        for(var index in result.certificationNames){
                            // console.log(result[index]);
                            tempList.push({label : result.certificationNames[index], value : result.certificationNames[index]});
                        }
                        this.uniqueCertificationList = tempList;
                        // console.log("UNIQUE CERTIFICATION NAMES ::: \n", JSON.stringify(this.uniqueCertificationList));
                        this.completionDate = '';
                })
                .catch(error =>{
                    console.log("Some Error Occured in Connected Call Back..  : ",error);
                });
                
            }
        })
        .catch(error =>{
            console.log("Some Error Occured in Update Certification ..  : ",JSON.stringify(error));
        });
}

    createCertification(){
        console.log("Create Certification Called...");
        console.log(this.certificationName);
        console.log(this.certificationLink);
        console.log(this.completionDate);
        console.log(this.IdofEmp);

        var todayDate = new Date().toJSON().slice(0,10).replace(/-/g,'/');
        let DateValidation = this.template.querySelector(".comp_date");
        let NameValidation = this.template.querySelector(".comp_name");
        var Dob ;
        var dateofComp ;
        if(this.DobofEmp){
            Dob = new Date(this.DobofEmp).toJSON().slice(0,10).replace(/-/g,'/');
        }
        if(this.completionDate && this.certificationName){
            NameValidation.setCustomValidity("");
            dateofComp = new Date(this.completionDate).toJSON().slice(0,10).replace(/-/g,'/');
            if(dateofComp > Dob){
                if(dateofComp < todayDate || dateofComp === todayDate){
                    DateValidation.setCustomValidity("");
                    this.loading = true;
                    createCertification({
                        name : this.certificationName,
                        link : this.certificationLink,
                        empId : this.IdofEmp,
                        dateOfCompletion : this.completionDate
                    })
                    .then(result =>{
                        this.loading = false;
                        console.log(result);
                        if(result){
                            const event = new ShowToastEvent({
                                title : "Success",
                                message: "Certification Created.. : "+result,
                                variant : "Success"
                            });
                            this.dispatchEvent(event);
                            this.certificationLink = "";
                            this.certificationName = "";
                            this.customHideModalPopup();
                            GetAllDataforCertificationComponent({
                                empId : this.IdofEmp
                            })
                            .then(result =>{
                                // console.log("Data is Fetched... !!! ");
                                // console.log("CERTIFICATION LIST ::: \n", JSON.stringify(result.certificationList));
                                this.certificationList = result.certificationList;
                                    // console.log("TEAM CERTIFICATION LIST ::: \n", JSON.stringify(result.teamCertificationList));
                                    this.teamCertificationList = result.teamCertificationList;
                                    this.tempListOfCertifications = result.teamCertificationList;
                                    let tempList =[
                                        {label : "--All--", value : "--All--"}
                                    ];
                                    for(var index in result.certificationNames){
                                        // console.log(result[index]);
                                        tempList.push({label : result.certificationNames[index], value : result.certificationNames[index]});
                                    }
                                    this.uniqueCertificationList = tempList;
                                    // console.log("UNIQUE CERTIFICATION NAMES ::: \n", JSON.stringify(this.uniqueCertificationList));
                                    this.completionDate = '';
                            })
                            .catch(error =>{
                                console.log("Some Error Occured in Connected Call Back..  : ",error);
                            });
                            
                        }
                    })
                    .catch(error =>{
                        console.log("SOme Error Happenddd...");
                        console.log(error);
                    })
                }else{
                    DateValidation.setCustomValidity("Date should not be greater then today's date");
                    this.completionDate = '';
                }
            }else{
                DateValidation.setCustomValidity("Please enter a valid date");
                this.completionDate = '';
            }
        }else{
            if( ! this.completionDate){
                DateValidation.setCustomValidity("Please fill this field");
            }
            if( ! this.certificationName){
                NameValidation.setCustomValidity("Please fill this field");
            }
        }

        DateValidation.reportValidity();
        NameValidation.reportValidity();
    }
}