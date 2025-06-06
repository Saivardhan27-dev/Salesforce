import { LightningElement, track } from 'lwc';
import searchRecipients from '@salesforce/apex/EmailRecipientController.searchRecipients';

export default class EmailRecipient extends LightningElement {
    @track searchTerm = ''; // Search term input
    @track results = []; // Search results

    // Handle input change and search for matching records
    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        if (this.searchTerm.length > 2) {
            this.fetchRecipients();
        } else {
            this.results = [];
        }
    }

    // Fetch matching results from Apex
    fetchRecipients() {
        searchRecipients({ searchTerm: this.searchTerm })
            .then((data) => {
                this.results = data;
            })
            .catch((error) => {
                this.results = [];
                console.error('Error fetching recipients: ', error);
            });
    }

    // Handle recipient selection
    handleRecipientSelect(event) {
        const recipientId = event.target.dataset.id;
        const recipientName = event.target.dataset.name;
        const recipientEmail = event.target.dataset.email;

        // Output or further handling of the selected recipient
        console.log(`Recipient Selected: ${recipientName} - ${recipientEmail}`);
        
        // You can further handle the selected recipient, such as populating a field or sending the email
    }
}