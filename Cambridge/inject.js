var word = document.body.getElementsByClassName("hw")[1].innerText
document.body.getElementsByClassName("hw")[1].outerHTML = ""

var uk = "#"
var us = "#"

if(document.getElementsByClassName("circle circle-btn sound audio_play_button uk").length >= 1)
{
    uk = document.getElementsByClassName("circle circle-btn sound audio_play_button uk")[0].getAttribute("data-src-mp3")
}

if(document.getElementsByClassName("circle circle-btn sound audio_play_button us").length >= 1)
{
    us = document.getElementsByClassName("circle circle-btn sound audio_play_button us")[0].getAttribute("data-src-mp3")
}


var uks = document.getElementsByClassName("circle circle-btn sound audio_play_button uk")
for (var i = (uks.length-1); i >= 0; i--) {
    uks[i].parentNode.removeChild(uks[i]);
}
var uss = document.getElementsByClassName("circle circle-btn sound audio_play_button us")
for (var i = (uss.length-1); i >= 0; i--) {
    uss[i].parentNode.removeChild(uss[i]);
}




//var us = document.getElementsByClassName("circle circle-btn sound audio_play_button us")[0].getAttribute("data-src-mp3")


//document.body.innerHTML = document.getElementsByClassName("di-body")[0].innerHTML;



var shares = document.getElementsByClassName("share rounded js-share")

for (var i=0; i < shares.length; i++){
shares[i].innerHTML = "";
shares[i].style.visibility='hidden';
}


var s = document.getElementsByClassName("share rounded js-share")

for (var i=0; i < shares.length; i++){
    shares[i].innerHTML = "";
    shares[i].style.visibility='hidden';
}

var r = document.head.getElementsByTagName('script');

for (var i = (r.length-1); i >= 0; i--) {
    
        r[i].parentNode.removeChild(r[i]);
}

var starts = document.getElementsByClassName("wordlist-button circle circle-btn circle-btn--sml circle-btn--alt fav-entry")

for (var i = (starts.length-1); i >= 0; i--) {
    starts[i].parentNode.removeChild(starts[i]);
}

var dictionaryBody = document.getElementsByClassName("di-body")[0].innerHTML

//dictionaryBody

dictionaryBody+"@@@@"+word+"@@@@"+uk+"@@@@"+us;

