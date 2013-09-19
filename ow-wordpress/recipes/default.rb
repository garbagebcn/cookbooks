#
# Cookbook Name:: ow-wordpress
# Recipe:: default
#
# By Gerard Vivancos
#
# Assumes OpsWorks 

remote_file "#{Chef::Config[:file_cache_path]}/wordpress-latest.tar.gz" do
	source "http://wordpress.org/latest.tar.gz"
	mode "0644"
end

node[:deploy].each do | app_name, deploy |
	execute "untar-wordpress" do
		cwd	deploy[:deploy_to]
		command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/wordpress-latest.tar.gz"
	end

	template "#{deploy[:deploy_to]}/wp-config.php" do
		source "wp-config.php.erb"
		owner "root"
		group "root"
		mode "0644"
		variables(
			:database        => deploy[:database][:database],
		    :user            => deploy[:database][:username],
		    :password        => deploy[:database][:password	],
		    :dbhost          => deploy[:database][:host]
			)
		action :create
	end

end
