// retrieve query string from current url

var salescamp_store_var = window.location.search.replace("?", '');

// store cookie for 30 days
var d = new Date();
d.setTime(d.getTime() + (30*24*60*60*1000));
var expires = "expires="+ d.toUTCString();
document.cookie = salescamp_store_var + ";" + expires + ";path=/";
