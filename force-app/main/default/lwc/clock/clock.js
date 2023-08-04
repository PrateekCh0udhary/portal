import { LightningElement } from 'lwc';

export default class Clock extends LightningElement {
    currentTime;

    connectedCallback() {
        // Update the time every second
        setInterval(() => {
            this.getCurrentTime();
        }, 1000);
    }

    getCurrentTime() {
        const date = new Date();
        const options = { hour: 'numeric', minute: 'numeric', second: 'numeric' };
        this.currentTime = date.toLocaleTimeString([], options);
    }
}