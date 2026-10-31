<?php
// Login. Game expects:
//   200,<account_key>  success (the same key issued at registration)
//   300                username or password incorrect
//   500                bad auth key
declare(strict_types=1);
require __DIR__ . '/lib.php';

ttp_check_auth();

$user = trim(ttp_post('user'));
$pass = ttp_post('pass'); // sha1 hex of the password, computed by the game

try {
    $db = ttp_db();
    $stmt = $db->prepare('SELECT pass_sha1, account_key FROM users WHERE username = ?');
    $stmt->execute([$user]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($row !== false && hash_equals((string) $row['pass_sha1'], $pass)) {
        echo '200,' . $row['account_key'];
    } else {
        echo '300';
    }
} catch (Throwable $e) {
    echo '300';
}
