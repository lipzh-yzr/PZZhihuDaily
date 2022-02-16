-- 创建数据库 --
CREATE TABLE IF NOT EXISTS "News" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "type" INTEGER,
    "title" TEXT,
    "hint" TEXT,
    "newsId" TEXT,
    "createTime" TEXT DEFAULT (datetime('now', 'localtime'))
);
