select *,
case when registered_identifier ilike "%gru%" then 


1            HMB-IRB
2            GRU-IRB
3            DS-NBIA
4              DS-MC
5          DS-BPEAKD
6           DS-CHDEF
7  DS-BAV-IRB-PUB-RD
8                HMB
9           DS-RARED
10       DS-THAL-IRB
11           HMB-GSO
12             DS-EP
13               GRU
14             DS-RD
15            DS-HFA
16           DS-BDIS
from {{ ref("cmg_main_subject")}} s
left join {{ ref("cmg_main_anvil_dataset")}} ad
using(source_snapshot_id , source_snapshot)
