import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRST_NAME_FIELD from '@salesforce/schema/contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/contact.Email';

export default class ContactCreator extends LightningElement {
    objectApiName = CONTACT_OBJECT;
    fields = [FIRST_NAME_FIELD, LAST_NAME_FIELD, EMAIL_FIELD];
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Contact Created",
            message: "Record ID: " + event.detail.id,
            variant: "sucess"
        });
        this.dispatchEvent(toastEvent);
    }
}