#!/bin/bash
set -e

# 刪除可能存在的 server.pid 文件
rm -f /app/tmp/pids/server.pid

# 然後執行傳遞給腳本的命令
exec "$@"