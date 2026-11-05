<?php
// Illustrative PDO menu-search example from the report.
// Set $user, $pass and $keyword before running.
$pdo = new PDO(
    'mysql:host=localhost;dbname=food_ordering;charset=utf8mb4',
    $user,
    $pass,
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
);

$stmt = $pdo->prepare(
    'SELECT item_id, item_name, price FROM menu_items
     WHERE is_available = 1 AND item_name LIKE :kw'
);
$stmt->execute([':kw' => '%' . $keyword . '%']);
$items = $stmt->fetchAll(PDO::FETCH_ASSOC);

foreach ($items as $row) {
    echo htmlspecialchars($row['item_name']) . ' - ' . $row['price'];
}
