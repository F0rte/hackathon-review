team-import:
	@if [ ! -f config/teams.txt ]; then \
		echo "エラー: config/teams.txt が見つかりません"; \
		exit 1; \
	fi; \
	mkdir -p config; \
	if [ ! -f config/repos.json ]; then \
		echo '{}' | jq '.' > config/repos.json; \
		echo "config/repos.json を作成しました"; \
	fi; \
	echo "config/teams.txt からチームをインポートします..."; \
	teams=""; \
	cat config/teams.txt | grep -v '^[[:space:]]*$$' | while IFS=: read -r num name; do \
		team_name=$$(echo "$$name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$$//'); \
		echo "  → $$team_name を追加"; \
		jq --arg name "$$team_name" '. + {($$name): ""}' config/repos.json > config/repos.json.tmp && \
		mv config/repos.json.tmp config/repos.json; \
	done; \
	sed -i '/^# === チームディレクトリ（自動生成） ===$$/,/^# === チームディレクトリここまで ===$$/c\
# === チームディレクトリ（自動生成） ===\
# この行から下の「=== チームディレクトリここまで ===」までは\
# make team-import で自動更新されます' .gitignore; \
	cat config/teams.txt | grep -v '^[[:space:]]*$$' | while IFS=: read -r num name; do \
		team_name=$$(echo "$$name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$$//'); \
		echo "$$team_name/" >> .gitignore; \
	done; \
	echo "# === チームディレクトリここまで ===" >> .gitignore; \
	echo "✓ インポート完了"

team-clean:
	@mkdir -p config
	@echo '{}' | jq '.' > config/repos.json
	@sed -i '/^# === チームディレクトリ（自動生成） ===$$/,/^# === チームディレクトリここまで ===$$/c\
# === チームディレクトリ（自動生成） ===\
# この行から下の「=== チームディレクトリここまで ===」までは\
# make team-import で自動更新されます\
# === チームディレクトリここまで ===' .gitignore
	@echo "✓ config/repos.json を初期化しました"
	@echo "✓ .gitignore のチームディレクトリをクリアしました"


clone-all:
	@jq -r 'to_entries[] | "\(.key) \(.value)"' config/repos.json | while read name url; do \
		if [ -z "$$url" ]; then \
			echo "skip $$name: no repository URL"; \
			continue; \
		fi; \
		if [ -d "$$name" ]; then \
			echo "skip $$name: already exists"; \
		else \
			echo "cloning $$name from $$url"; \
			git clone "$$url" "$$name"; \
		fi; \
	done

pull-all:
	@find . -type d -name ".git" | while read gitdir; do \
		repo_dir=$$(dirname "$$gitdir"); \
		if [ "$$repo_dir" = "." ]; then \
			continue; \
		fi; \
		echo "==== $$repo_dir ===="; \
		cd "$$repo_dir"; \
		git pull; \
		cd - > /dev/null; \
	done

repo-clean:
	@find . -type d -name ".git" | while read gitdir; do \
		repo_dir=$$(dirname "$$gitdir"); \
		if [ "$$repo_dir" = "." ]; then \
			continue; \
		fi; \
		echo "==== $$repo_dir ===="; \
		rm -rf "$$repo_dir"; \
	done


clean:
	@make repo-clean
	@make team-clean
