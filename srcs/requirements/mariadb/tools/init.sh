#!/bin/bash

# 환경 변수를 사용하여 사용자 비밀번호 설정
USER1_PASSWORD=${USER1_PASSWORD:-password1}
USER2_PASSWORD=${USER2_PASSWORD:-password2}

# MariaDB 서버 시작
mysqld_safe &

# 서버가 시작될 때까지 대기
while ! mysqladmin ping --silent; do
    sleep 1
done

# 사용자 생성
mysql -e "CREATE USER 'user1'@'%' IDENTIFIED BY '${USER1_PASSWORD}';"
mysql -e "CREATE USER 'user2'@'%' IDENTIFIED BY '${USER2_PASSWORD}';"

# 데이터베이스 생성
mysql -e "CREATE DATABASE wordpress;"

# 사용자에게 데이터베이스 권한 부여
mysql -e "GRANT ALL ON wordpress.* TO 'user1'@'%';"
mysql -e "GRANT ALL ON wordpress.* TO 'user2'@'%';"

# 변경 사항 적용
mysql -e "FLUSH PRIVILEGES;"

# MariaDB 서버 종료하지 않고 대기
wait $!