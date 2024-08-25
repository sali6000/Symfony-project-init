$username = Read-Host "Please enter the username will be used for git ex: Jonathan, then press ENTER"
$mail = Read-Host "Please enter the mail will be used for git ex: jonathan.tom@gmail.com, then press ENTER"

git config --global user.name $username
git config --global user.email $mail
