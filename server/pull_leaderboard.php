<?php
// Leaderboard for one chart. Game posts artist/song/difficulty and
// json_decodes the reply, expecting a JSON array of objects:
//   [{"user": "name", "score": 12345}, ...]
// Best score per user, highest first.
declare(strict_types=1);
require __DIR__ . '/lib.php';

ttp_check_auth();

$artist     = ttp_post('artist');
$song       = ttp_post('song');
$difficulty = ttp_post('difficulty');

try {
    $db = ttp_db();
    $stmt = $db->prepare(
        'SELECT u.username AS user, MAX(s.score) AS score
           FROM scores s
           JOIN users u ON u.id = s.user_id
          WHERE s.artist = ? AND s.song = ? AND s.difficulty = ?
          GROUP BY s.user_id
          ORDER BY score DESC
          LIMIT 100'
    );
    $stmt->execute([$artist, $song, $difficulty]);
    $rows = [];
    foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $r) {
        $rows[] = ['user' => $r['user'], 'score' => (int) $r['score']];
    }
    header('Content-Type: application/json');
    echo json_encode($rows);
} catch (Throwable $e) {
    header('Content-Type: application/json');
    echo '[]';
}
