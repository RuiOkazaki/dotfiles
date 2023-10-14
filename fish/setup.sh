#! /usr/bin/env sh

# 現在のスクリプトのディレクトリを取得し、そのディレクトリに移動します。
DIR=$(dirname "$0")
cd "$DIR"

# ../scripts/functions.shをソースとして読み込みます。
. ../scripts/functions.sh

# 現在のディレクトリとユーザーのfish設定ディレクトリの絶対パスを取得します。
SOURCE="$(realpath -m .)"
DESTINATION="$(realpath -m ~/.config/fish)"

# fish shellの設定を開始することを通知します。
info "fish shellを設定しています..."

# *.fishファイルとfish_pluginsを検索し、それらをfishの設定ディレクトリにシンボリックリンクします。
find * -name "*.fish" -o -name "fish_plugins" | while read fn; do
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done
# 壊れたシンボリックリンクをクリアします。
clear_broken_symlinks "$DESTINATION"

# fish shellを設定する関数を定義します。
set_fish_shell() {
    # 既にfish shellが設定されているかチェックします。
    if grep --quiet fish <<< "$SHELL"; then
        success "fish shellはすでに設定されています。"
    else
        # /etc/shellsにfish実行可能ファイルを追加します。
        substep_info "fish実行可能ファイルを/etc/shellsに追加しています"
        if grep --fixed-strings --line-regexp --quiet "$(which fish)" /etc/shells; then
            substep_success "fish実行可能ファイルはすでに/etc/shellsに存在します。"
        else
            # fish実行可能ファイルを/etc/shellsに追加します。
            if sudo bash -c "echo "$(which fish)" >> /etc/shells"; then
                substep_success "fish実行可能ファイルを/etc/shellsに追加しました。"
            else
                substep_error "fish実行可能ファイルを/etc/shellsに追加できませんでした。"
                return 1
            fi
        fi
        # シェルをfishに変更します。
        substep_info "シェルをfishに変更しています"
        if chsh -s "$(which fish)"; then
            substep_success "シェルをfishに変更しました"
        else
            substep_error "シェルをfishに変更できませんでした"
            return 2
        fi
    fi
}

# fish shellの設定を実行し、成功か失敗かを通知します。
if set_fish_shell; then
    success "fish shellの設定が成功しました。"
else
    error "fish shellの設定に失敗しました。"
fi
