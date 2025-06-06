//step 1: create a store

const store={}

//step 2: create subscribe method

const subscribe = (eventName,callback)=>{
    if(!store[eventName]){
        store[eventName] = new Set();
    }
    store[eventName].add(callback)
}

//step 3: create publish method
const publish = (eventName,payload)=>{
    if(store[eventName]){
        store[eventName].forEach(callback=>{
            try{
                callback(payload)
            }catch(error){
                console.error(error)
            }
        })
    }
}

//step 4: create unsubscribe method
const unsubscribe = (eventName,callback)=>{
    if(store[eventName]){
        store[eventName].delete(callback)
    }
}

export default{
    subscribe,
    unsubscribe,
    publish
}