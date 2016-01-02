<?php
$token = "YOUR_SHA1_TOKEN";
$file = "/var/www/ninux_topology.txt";

if(isset($_POST["data"]) && !empty($_POST["data"]) && isset($_POST["token"]) && $_POST["token"] === $token) {
    $topology = fopen($file, "w") or die("Unable to open file, check permissions!");
    fwrite($topology, $_POST["data"]);
    fclose($topology);
}
?>
