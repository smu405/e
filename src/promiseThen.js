var doPromise = new Promise(function(myResolve, myReject) {
    myResolve(123);  //when successful, returns 123
    //myReject("Rejected"); //when error
});

//
doPromise.then(function(my){
        console.log("RETURNED: "+my);
    }, function(err) {
        console.log("ERROR: "+err);
    });
