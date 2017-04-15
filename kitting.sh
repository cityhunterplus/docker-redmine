#!/bin/sh

if [ $# -lt 1 ]; then
	echo $0 "<container name>"
	exit 1
fi

# =========================================================
# テーマ
# =========================================================
echo "テーマをインストールします。"
docker exec -it $1 git clone https://github.com/farend/redmine_theme_farend_basic.git public/themes/farend_basic
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 10
fi

docker exec -it $1 git clone https://github.com/farend/redmine_theme_farend_fancy.git public/themes/farend_fancy
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 11
fi

echo "プラグインをインストールします。"

# =========================================================
# プラグイン（マイグレーション必要なし）
# =========================================================
docker exec -it $1 git clone https://github.com/bdemirkir/sidebar_hide.git plugins/sidebar_hide
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 20
fi

docker exec -it $1 git clone https://github.com/peclik/clipboard_image_paste.git plugins/clipboard_image_paste
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 21
fi

docker exec -it $1 git clone https://github.com/tleish/redmine_editor_preview_tab plugins/redmine_editor_preview_tab
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 22
fi

# =========================================================
# プラグイン（マイグレーション必要あり）
# =========================================================
# Git から clone。
docker exec -it $1 git clone https://github.com/ncoders/redmine_local_avatars.git plugins/redmine_local_avatars
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 30
fi

docker exec -it $1 git clone https://github.com/a-ono/redmine_ckeditor plugins/redmine_ckeditor
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 31
fi

# コピー
#cp -r kitting/easy_gantt redmine/plugins/easy_gantt
docker exec -it $1 git clone https://cityhunterplus@bitbucket.org/cityhunterplus/my-easy-gantt.git plugins/easy_gantt
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 40
fi

# =========================================================
# マイグレーション
# =========================================================
echo "マイグレーションを実行します。"

docker exec -it $1 bundle install --without development test
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 32
fi

docker exec -it $1 bundle exec rake db:migrate RAILS_ENV=production
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 50
fi

docker exec -it $1 bundle exec rake redmine:plugins:migrate RAILS_ENV=production
# 直前の処理が正常終了でなければ終了。
if [ $? -ne 0 ]; then
	exit 51
fi

echo "キッティング完了。コンテナを再起動します。"

docker-compose restart

