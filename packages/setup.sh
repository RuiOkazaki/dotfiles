#! /usr/bin/env sh

# 現在のスクリプトのディレクトリを取得し、そのディレクトリに移動します。
DIR=$(dirname "$0")
cd "$DIR"

# ../scripts/functions.sh をソースとして読み込みます。
. ../scripts/functions.sh

# "#" で始まる行をコメントとして扱うための変数を設定します。
COMMENT=\#*

# sudo の権限を確認します。
sudo -v

# Brewfile のパッケージをインストールします。
info "Brewfile のパッケージをインストールしています..."
brew bundle
success "Brewfile のパッケージのインストールが完了しました。"
