#!/usr/bin/env bash

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                              npm-bootstrap.sh                                ║
# ╟──────────────────────────────────────────────────────────────────────────────╢
# ║ Author: Joshua Ross                                                          ║
# ║ Date: 10/10/2024                                                             ║
# ║ Description: Install a basic bootstrap template.                             ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Make npm project
function npm_install() {
    npm init -y
    npm install bootstrap express
    npm install -D nodemon
}

# Create Index.html file.
function create_index() {
    cat << EOF > index.html

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Document</title>
<link rel="stylesheet" href="/node_modules/bootstrap/dist/css/bootstrap.css">
</head>
<body>
<h1 align="center"> Hello World! </h1>

<script src="/node_modules/bootstrap/dist/js/bootstrap.bundle.js"></script>
</body>
</html>
EOF
}

# Call the functions, to do the needful.
npm_install
create_index

