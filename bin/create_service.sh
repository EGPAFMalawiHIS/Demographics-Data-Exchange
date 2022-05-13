mode="production"
service_name="dde4"
ruby="2.5.3"

actions() {
    tput setaf 6; read -p "Enter Application full path or press Enter to default to (/var/www/dde4): " app_dir
    if [ -z "$app_dir" ]
    then
        app_dir="/var/www/dde4"
    fi
}

actions
while [ ! -d $app_dir ]; do
    tput setaf 1; echo "===>Directory $app_dir DOES NOT EXISTS.<==="
    tput setaf 7;
    actions
done

app_core=$(grep -c processor /proc/cpuinfo)

read -p "Enter PORT or enter to default to (8050): " app_port

if [ -z "$app_port" ]
then
    app_port="8050"
fi


puma_dir=$(which puma)

if [ -z "$puma_dir" ] 
then
    echo "puma path not found"
    echo "Please install ruby-railties"
    echo "sudo apt-get update -y"
    echo "sudo apt-get install -y ruby-railties"
    echo "Then try again"
    exit 0
fi

env=$mode


if systemctl --all --type service | grep -q "${service_name}.service";then
    echo "stopping service"
    sudo systemctl stop ${service_name}.service
    sudo systemctl disable ${service_name}.service
    echo "service stopped"
else
    echo "Setting up service"
fi

curr_dir=$(pwd)

echo "Writing the service"
echo "[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple

User=$USER

WorkingDirectory=$app_dir

Environment=RAILS_ENV=$env

ExecStart=/bin/bash -lc 'rvm use ${ruby} && ${puma_dir} -C ${app_dir}/config/server/${env}.rb'

Restart=always

KillMode=process

[Install]
WantedBy=multi-user.target" > ${service_name}.service

sudo cp ./${service_name}.service /etc/systemd/system

echo "Writing puma configuration"

[ ! -d ${app_dir}/config/server ] && mkdir ${app_dir}/config/server

echo "# Puma can serve each request in a thread from an internal thread pool.
# The threads method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
threads_count = ENV.fetch('RAILS_MAX_THREADS') { $app_core }
threads 2, threads_count

# Specifies the port that Puma will listen on to receive requests; default is 3000.
#
port        ENV.fetch('PORT') { $app_port }

# Specifies the environment that Puma will run in.
#
environment ENV.fetch('RAILS_ENV') { '$env' }

# Specifies the number of workers to boot in clustered mode.
workers ENV.fetch('WEB_CONCURRENCY') { $app_core }

# Use the preload_app! method when specifying a workers number.

preload_app!

# Allow puma to be restarted by rails restart command.
plugin :tmp_restart

rackup '${app_dir}/config.ru'" > ${env}.rb

sudo cp ./${env}.rb ${app_dir}/config/server/


echo "Firing the service up"

sudo systemctl daemon-reload
sudo systemctl enable ${service_name}.service
sudo systemctl start ${service_name}.service

echo "${service_name} Service fired up"
echo "Cleaning up"
rm ./${service_name}.service
rm ./${env}.rb

whenever --set "environment=${env}" --update-crontab

echo "Sync cron job configured"
 
echo "Cleaning up done"

echo "completed"

echo "Service: ${service_name}"
echo "Port: ${app_port}"
echo "Environment: ${env}"
echo "---------------------------"
echo "*****SERVICE COMMANDS******"
echo "Service status"
echo "sudo service ${service_name} status"
echo "Start Service"
echo "sudo service ${service_name} start"
echo "Restart Service"
echo "sudo service ${service_name} restart "
echo "Stop Service"
echo "sudo service ${service_name} stop"
echo "---------------------------"
echo "Thank You!"




