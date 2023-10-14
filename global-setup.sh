#! /usr/bin/env sh

# 現在のスクリプトのディレクトリを取得し、そのディレクトリに移動します。
DIR=$(dirname "$0")
cd "$DIR"

# scripts/functions.shをソースとして読み込みます。
. scripts/functions.sh

# sudo パスワードのプロンプトを表示します。
info "sudo パスワードを求めています..."
if sudo -v; then
  # Keep-alive: `setup.sh` が終了するまで既存の `sudo` タイムスタンプを更新します。
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  success "sudo 資格情報を更新しました。"
else
  error "sudo 資格情報の取得に失敗しました。"
fi

# XCodeコマンドラインツールをインストールします。
info "XCode コマンドラインツールをインストールしています..."
if xcode-select --print-path &>/dev/null; then
  success "XCode コマンドラインツールはすでにインストールされています。"
elif xcode-select --install &>/dev/null; then
  success "XCode コマンドラインツールのインストールが完了しました。"
else
  error "XCode コマンドラインツールのインストールに失敗しました。"
fi

# Package controlは、残りの部分が機能するために最初に実行する必要があります。
./packages/setup.sh

# "setup.sh"という名前のすべてのファイルを検索し、それらのセットアップスクリプトを実行します（ただし、"packages*"のパスは除外します）。
find * -name "setup.sh" -not -wholename "packages*" | while read setup; do
  ./$setup
done

# Dotfilesのインストールが完了したことを通知します。
success "Dotfilesのインストールが完了しました"
