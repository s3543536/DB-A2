connect 'jdbc:derby:BUSINESS_NAMES_DB_SECONDARY';


SHOW tables in APP;


select n.ID, REGISTER_NAME, BN_NAME, bo.BN_STATUS, BN_REG_DT, BN_CANCEL_DT, BN_RENEW_DT, BN_STATE_NUM, STATE, BN_ABN
from BN_NAMES n, BN_REGISTRATIONS r, BN_STATUS s, BN_STATES bs, BN_STATUS_OPTIONS bo
where n.id = r.id
and n.id = s.id
and r.BN_STATE_OF_REG = bs.BN_STATE_OF_REG
and s.BN_STATUS_ID = bo.BN_STATUS_ID
and BN_NAME BETWEEN 'C' and 'G';
