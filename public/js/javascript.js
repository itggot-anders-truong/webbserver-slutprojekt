var friendlist = document.querySelector(".friendlist")
var searchlist = document.querySelector(".searchlist")

if ($(".searchinput").val().length > 0) {
    friendlist.classList.add("hide")
    searchlist.classList.remove("hide")
}

$(".searchinput").on("input",function(e)    {
    sessionStorage.removeItem("searchresult")
    sessionStorage.removeItem("search")
    if ($(".searchinput").val().length > 0) {
        friendlist.classList.add("hide")
        searchlist.classList.remove("hide")
    } else {
        friendlist.classList.remove("hide")
        searchlist.classList.add("hide")
    }
})