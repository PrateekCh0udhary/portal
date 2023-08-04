import { api, LightningElement, track } from 'lwc';
import getProjectStatus from '@salesforce/apex/Employee_login.getProjectStatus'; 
import generateData from './generateData';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Project', fieldName: 'Name' },
    { label: 'Client Name', fieldName: 'ClientName', type: 'text', },
    { label: 'Billable Hours', fieldName: 'totalBillableHours', type: 'number' ,  cellAttributes: { alignment: 'center' } },
    { label: 'Actual Hours', fieldName: 'totalActualHours', type: 'number',  cellAttributes: { alignment: 'center' }},
];

export default class Projectstatus extends LightningElement {
    @track data = [];
    @track loading = true;
    columns = columns;
    // rowOffset = 0;

    loading = false;
    async connectedCallback(){

        console.log(JSON.stringify(sessionStorage.getItem('id')));
        this.data = generateData({ amountOfRecords: 10 });

        await getProjectStatus()
        .then(result =>{
            console.table(JSON.stringify(result));
            this.data = result;
            this.loading = false;
        })
        .catch(error =>{
            console.log(JSON.stringify(error));
            this.loading = false;
        })
    }
}