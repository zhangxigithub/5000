
var r = document.getElementsByTagName('script');

for (var i = (r.length-1); i >= 0; i--) {
    
    r[i].parentNode.removeChild(r[i]);
}


var r2 = document.getElementsByTagName('iframe');

for (var i = (r2.length-1); i >= 0; i--) {
    
    r2[i].parentNode.removeChild(r2[i]);
}






try
{
    document.getElementsByClassName("wgt-incentive-anchors")[0].remove()
}catch(err){}
try
{
    document.getElementsByClassName("additional-content-area")[0].remove()
}catch(err){}
try
{
    document.getElementsByClassName("shrinkheader default")[0].remove()
}catch(err){}
try
{
    document.getElementsByClassName("menu-filler default")[0].remove()
}catch(err){}
try
{
    document.getElementsByClassName("home-top-creative-cont border-box")[0].remove()
}catch(err){}

try
{
    document.getElementsByClassName("wgt-side wgt-games-side bottom-location")[0].remove()
}catch(err){}

try
{
    document.getElementsByClassName("definitions-ad definitions-center-creative-cont")[0].remove()
}catch(err){}


try
{
    document.getElementsByClassName("wgt-related-to jc-card-box clearfix")[0].remove()
}catch(err){}


try
{
    document.getElementsByClassName("social-sidebar")[0].remove()
}catch(err){}

try
{
    document.getElementsByClassName("right-rail")[0].remove()
}catch(err){}

try
{
    document.getElementsByClassName("global-footer")[0].remove()
}catch(err){}

try
{
    document.body.getElementById("subscribe-unabridged").remove()
}catch(err){}

try
{
    //document.getElementById("").remove()
}catch(err){}


//document.getElementsByClassName("word-and-pronunciation")[0].getElementsByTagName('h1')[0].innerText
//document.body.getElementsByClassName("play-pron converted")[0].click()

document.documentElement.outerHTML+"@@@@"+document.getElementsByClassName("word-and-pronunciation")[0].getElementsByTagName('h1')[0].innerText
