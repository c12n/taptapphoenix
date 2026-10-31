<?php
// Submit a score. Game posts userkey + validitykey + score/artist/song/
// difficulty, where
//   validitykey = sha1( md5(account_key) . sha1(score) . md5(artist) . sha1(song) )
// (hex digests concatenated as strings). Game expects:
//   200  success (opens the leaderboard)
//   300  validity check failed
//   400  user key not found
//   402  score could not be submitted
//   500  bad auth key
declare(strict_types=1);
require __DIR__ . '/lib.php';

ttp_check_auth();

$userkey     = ttp_post('userkey');
$validitykey = ttp_post('validitykey');
$scoreRaw    = ttp_post('score');
$artist      = ttp_post('artist');
$song        = ttp_post('song');
$difficulty  = ttp_post('difficulty');

try {
    $db = ttp_db();
    $stmt = $db->prepare('SELECT id, account_key FROM users WHERE account_key = ?');
    $stmt->execute([$userkey]);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($row === false) {
        echo '400';
        exit;
    }
    $expected = sha1(md5((string) $row['account_key']) . sha1($scoreRaw) . md5($artist) . sha1($song));
    if (!hash_equals($expected, $validitykey)) {
        echo '300';
        exit;
    }
    $stmt = $db->prepare('INSERT INTO scores (user_id, artist, song, difficulty, score, created_at)
                          VALUES (?, ?, ?, ?, ?, ?)');
    $stmt->execute([(int) $row['id'], $artist, $song, $difficulty, (int) $scoreRaw, time()]);
    echo '200';
} catch (Throwable $e) {
    echo '402';
}
