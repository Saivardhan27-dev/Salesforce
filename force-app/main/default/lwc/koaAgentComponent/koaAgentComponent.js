import { LightningElement, track } from 'lwc';
import processMessage from '@salesforce/apex/KoaAgentInvoker.processMessage';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class KoaAgentComponent extends LightningElement {
    @track message = '';
    @track responses = [];
    @track isLoading = false;
    initialMessageShown = true;
    initialMessageTime = '';
    sessionId = ''; // Property to store the session ID between calls
    
    connectedCallback() {
        this.initialMessageTime = this.getFormattedTime();
        
        // Try to load previous conversation
        const conversationLoaded = this.loadConversation();
        
        // If no previous conversation, hide the initial message if there are responses
        if (conversationLoaded && this.responses.length > 0) {
            this.initialMessageShown = false;
        }
    }
    
    // Helper method to extract clean text from various response formats
    parseAgentResponse(response) {
        if (!response) return 'No response received';
        
        try {
            // If it's already a string and not JSON, return it
            if (typeof response === 'string') {
                if (!response.startsWith('{') && !response.startsWith('[')) {
                    return response;
                }
                
                // Try to parse it as JSON
                const parsedResponse = JSON.parse(response);
                
                // Handle different response formats
                if (parsedResponse.type && parsedResponse.value) {
                    // Format: {"type":"Text","value":"Hello"}
                    return parsedResponse.value;
                } else if (Array.isArray(parsedResponse)) {
                    // Handle array format
                    let result = '';
                    parsedResponse.forEach(item => {
                        if (item.type && item.value) {
                            result += item.value + ' ';
                        }
                    });
                    return result.trim();
                } else if (typeof parsedResponse === 'object') {
                    // Try to find any text content
                    if (parsedResponse.message) return parsedResponse.message;
                    if (parsedResponse.text) return parsedResponse.text;
                    if (parsedResponse.content) return parsedResponse.content;
                    
                    // Fallback to JSON string
                    return JSON.stringify(parsedResponse);
                }
            }
            
            // Fallback to original response
            return response;
        } catch (error) {
            console.error('Error parsing agent response:', error);
            return response;
        }
    }
    
    // Check if we have any responses to show
    get hasResponses() {
        return this.responses.length > 0 || this.initialMessageShown;
    }
    
    // Check if we should show the initial message
    get hasInitialMessage() {
        return this.initialMessageShown;
    }
    
    // Format the current time for message timestamps
    getFormattedTime() {
        const now = new Date();
        let hours = now.getHours();
        const minutes = now.getMinutes().toString().padStart(2, '0');
        const ampm = hours >= 12 ? 'PM' : 'AM';
        
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        
        return `${hours}:${minutes} ${ampm}`;
    }
    
    // Handler for when the message input changes
    handleMessageChange(event) {
        this.message = event.target.value;
    }
    
    // Handler for when the send button is clicked
    handleSendMessage() {
        if (this.message && this.message.trim()) {
            const userMessage = this.message;
            const currentTime = this.getFormattedTime();
            
            // Add user message to the conversation history
            this.responses.push({
                id: Date.now().toString(),
                text: userMessage,
                sender: 'User',
                time: currentTime,
                isUser: true,
                messageClass: 'message user-message'
            });
            
            // After first user message, hide the welcome message
            if (this.initialMessageShown && this.responses.length > 0) {
                this.initialMessageShown = false;
            }
            
            // Save conversation to maintain history even if there's an error
            this.saveConversation();
            
            // Clear the input field after sending
            this.message = '';
            
            // Scroll to bottom after sending message
            this.scrollToBottom();
            
            // Show loading state
            this.isLoading = true;
            
            // Call the Apex method to process the message with the session ID
            processMessage({ userMessage: userMessage, sessionId: this.sessionId })
                .then(result => {
                    // Store the session ID for future messages
                    if (result.sessionId) {
                        this.sessionId = result.sessionId;
                        console.log('Session ID saved:', this.sessionId);
                    } else {
                        console.warn('No sessionId returned from agent - may need to start a new session');
                    }
                    
                    // Check if response indicates a session error
                    const responseStr = String(result.response || '');
                    if (responseStr.includes('session expired') || responseStr.includes('invalid session') || 
                        responseStr.includes('session not found')) {
                        // Clear session and try again with a fresh session
                        console.log('Session appears to be expired, will retry with new session');
                        this.sessionId = '';
                        localStorage.removeItem('koaAgentConversation');
                        // Try again with same message but no session ID (will create new session)
                        processMessage({ userMessage: userMessage, sessionId: '' })
                            .then(newResult => {
                                this.handleAgentResponse(newResult, currentTime);
                            })
                            .catch(error => this.handleError(error));
                        return;
                    }
                    
                    // Parse the agent response using our helper method
                    const responseText = this.parseAgentResponse(result.response);
                    const responseTime = this.getFormattedTime();
                    
                    // Handle agent response
                    this.handleAgentResponse(result, responseTime);
                })
                .catch(error => this.handleError(error))
                .finally(() => {
                    // Hide loading state
                    this.isLoading = false;
                });
        }
    }
    
    // Helper method to show toast notifications
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
    
    // Add support for Enter key to send message and set up initial UI
    renderedCallback() {
        const inputBox = this.template.querySelector('lightning-input');
        if (inputBox) {
            inputBox.addEventListener('keyup', (event) => {
                if (event.key === 'Enter') {
                    this.handleSendMessage();
                }
            });
        }
        
        // Automatically focus on the input box
        if (inputBox && !this._inputFocused) {
            inputBox.focus();
            this._inputFocused = true;
        }
        
        // Scroll to bottom when component is first rendered
        this.scrollToBottom();
    }
    
    // Helper method to scroll the chat to the bottom
    scrollToBottom() {
        try {
            const chatContainer = this.template.querySelector('.chat-messages-container');
            if (chatContainer) {
                // Use setTimeout to ensure this happens after DOM updates
                setTimeout(() => {
                    chatContainer.scrollTop = chatContainer.scrollHeight;
                }, 0);
            }
        } catch (error) {
            console.error('Error scrolling to bottom:', error);
        }
    }
    
    // Helper method to save the conversation to local storage for persistence
    saveConversation() {
        try {
            // Store the session ID and conversation history in localStorage
            const conversationData = {
                sessionId: this.sessionId,
                responses: this.responses,
                lastUpdated: new Date().toISOString()
            };
            
            // Save to localStorage using a unique key (could be customized per user)
            localStorage.setItem('koaAgentConversation', JSON.stringify(conversationData));
            console.log('Conversation saved with sessionId:', this.sessionId);
        } catch (error) {
            console.error('Error saving conversation:', error);
        }
    }
    
    // Load previous conversation if available
    loadConversation() {
        try {
            const savedConversation = localStorage.getItem('koaAgentConversation');
            if (savedConversation) {
                const conversationData = JSON.parse(savedConversation);
                
                // Check if session might be expired (older than 30 minutes)
                const lastUpdated = conversationData.lastUpdated ? new Date(conversationData.lastUpdated) : null;
                const sessionMaxAge = 30 * 60 * 1000; // 30 minutes in milliseconds
                
                if (lastUpdated && (new Date() - lastUpdated) > sessionMaxAge) {
                    console.warn('Session appears to be expired (older than 30 minutes), starting new session');
                    localStorage.removeItem('koaAgentConversation');
                    return false;
                }
                
                // Restore session ID and responses if they exist
                if (conversationData.sessionId) {
                    this.sessionId = conversationData.sessionId;
                }
                
                if (conversationData.responses && Array.isArray(conversationData.responses)) {
                    this.responses = conversationData.responses;
                }
                
                console.log('Conversation loaded with sessionId:', this.sessionId);
                return true;
            }
        } catch (error) {
            console.error('Error loading conversation:', error);
            // Clear potentially corrupted data
            localStorage.removeItem('koaAgentConversation');
        }
        return false;
    }
    
    // Helper method to handle agent response
    handleAgentResponse(result, responseTime) {
        const responseText = this.parseAgentResponse(result.response);
        
        // Add agent response to the conversation history
        this.responses.push({
            id: Date.now().toString(),
            text: responseText,
            sender: 'Agentforce',
            time: responseTime || this.getFormattedTime(),
            isUser: false,
            messageClass: 'message agent-message'
        });
        
        // Save conversation with updated responses and session ID
        this.saveConversation();
        
        // Scroll to bottom after receiving response
        setTimeout(() => this.scrollToBottom(), 100);
    }
    
    // Helper method to handle errors
    handleError(error) {
        // Show error message
        if (error.body && error.body.message) {
            this.showToast('Error', error.body.message, 'error');
        }
        console.error('Error details:', error);
        
        // Reset session ID on error to start fresh
        this.sessionId = '';
        
        const errorTime = this.getFormattedTime();
        
        // Add error message to conversation history
        this.responses.push({
            id: Date.now().toString(),
            text: 'Sorry, I encountered an error processing your request.',
            sender: 'Agentforce',
            time: errorTime,
            isUser: false,
            messageClass: 'message agent-message'
        });
        
        // Scroll to bottom after error
        setTimeout(() => this.scrollToBottom(), 100);
    }
}