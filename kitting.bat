@echo off

if "%1"=="" (
	echo %~nx0 ^<cotainer name^>
	exit /B 1
)

REM �e�[�}
echo �e�[�}���C���X�g�[�����܂��B
docker exec -it %1 git clone https://github.com/farend/redmine_theme_farend_basic.git public/themes/farend_basic
docker exec -it %1 git clone https://github.com/farend/redmine_theme_farend_fancy.git public/themes/farend_fancy

echo �v���O�C�����C���X�g�[�����܂��B

REM �v���O�C���i�}�C�O���[�V�����K�v�Ȃ��j
docker exec -it %1 git clone https://github.com/bdemirkir/sidebar_hide.git plugins/sidebar_hide
docker exec -it %1 git clone https://github.com/peclik/clipboard_image_paste.git plugins/clipboard_image_paste
docker exec -it %1 git clone https://github.com/tleish/redmine_editor_preview_tab plugins/redmine_editor_preview_tab

REM �v���O�C���i�}�C�O���[�V�����K�v����j
docker exec -it %1 git clone https://github.com/ncoders/redmine_local_avatars.git plugins/redmine_local_avatars
docker exec -it %1 git clone https://github.com/a-ono/redmine_ckeditor plugins/redmine_ckeditor
docker exec -it %1 bundle install --without development test

echo �}�C�O���[�V���������s���܂��B
docker exec -it %1 bundle exec rake redmine:plugins:migrate RAILS_ENV=production

echo �L�b�e�B���O�����B�R���e�i���ċN�����܂��B

docker-compose restart

