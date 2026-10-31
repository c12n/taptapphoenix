<?php
// Tap Tap Phoenix (c12n revival) — shared backend helpers.
// The 2020 game talks to four endpoints (new_user.php, user_login.php,
// pull_leaderboard.php, update_leaderboard.php) with a shared-secret
// ?auth= key baked into the game data, sha1 password hashes, and a
// sha1/md5 validity checksum for score submissions. This reimplements
// that protocol exactly as the decompiled game code expects it.

declare(strict_types=1);

function ttp_auth_key(): string
{
    $k = getenv('TTP_AUTH_KEY');
    if ($k === false || $k === '') {
        $f = __DIR__ . '/auth_key.txt';
        $k = is_file($f) ? trim((string) file_get_contents($f)) : '';
    }
    return $k;
}

function ttp_check_auth(): void
{
    $auth = $_GET['auth'] ?? '';
    if (!hash_equals(ttp_auth_key(), (string) $auth)) {
        echo '500';
        exit;
    }
}

function ttp_db(): PDO
{
    static $db = null;
    if ($db instanceof PDO) {
        return $db;
    }
    $dir = getenv('TTP_DATA_DIR') ?: (__DIR__ . '/data');
    if (!is_dir($dir)) {
        mkdir($dir, 0775, true);
    }
    $db = new PDO('sqlite:' . $dir . '/ttp.sqlite');
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $db->exec('CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        pass_sha1 TEXT NOT NULL,
        account_key TEXT NOT NULL UNIQUE,
        created_at INTEGER NOT NULL
    )');
    $db->exec('CREATE TABLE IF NOT EXISTS scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL REFERENCES users(id),
        artist TEXT NOT NULL,
        song TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        score INTEGER NOT NULL,
        created_at INTEGER NOT NULL
    )');
    $db->exec('CREATE INDEX IF NOT EXISTS idx_scores_chart
        ON scores (artist, song, difficulty, score DESC)');
    return $db;
}

function ttp_post(string $name): string
{
    return isset($_POST[$name]) ? (string) $_POST[$name] : '';
}
