#!/bin/zsh
# セッションの名前
SESSION_NAME=config

# ワークスペースの数
WORKSPACE_COUNT=3

# ワークスペース(タブ)の名前
WORKSPACE_NAME=(
  NeoVim
  tmux
  alacritty
)

# ワークスペースのパス
WORKSPACE_PATH=(
  ~/.config/nvim
  ~/.config/tmux
  ~/.config/alacritty
)

# 同じレイアウトで複数のワークスペースを作成
# 同じレイアウトで複数のワークスペースを作成
for ((I=1; I<=$WORKSPACE_COUNT; I++)); do
  if [ $I = 1 ]; then
    # 1つ目のワークスペースはセッション作成と同時に作成
    tmux new-session -d -A -s "$SESSION_NAME" -c $WORKSPACE_PATH[$I] -x 64 -y 64
  else
    # 以降のワークスペースはウィンドウを作成
    tmux new-window -c $WORKSPACE_PATH[$I]
  fi
  # ウィンドウの名前を変更
  tmux rename-window "$WORKSPACE_NAME[$I]"
  # 縦 75% の位置で分割
  tmux split-window -v -p 75 -c "#{pane_current_path}"
  # neovim を起動
  tmux send-keys 'nvim +"Neotree focus"' Enter
  tmux select-pane -t 0
  # 横 3等分に分割
  tmux split-window -h -p 66 -c "#{pane_current_path}"
  tmux split-window -h -p 50 -c "#{pane_current_path}"
  tmux select-pane -t 3
  # メインのペインにフォーカスしてズーム
  tmux resize-pane -Z
done
# 最初のウィンドウにフォーカスする
tmux select-window -t 0
​
# 現在のターミナルをセッションにアタッチする
tmux attach -t $SESSION_NAME
