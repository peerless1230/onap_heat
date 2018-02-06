# onap_heat
### 下载ONAP HEAT模板
下载HEAT模板及其环境变量文件
```
https://github.com/peerless1230/onap_heat/onap.installation/onap_openstack.env
https://github.com/peerless1230/onap_heat/onap.installation/onap_openstack.yaml
```
删去了一些官方注释，对于某些变量的疑惑，可参考原文件及ONAP Amsterdam full-setup文档：
```
# HEAT Tempalte sample
https://github.com/peerless1230/onap_heat/onap.installation/onap_openstack.env.sample
https://github.com/peerless1230/onap_heat/onap.installation/onap_openstack.yaml.sample

# ONAP Amsterdam full-setup
http://onap.readthedocs.io/en/latest/guides/onap-developer/settingup/fullonap.html
```

### 修改相关环境配置
根据部署环境相关配置，修改好HEAT文件后，通过heat来创建stack
```
heat stack create -f onap_openstack.yaml -e onap_openstack.env onap
或
openstack stack create -t onap_openstack.yaml -e onap_openstack.env onap
```
### 查看服务状态
接下来，就是检查 ``实例`` 中，各个服务所在的虚拟机console中cloud-init日志输出，根据日志，进行相关debug。

### 更多细节
[http://notafraid.me/2017/12/18/onap-on-heat%E9%83%A8%E7%BD%B2/](http://notafraid.me/2017/12/18/onap-on-heat%E9%83%A8%E7%BD%B2/)
