window.addEventListener('DOMContentLoaded', (event)=> {
    getVisitCount();
})

// dont have the url to the api right now

const prodFunctonUrl = 'https://funcrctopcug.azurewebsites.net/api/id/?code=<key>'
const devfunctionApi = 'http://127.0.0.1:7071/api/id/?code=<key>';

const getVisitCount = ()=>{
    let count = 30;
    fetch(prodFunctonUrl).then(response => {
        return response.json()
    }).then(response =>{
        console.log("Website called function API");
        // count = response.count;
        document.getElementById("counter").innerText = response;
    }).catch(function(error){
        console.log(error);
    });
    return count;

}

