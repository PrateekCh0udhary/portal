import { LightningElement, api, wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from "lightning/confirm";
// import { refreshApex } from '@salesforce/apex';
//import Cloud_Image from '@salesforce/resourceUrl/CloudImage';
import getPolicyData from '@salesforce/apex/Policy.getPolicyData';
import getRMData from '@salesforce/apex/Policy.getRMData';
import createPolicy from '@salesforce/apex/Policy.createPolicy';
import deletePolicyfromApex from '@salesforce/apex/Policy.deletePolicy';

export default class PolicyTab_LWC extends LightningElement {
@track policyData =[];
@track isOpen = false;
@track isNewButton;
@track isCurrentEmployee;
@track currentEmployee;
@track showAlert = false;
@track EmployeeId; 
@track PolicyName;
@track Description;
@track deletePolicyData;
@track pickValue = [];
@track pickVal = [];
@track RMOptions = [
{label : "Self-Employee", value : sessionStorage.getItem("id")},
];

loading = false;
constructor(){
super()
this.EmployeeId = sessionStorage.getItem("id");
console.log('Policy(EmployeeId) sessionId--------->'+this.EmployeeId);
sessionStorage.getItem("PDid");
sessionStorage.setItem("PDid","PolicyDetail")
// console.log('PDid----->'+sessionStorage.getItem("PDid"));
}

async connectedCallback(){
try{
this.loading = true;
if(this.policyData){
if(sessionStorage.getItem("PDid") === "PolicyDetail"){
// console.log('abcdefghi');
}
await getPolicyData ({
empId : this.EmployeeId
})
.then(result => {
    this.loading = false;
//console.log('Apex Data ---->'+JSON.stringify(result));
this.policyData = result.PolicyData;
this.isNewButton = result.isNewButton;
this.isCurrentEmployee = result.isCurrentEmployee;
console.log("CURRENT EMPLOYEE DATA ::: \n", JSON.stringify(result.currentEmployee));
this.currentEmployee = result.currentEmployee;
//console.log("Policy Data >>>> ",JSON.stringify(this.policyData));
// if (this.policyData.Policy_Created_By__r.designation__c == "Team Lead" || this.policyData.Policy_Created_By__r.designation__c == "Employee" || this.policyData.Policy_Created_By__r.designation__c == "Trainee") {
//    this.isNewButton = false;
// }
})
.catch(error => {
console.log('error>>>> ' + JSON.stringify(error))
});
}

await getRMData()
.then(result => {
    this.loading = false;
// console.log("DATA .. >> "+ JSON.stringify(result))
let returnedValue = result;
for(var key in returnedValue){
//console.log(returnedValue[key].Name);
var RMObj = { label : returnedValue[key].Name , value : returnedValue[key].Id};
this.RMOptions.push(RMObj);
}
})
.catch(error =>{
console.log("Error  >>> "+JSON.stringify(error))
});
} catch (error) {
console.log('error>>>> ' + error)
}
}

openModal(){
console.log("OPEN MODAL CALLED>");
this.isOpen = true;
}

nameChangedHandler(event){
this.PolicyName = event.target.value;
console.log(this.PolicyName);     
}

descriptionChangeHandler(event){
this.Description = event.target.value;
console.log(this.Description);
}

get options(){
return this.RMOptions;
}
changeEmployeeValue(event){
    console.log('ttttt');
var test = event.detail.value;
this.pickVal = test;
console.log(test);
}

get selected() {
    return this.pickValue.length ? this.pickValue : 'none';
}
createPolicy(){
console.log("Create Policy Called...");
var lists = this.pickVal;
console.log('list>>>> '+JSON.stringify(lists));
var param1, param2, param3, param4;

if(this.isCurrentEmployee){
    console.log(this.PolicyName);
    console.log(this.pickValue);
    console.log(this.Description);
    param1 = this.PolicyName;
    param2 = lists;
    param3 = this.EmployeeId;
    param4 = this.Description;
}else{
    console.log(this.PolicyName);
    console.log(this.EmployeeId);
    console.log(this.Description);
    param1 = this.PolicyName;
    param2 = this.EmployeeId;
    param3 = this.EmployeeId;
    param4 = this.Description;
}

createPolicy({
name : param1,
pickValue : param2,
empId : param3,
description : param4
})
.then(result =>{
    this.loading = false;
console.log(result);
// const event = new ShowToastEvent({
//     title : "Success",
//     message: "Policy Created.. : "+result.Name,
//     variant : "Success"
// });

// this.dispatchEvent(event);
this.showAlert = true;
this.PolicyName = "";
this.Description = "";
this.customHideModalPopup();
if(result){
this.loading = true;
getPolicyData({empId : this.EmployeeId})
.then(result =>{
    this.loading = false;
    console.log("Records fetched successfully...");
    this.policyData = result.PolicyData;
    console.log('result',JSON.stringify(this.policyData));
    // return refreshApex(this.policyData);
})
.catch(error =>{
    console.log("Some Error Occured...");
    console.log(error);
});
}
})
.catch(error =>{
console.log("Policy not created...");
console.log('errormsg>>>>'+JSON.stringify(error));
})
}
customHideModalPopup(){
this.isOpen = false;
this.showAlert = false;
}

async handleConfirm(event)
{
console.log("delete Policy Data");
console.log(JSON.stringify(event.target.value));
let deletePolicyId = event.target.value;
const result = await LightningConfirm.open({
    message: "Are you sure you want to delete this Policy ?",
    theme: "inverse",
    label: "Confirmation"
});
console.log("OKKK  >> ", result);
if(result){
    this.loading = true;
    deletePolicyfromApex({
        PolicyID : deletePolicyId
    })
    .then(result =>{
        if(result){
            this.loading = false;
            console.log("delete Data>>>>" );
            getPolicyData({empId : this.EmployeeId})
        .then(result =>{
            this.loading = false;
            console.log("Records fetched successfully...");
            this.policyData = result.PolicyData;
            console.log('result',JSON.stringify(this.policyData));
            // return refreshApex(this.policyData);
        })
        .catch(error =>{
            console.log("Some Error Occured...");
            console.log(error);
        });
        }
    })
    .catch(error =>{
    console.log("Some Error Occured...");
    console.log(error);
    });
}
}
}