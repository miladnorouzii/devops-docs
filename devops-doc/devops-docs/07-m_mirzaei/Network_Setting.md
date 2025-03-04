# Configure Network Setting ON Rocky 9.4
``` bash
cd /etc/NetworkManager/system-connections/
ls
enp0s3.nmconnection enp0s8.nmconnection
vi enp0s3.nmconnection
[connection]
id=enp0s3
uuid=96ced865-9252-325b-a81d-77844b113c32
type=ethernet
autoconnect-priority=-999
interface-name=enp0s3
timestamp=1728816861

[ethernet]

[ipv4]
address1=10.0.2.15
method=manual

[ipv6]
addr-gen-mode=eui64
method=disabled

[proxy]

```

## end 