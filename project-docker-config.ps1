$username = Read-Host "Please enter the username will be used for git ex: Jonathan, then press ENTER"
$mail = Read-Host "Please enter the mail will be used for git ex: jonathan.tom@gmail.com, then press ENTER"

git config --global user.name $username
git config --global user.email $mail

$nameProject = Read-Host "Please enter the name of project ex: myProject, this name will be used too for DB like myProject_db, then press ENTER"

symfony new $nameProject --webapp

code ./$nameProject

