#!/usr/bin/env bash
# marche_project セットアップスクリプト
# 前提: クローン済みのリポジトリ直下で、この一式を配置した状態で実行してください。
set -euo pipefail

PROJECT_ID="marche2026-86ab6"

echo "▶ 1/4 設定ファイルの確認"
if [ ! -f firebase-config.js ]; then
  echo "  ✗ firebase-config.js が見つかりません。リポジトリ直下で実行してください。"; exit 1
fi
if grep -q "PASTE_WEB_API_KEY\|PASTE_APP_ID" firebase-config.js; then
  echo "  ✗ firebase-config.js の apiKey / appId が未設定です。"
  echo "    Firebaseコンソール → プロジェクトの設定 → マイアプリ → ウェブアプリ の値に置換してから再実行してください。"
  exit 1
fi
echo "  ✓ 設定OK"

echo "▶ 2/4 firebase-tools の確認"
if ! command -v firebase >/dev/null 2>&1; then
  echo "  firebase CLI を導入します..."; npm install -g firebase-tools
fi
echo "  ✓ firebase CLI 利用可能"

echo "▶ 3/4 Firestore ルールを反映 (project: ${PROJECT_ID})"
firebase deploy --only firestore:rules --project "${PROJECT_ID}"

echo "▶ 4/4 GitHub へ push"
git add -A
git commit -m "Add reservation & check-in system" || echo "  （コミット対象なし）"
git push

echo ""
echo "✅ 完了。数十秒後に GitHub Pages で公開されます。"
echo "   Settings → Pages が『Deploy from a branch / main / (root)』になっているか確認してください。"
