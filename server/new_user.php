<?php
// Create account. Game expects, comma-separated with no extra whitespace:
//   200,<account_key>  success
//   300                username or email already exists
//   400                database error
//   500                bad auth key
declare(strict_types=1);
require __DIR__ . '/lib.php';

ttp_check_auth();

$user  = trim(ttp_post('user'));
$email = trim(ttp_post('email'));
$pass  = ttp_post('pass'); // sha1 hex of the password, computed by the game

if ($user === '' || $email === '' || $pass === '') {
    echo '300';
    exit;
}

try {
    $db = ttp_db();
    $stmt = $db->prepare('SELECT COUNT(*) FROM users WHERE username = ? OR email = ?');
    $stmt->execute([$user, $email]);
    if ((int) $stmt->fetchColumn() > 0) {
        echo '300';
        exit;
    }
    $accountKey = sha1($user . '|' . $email . '|' . bin2hex(random_bytes(16)) . '|' . time());
    // The game sends sha1(password); never store that as-is — wrap it in a
    // modern password hash server-side (Claude review hardening, 2026-10-30).
    $stored = password_hash($pass, PASSWORD_DEFAULT);
    $stmt = $db->prepare('INSERT INTO users (username, email, pass_sha1, account_key, created_at)
                          VALUES (?, ?, ?, ?, ?)');
    $stmt->execute([$user, $email, $stored, $accountKey, time()]);
    echo '200,' . $accountKey;
} catch (Throwable $e) {
    echo '400';
}
