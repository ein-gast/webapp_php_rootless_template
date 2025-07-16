<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <link type="text/css" rel="stylesheet" href="/assets/error.css"></link>
</head>
<body>
<?php
echo htmlspecialchars($_GET['error'] ?? 'unknown');
?>
</body>
</html>
