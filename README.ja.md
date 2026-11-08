# omarchy-theme-schedule

[Omarchy](https://omarchy.org/) のテーマを、決まった時刻か日の出・日の入りに合わせて、明るい版と暗い版の間で切り替える。手動のままにもでき、どちらにするかは Omarchy のメニューから選べる。

[English](README.md)

## できること

- **自動（時刻）**: `LIGHT_AT` の時刻に明るい版、`DARK_AT` の時刻に暗い版へ切り替える。
- **自動（日の出・日の入り）**: 日の出で明るい版、日の入りで暗い版へ切り替える。時刻は手元で計算し、ネットにも位置情報のサービスにも問い合わせない。場所は `LOCATION` を書かなければ、タイムゾーンの代表の都市を使う。
- **手動**: 何もしない（入れた直後はこちら）。
- どれにするかは、Omarchy のメニュー（**Appearance → Light/Dark**）か `theme-schedule time|sun|manual` で選ぶ。
- 途中で手でテーマを替えたら、次の切り替えの時刻までそのままにする。
- 明るい版と暗い版の組がないテーマのときは何もしない。
- 表示とメニューの言葉は、Omarchy の言語設定（なければロケール）に合わせる。日本語と英語があり、ほかの言語では英語になる。

## 必要なもの

Omarchy（Hyprland と systemd のユーザーセッション）。ほかには要らない。

## 入れ方

```sh
git clone https://github.com/MoomA-0750/omarchy-theme-schedule
cd omarchy-theme-schedule
./install.sh
```

入るもの:

| ファイル | 役目 |
|---|---|
| `~/.local/bin/theme-schedule` | コマンド本体 |
| `~/.config/omarchy/theme-schedule.conf` | 設定（すでにあれば上書きしない） |
| `~/.config/systemd/user/theme-schedule.{service,timer}` | ログイン時と1分ごとにコマンドを呼ぶ |
| `~/.config/omarchy/extensions/omarchy-menu.jsonc` の中の印付きの部分 | メニューの Light/Dark の項目 |

入れた直後は手動。自動にするには `theme-schedule time` / `theme-schedule sun` か、メニューから選ぶ。

## 外し方

```sh
./uninstall.sh          # 設定ファイルは残す
./uninstall.sh --purge  # 設定ファイルも消す
```

## 使い方

```sh
theme-schedule time       # 時刻で自動にして、今の時間帯のテーマにする
theme-schedule sun        # 日の出・日の入りで自動にして、今の時間帯のテーマにする
theme-schedule auto       # 前に使った方で自動にする
theme-schedule manual     # 手動にする（テーマは今のまま）
theme-schedule toggle     # 自動と手動を入れ替える
theme-schedule --status   # 切り替え方・テーマ・今日の切り替え時刻・場所を表示
theme-schedule --now      # 今の時間帯のテーマにすぐ切り替える
theme-schedule menu       # メニューの項目を今の言語で書き直す
```

Omarchy の言語を変えたら、`theme-schedule menu` を1回実行するとメニューの言葉も変わる。

## 設定

`~/.config/omarchy/theme-schedule.conf`:

```sh
MODE=manual        # auto か manual
SCHEDULE=time      # 自動のときに合わせるもの: time か sun
LIGHT_AT=07:00     # time: 明るい版にする時刻
DARK_AT=18:00      # time: 暗い版にする時刻
LOCATION=""        # sun: 「緯度,経度」。例: "35.68,139.77"。空ならタイムゾーンから求める
SUNRISE_OFFSET=0   # sun: 日の出から何分ずらすか（マイナスで早める）
SUNSET_OFFSET=0    # sun: 日の入りから何分ずらすか
PAIRS=(            # 名前の決まりで見つからない組を「明るい版 暗い版」の順で書く
  "catppuccin-latte catppuccin"
)
```

タイマーは1分ごとに確かめるので、時刻を変えても systemd の設定は直さなくてよい。

日の出・日の入りは標準の計算式で求める（誤差は2分ほど）。場所が分からないときと、日の出・日の入りがない日（極夜・白夜）は `LIGHT_AT` / `DARK_AT` を使う。

## 組になるテーマの見つけ方

1. `PAIRS` に書いた組
2. 名前の決まり: `<名前>-light` と `<名前>`（または `<名前>-dark`）

どちらが明るい版かは、各テーマの `colors.toml` の `mode` で判断する。テーマは `~/.config/omarchy/themes/` と Omarchy に入っているテーマから探す。

## ライセンス

MIT
