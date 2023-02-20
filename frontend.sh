echo -e "\e[36mInstalling nginx\e[0m"
yum install nginx -y

echo -e "\e[36mRemoving old content nginx\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36mDownloading nginx\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36mExtracting file nginx\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36mCopying configs of nginx for roboshop\e[0m"
cp configs/nginx-roboshop.conf /etc/nginx/defaullt..d/roboshop..conf

echo -e "\e[36mEnabling nginx\e[0m"
systemctl enable nginx

echo -e "\e[36mStarting nginx\e[0m"
systemctl resstart nginx
