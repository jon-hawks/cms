/*---------------------------------------------------------------------------------------------------------------------\
| Footer JavaScript                                                                                                    |
\---------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------\
| Logger Auto-scroll-to-bottom                                                 |
\-----------------------------------------------------------------------------*/
document.addEventListener("click", function(event){
    if(event.button !== 0) return;
    for(var target = event.target; target && target !== this; target = target.parentNode){
        if(typeof target.matches === "function" && target.matches("#log")){
            setTimeout(function(){
                target.scrollTop = target.scrollHeight;
            }, 1);
            return;
        }
    }
});

/*-----------------------------------------------------------------------------\
| WebSocket.                                                                   |
\-----------------------------------------------------------------------------*/
window.websocket = function(){

    /* Get relevant DOM elements. */
    websocket.labels = document.querySelectorAll("#header-websocket label, label[for=\"chat-toggle\"]");
    websocket.chat = document.getElementById("chat-messages");

    /* Keep the header and chat toggle in sync with the connection. */
    function status(color, text, title){
        websocket.labels.forEach(function(label){
            label.className   = color;
            label.textContent = text;
            label.title       = title || "";
        });
    }
    status("orange", "Connecting");

    /* Create the WebSocket object. */
    try{
        websocket.handle = new WebSocket(window.websocketAddress);
    }

    /* Feedback. */
    catch(error){
        status("red", "Offline", "Error: " + error);
        return;
    }

    /*-------------------------------------------------------------------------\
    | The connection has been established.                                     |
    \-------------------------------------------------------------------------*/
    websocket.handle.onopen = function(event){

        /* Feedback. */
        status("green", "Online");

        /* Feedback in chat. */
        var message         = document.createElement("span");
        message.class       = "system";
        message.textContent = "Connected!";
        websocket.chat.appendChild(message);
        websocket.chat.scrollTop = websocket.chat.scrollHeight;
    };

    /*-------------------------------------------------------------------------\
    | Data has been recieved.                                                  |
    \-------------------------------------------------------------------------*/
    websocket.handle.onmessage = function(event){
        var data = JSON.parse(event.data);
        switch(data.type){

            /* Chat message from user. */
            case "chat":
                // TODO: Render chat as text and validate sender identity/origin server-side.
                message = document.createElement("div");
                message.innerHTML  = "<span class=\"user-name\">"    + data.name    + "</span>: ";
                message.innerHTML += "<span class=\"user-message\">" + data.message + "</span>";
                websocket.chat.appendChild(message);
                websocket.chat.scrollTop = websocket.chat.scrollHeight;
                break;

            case "link":
                // Not yet implemented.
                break;

            case "email":
                // Not yet implemented.
                break;

            case "upload":
                // Not yet implemented.
                break;

            default:
                // Not yet implemented.
        }
    };

    /*-------------------------------------------------------------------------\
    | An error has occurred.                                                   |
    \-------------------------------------------------------------------------*/
    websocket.handle.onerror = function(event){
        console.warn(event);
    };

    /*-------------------------------------------------------------------------\
    | The connection has closed.                                               |
    \-------------------------------------------------------------------------*/
    websocket.handle.onclose = function(event){

        /* Update both connection indicators immediately. */
        status("red", "Offline");

        /* Feedback in chat. */
        message = document.createElement("div");
        message.innerHTML  = "<span class=\"user-name\">System</span>: ";
        message.innerHTML += "<span class=\"user-message\">Connection closed.</span>";
        websocket.chat.appendChild(message);
        websocket.chat.scrollTop = websocket.chat.scrollHeight;

        /* Reconnect. */
        setTimeout(websocket, 3000);
    };
}

/* Execute on page load and transition. */
window.listen("load", websocket);

/*-----------------------------------------------------------------------------\
| Send a message on the websocket.                                             |
\-----------------------------------------------------------------------------*/
var eventMousedownSendChatMessage = function(event){
    if(event.button !== 0) return;
    for(var target = event.target; target && target !== this; target = target.parentNode){
        if(typeof target.matches === "function" && target.matches("#chat input[name=\"send\"]")){
            event.preventDefault();

            /* Get message. */
            var message = document.querySelector("#chat input[name=\"message\"]");

            /* Send message. */
            window.websocket.handle.send(JSON.stringify({type: "chat", name: document.querySelector("#header-username a.ajax").innerText, message: message.value}));

            /* Clear input box. */
            message.value = "";
            return;
        }
    }
};
document.removeEventListener("mousedown", eventMousedownSendChatMessage);
document.addEventListener("mousedown", eventMousedownSendChatMessage);

/* Disable standard click; using mousedown instead. */
var eventClickSendChatMessage = function(event){
    if(event.button !== 0) return;
    for(var target = event.target; target && target !== this; target = target.parentNode){
        if(typeof target.matches === "function" && target.matches("#chat input[name=\"send\"]")){
            event.preventDefault();
            return;
        }
    }
};
document.removeEventListener("click", eventClickSendChatMessage);
document.addEventListener("click", eventClickSendChatMessage);

/* Event handler for message input on [Enter] keypress. */
var eventKeydownMessage = function(event){
    if(event.keyCode !== 13 || event.shiftKey || event.altKey || event.ctrlKey) return;
    for(var target = event.target; target && target !== this; target = target.parentNode){
        if(typeof target.matches === "function" && target.matches("#chat input[name=\"message\"]")){
            event.preventDefault();

            /* Send message. */
            window.websocket.handle.send(JSON.stringify({type: "chat", name: document.querySelector("#header-username a.ajax").innerText, message: target.value}));

            /* Clear input box. */
            target.value = "";
            return;
        }
    }
};
document.removeEventListener("keydown", eventKeydownMessage);
document.addEventListener("keydown", eventKeydownMessage);
