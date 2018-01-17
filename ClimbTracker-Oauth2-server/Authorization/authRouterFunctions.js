var mongoose = require('mongoose'); 

// registers the user
function registerUser(req, res){

    //get the username and password:
    const username = req.body.username
    const password = req.body.password

    //validate the request
    if (!isString(username) || !isString(password)){

        return sendResponse(res, "Invalid Credentials", true)
    }

    // query db to see if the user exists already
    




    //query db to see if the user exists already
    userDBHelper.doesUserExist(username)
        .then(doesUserExist => {

            //check if the user doesn't exist
            if (doesUserExist === false) {

                /* now we know that the user doesn't exist we attempt to store them in
                the database. The userDBHelper.registerUserInDB() method returns a
                promise which will only resolve if we  have successfully stored the user */
                return userDBHelper.registerUserInDB(username, password)
            }

            //here the user already exists
            else {

                //throw an error to break out of the promise chain
                throw new Error('User already exists')
            }})
        .then(

            /* This stage of the promise chain is reached if we successfully
            stored the user. Therefore, we know that we  we did successfully 
            store the user we send the response to the client notifying them
            of this. */
            sendResponse(res, "Registration was successful", null))

        .catch(error => {

            /* If this part of the code gets called then we failed to register
            the user either because they  already exist, or because we failed to save
            them in  the db. So we notify the cline that we failed to register the user. */
            sendResponse(res, "Failed to register user" , error)
        })
}

/**
 *
 * sends a response created out of the specified parameters to the client.
 *
 * @param res - response to respond to client
 * @param message - message to send to the client
 * @param error - error to send to the client
 */
function sendResponse(res, message, error) {

    /* Here e create the status code to send to the client depending on whether
    or not the error being passed in is nukk. Then, we create and send
    the json object response to the client */
    res
        .status(error != null ? error != null ? 400 : 200 : 400)
        .json({
            'message': message,
            'error': error,
        })
}


/**
 *
 * Returns true the specified parameters is a string else it returns false
 *
 * @param parameter - the variable we're checking is a String
 * @return {boolean}
 */
function isString(parameter) {

    return parameter != null && (typeof parameter === "string"
                                        || parameter instanceof String) ? true : false
}

module.exports.registerUser = registerUser; 