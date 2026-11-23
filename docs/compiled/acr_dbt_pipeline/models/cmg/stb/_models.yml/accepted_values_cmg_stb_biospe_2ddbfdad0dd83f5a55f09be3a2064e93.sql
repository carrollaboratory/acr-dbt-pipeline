
    
    

with all_values as (

    select
        method as value_field,
        count(*) as n_records

    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_biospecimencollection"
    group by method

)

select *
from all_values
where value_field not in (
    'snomedct:1048003','snomedct:113031002','snomedct:115985003','snomedct:1202027002','snomedct:1230332003','snomedct:1255865009','snomedct:1285339005','snomedct:1359755003','snomedct:13677008','snomedct:16631761000119104','snomedct:174653005','snomedct:19867003','snomedct:21217000','snomedct:225098009','snomedct:225105004','snomedct:225109005','snomedct:225110000','snomedct:225111001','snomedct:225112008','snomedct:225113003','snomedct:225271002','snomedct:225709000','snomedct:225711009','snomedct:225997002','snomedct:23248003','snomedct:235488002','snomedct:235569007','snomedct:236363003','snomedct:236364009','snomedct:243772004','snomedct:243776001','snomedct:243777005','snomedct:243778000','snomedct:243779008','snomedct:243780006','snomedct:243781005','snomedct:24469009','snomedct:2475000','snomedct:276907003','snomedct:278450005','snomedct:285570007','snomedct:285586000','snomedct:285589007','snomedct:301805004','snomedct:301874004','snomedct:304991003','snomedct:310216004','snomedct:310217008','snomedct:312645003','snomedct:312855001','snomedct:312873003','snomedct:312874009','snomedct:312875005','snomedct:312876006','snomedct:312877002','snomedct:312878007','snomedct:312879004','snomedct:312880001','snomedct:312881002','snomedct:312882009','snomedct:313273004','snomedct:313274005','snomedct:31507001','snomedct:32564009','snomedct:34532003','snomedct:37020001','snomedct:37705003','snomedct:386087005','snomedct:386088000','snomedct:386089008','snomedct:386099003','snomedct:390784004','snomedct:390785003','snomedct:400993006','snomedct:400994000','snomedct:401002001','snomedct:40597003','snomedct:406173008','snomedct:418622002','snomedct:42311007','snomedct:427133003','snomedct:439599008','snomedct:441136006','snomedct:441266008','snomedct:441378005','snomedct:444171005','snomedct:446232000','snomedct:446775007','snomedct:44733008','snomedct:450874000','snomedct:45240002','snomedct:472859009','snomedct:472860004','snomedct:472917009','snomedct:473363001','snomedct:50576009','snomedct:50753008','snomedct:57617002','snomedct:58088002','snomedct:64860001','snomedct:66904006','snomedct:698007008','snomedct:698086002','snomedct:698087006','snomedct:699873000','snomedct:70347009','snomedct:705084002','snomedct:705156009','snomedct:705172001','snomedct:707982002','snomedct:707983007','snomedct:708015008','snomedct:709500005','snomedct:71197008','snomedct:713143008','snomedct:720450003','snomedct:722501003','snomedct:732218007','snomedct:732221009','snomedct:732223007','snomedct:732224001','snomedct:732228003','snomedct:732292007','snomedct:733478009','snomedct:733481004','snomedct:73416001','snomedct:738796001','snomedct:764928002','snomedct:764929005','snomedct:768966009','snomedct:769401004','snomedct:77262006','snomedct:82078001','snomedct:83917009','snomedct:840566006','snomedct:86326008'
)


