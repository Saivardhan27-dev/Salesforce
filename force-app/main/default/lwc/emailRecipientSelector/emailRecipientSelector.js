import { LightningElement, track } from 'lwc';
import searchRecipients from '@salesforce/apex/EmailSuggestionController.fetchRecipients';

export default class EmailRecipientSelector extends LightningElement {
    @track suggestions = [];
    @track selectedRecipients = [];
    searchTerm = '';
    showSuggestions = false;

    // Handle search input
    handleSearch(event) {
        this.searchTerm = event.target.value.trim();

        if (this.searchTerm.length > 2) {
            searchRecipients({ searchTerm: this.searchTerm })
                .then((data) => {
                    this.suggestions = data.map((item) => ({
                        id: item.id,
                        name: item.name,
                        email: item.email,
                        type: item.type,
                    }));
                    this.showSuggestions = this.suggestions.length > 0;
                })
                .catch((error) => {
                    console.error('Error fetching recipients:', error);
                    this.suggestions = [];
                    this.showSuggestions = false;
                });
        } else {
            this.suggestions = [];
            this.showSuggestions = false;
        }
    }

    // Handle recipient selection
    selectRecipient(event) {
        const recipientId = event.currentTarget.dataset.id;
        const recipient = this.suggestions.find((item) => item.id === recipientId);

        if (recipient && !this.selectedRecipients.some((r) => r.id === recipient.id)) {
            this.selectedRecipients = [...this.selectedRecipients, recipient];
        }

        this.showSuggestions = false;
        this.suggestions = [];
    }

    // Remove recipient
    removeRecipient(event) {
        const idToRemove = event.target.dataset.id;
        this.selectedRecipients = this.selectedRecipients.filter(
            (recipient) => recipient.id !== idToRemove
        );
    }
}