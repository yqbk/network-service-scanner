export function post (url, data)
{
    return new Promise((resolve, reject) => {
        const http = new XMLHttpRequest();
        http.open("POST", url, true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");

        http.onreadystatechange = function() {
            if(http.readyState === 4) {
                if(http.status === 200) {
                    resolve(http.responseText);
                } else {
                    reject('error ' + http.status)
                }
            }
        }
        http.send("host%5BIP%5D=192.168.0.1&host%5Bport%5D=80&host%5Bscann_type%5D=fin");
    })
}
