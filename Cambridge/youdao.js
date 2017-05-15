document.getElementsByClassName("c-topbar-wrapper")[0].remove()
document.getElementById("scontainer").innerHTML = document.getElementById("results").innerHTML
document.getElementById("c_footer").remove()
document.getElementsByClassName("results-content")[0].style.width = "100%"
document.getElementById("scontainer").style.marginTop = "0px"


if (document.getElementById("webTrans") != null)
{
var r1 = document.getElementById("webTrans").getElementsByTagName("h3")
if(r1.length >= 1)
{
    r1[0].remove()
}
}
if (document.getElementById("examples") != null)
{
var r2 = document.getElementById("examples").getElementsByTagName("h3")
if(r2.length >= 1)
{
    r2[0].remove()
}
}
if (document.getElementById("eTransform") != null)
{
var r3 = document.getElementById("eTransform").getElementsByTagName("h3")
if(r3.length >= 1)
{
    r3[0].remove()
}
}
var r4 = document.getElementsByClassName("more")
if(r4.length >= 1)
{
    r4[0].remove()
}

document.getElementById("ugcTrans").remove()
document.getElementById("webPhrase").remove()
document.getElementById("authTrans").remove()

document.documentElement.outerHTML+"@@@@"+document.getElementsByClassName("keyword")[0].innerText


