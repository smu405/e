new Promise(function(resolve, reject) {
	    resolve(3)
}).then(function(res) {
	    console.log("3 is expected..."+res); //3
	    return res * 10;
}).then(function(res) {
	    console.log("30 is expected..."+res); //30 as multiplied by 10 on 2 lines above
	    return res * 10;
}).then(function(res) {
	    console.log("300 is expected..."+res); //300
});
