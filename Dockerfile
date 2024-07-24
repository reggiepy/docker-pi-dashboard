# 容器化环境自动构建
FROM balenalib/rpi-raspbian
LABEL version="0.2"
LABEL description="Pi Dashboard for Docker"
MAINTAINER ecat <wangtongpy@foxmail.com>

# 环境变量配置
ENV www_root /var/www
ENV www_name pi-dashboard
ENV git_repo "https://github.com/spoonysonny/pi-dashboard.git"

ENV nginx_default /etc/nginx/sites-available/default

# 安装依赖
RUN apt-get update  \
	&& apt-get install -y git nginx php7.4-fpm php7.4-cli php7.4-curl php7.4-gd php7.4-cgi \
	&& rm -rf /var/lib/apt/lists/*

# 下载dashboard
RUN cd ${www_root} \
	&& git clone $git_repo $www_name --depth 1

# 复制nginx配置
COPY $nginx_default $nginx_default

# 卸载中间工具

RUN apt-get remove -y git

# 复制启动脚本
COPY /run.sh /run.sh
RUN chmod 777 /run.sh
CMD /run.sh
