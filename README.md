# ハッカソンのコードレビュー用ツール

## このリポジトリの使い方
### セットアップ
git clone
```bash
git clone https://github.com/F0rte/hackathon-review.git
```

使用には、jqのインストールが必要です。また、Makefileを使用するため、WindowsではGit Bashの使用を推奨します。
```bash
# Linux
sudo apt-get update
sudo apt-get install jq

# Mac
brew install jq

# Windows (winget) ※ makeコマンドのインストールも必要
winget install jqlang.jq
winget install ezwinports.make
```

### team-import
`config/teams.txt`に各チーム名を入力します。形式は`config/teams.txt.example`を参照してください。  
※乱数で発表順を確定させた時のDiscordに送信されるテキストを参考に実装しています。  

このコマンドを実行すると、json形式のファイルが作成されます。  
出力形式の例に、`config/repos.json.example`を配置しています。
```bash
make team-import
```
実行後は、適宜`config/repos.json`にチームのGitHubリポジトリを記入してください。

### clone
このコマンドを実行して、各チームのリポジトリを一括で clone します。

```bash
make clone-all
```
GitHubリポジトリが未登録のチームは、`config/repos.json`を更新後、clone-allを再実行してください。  
未登録・clone済みはskipされます。  
各チームのリポジトリを、チーム名のディレクトリ内にcloneします。  
<img width="213" height="343" alt="image" src="https://github.com/user-attachments/assets/b1d1bb7a-de94-4288-b308-0271e9848776" />



### pull
```bash
make pull-all
```

を実行すると、各チームのリポジトリを一括で pull します。

※ 今いるブランチの pull であり、ブランチ移動を考慮してないです

`git switch`等実行する場合は注意してください

### clean
初期化するには、このコマンドを実行します。
```bash
make clean
```

個別に、
- cloneしたリポジトリのみ一括削除コマンドする場合は、このコマンドを実行します。
```bash
make repo-clean
```

- `config/repos.json`を初期化する場合は、このコマンドを実行します。
```bash
make team-clean
```
