@echo off

if "%1"=="" (
	echo %~nx0 ^<cotainer name^>
	exit /B 1
)

REM テーマ
echo テーマをインストールします。
docker exec -it %1 git clone https://github.com/farend/redmine_theme_farend_basic.git public/themes/farend_basic
docker exec -it %1 git clone https://github.com/farend/redmine_theme_farend_fancy.git public/themes/farend_fancy

echo プラグインをインストールします。

REM プラグイン（マイグレーション必要なし）
docker exec -it %1 git clone https://github.com/bdemirkir/sidebar_hide.git plugins/sidebar_hide
docker exec -it %1 git clone https://github.com/peclik/clipboard_image_paste.git plugins/clipboard_image_paste
docker exec -it %1 git clone https://github.com/tleish/redmine_editor_preview_tab plugins/redmine_editor_preview_tab

REM プラグイン（マイグレーション必要あり）
docker exec -it %1 git clone https://github.com/ncoders/redmine_local_avatars.git plugins/redmine_local_avatars
docker exec -it %1 git clone https://github.com/a-ono/redmine_ckeditor plugins/redmine_ckeditor
docker exec -it %1 bundle install --without development test

echo マイグレーションを実行します。
docker exec -it %1 bundle exec rake redmine:plugins:migrate RAILS_ENV=production

echo キッティング完了。コンテナを再起動します。

docker-compose restart

