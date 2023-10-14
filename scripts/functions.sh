#! /usr/bin/env sh

# シンボリックリンクを作成する関数
symlink() {
    OVERWRITTEN=""
    # 対象のパスに既にファイルまたはシンボリックリンクが存在するかチェック
    if [ -e "$2" ] || [ -h "$2" ]; then
        OVERWRITTEN="(上書き)"
        # 既存のファイルまたはシンボリックリンクの削除を試みる
        if ! rm -r "$2"; then
            substep_error "$2 の既存のファイル(群)の削除に失敗しました。"
        fi
    fi
    # シンボリックリンクの作成を試みる
    if ln -s "$1" "$2"; then
        substep_success "$2 を $1 へシンボリックリンクしました。 $OVERWRITTEN"
    else
        substep_error "$2 から $1 へのシンボリックリンク作成に失敗しました。"
    fi
}

# 壊れたシンボリックリンクをクリアする関数
clear_broken_symlinks() {
    # 壊れたシンボリックリンクを検索し、それらを削除する
    find -L "$1" -type l | while read fn; do
        if rm "$fn"; then
            substep_success "$fn における壊れたシンボリックリンクを削除しました。"
        else
            substep_error "$fn における壊れたシンボリックリンクの削除に失敗しました。"
        fi
    done
}

# これらの出力関数は https://github.com/Sajjadhosn/dotfiles から取得されました
coloredEcho() {
    local exp="$1";
    local color="$2";
    local arrow="$3";
    # 色番号が提供されていない場合は色名を色番号にマッピング
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    # テキストを太字かつ指定された色で出力
    tput bold;
    tput setaf "$color";
    echo "$arrow $exp";
    tput sgr0;  # テキストの書式をリセット
}

# 情報メッセージを出力する関数
info() {
    coloredEcho "$1" blue "========>"
}

# 成功メッセージを出力する関数
success() {
    coloredEcho "$1" green "========>"
}

# エラーメッセージを出力する関数
error() {
    coloredEcho "$1" red "========>"
}

# サブステップの情報メッセージを出力する関数
substep_info() {
    coloredEcho "$1" magenta "===="
}

# サブステップの成功メッセージを出力する関数
substep_success() {
    coloredEcho "$1" cyan "===="
}

# サブステップのエラーメッセージを出力する関数
substep_error() {
    coloredEcho "$1" red "===="
}
