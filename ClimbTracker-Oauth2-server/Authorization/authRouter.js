module.exports = (router, app, routerFunctions) => {

    // route for registering new users
    router.post('/registerUser', routerFunctions.registerUser); 

    // route for allowing existing users to login with a username and password
    router.post('/login', app.oauth.grant()); 

    return router; 
}