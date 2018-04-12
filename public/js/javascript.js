function register() {
    if (document.querySelector('.password1').value != document.querySelector('.password2').value) {
        console.log(document.querySelector('.password1').value)
        console.log(document.querySelector('.password2').value)
        window.alert("Passwords does not match");
        return false
    }

    return true
    
}