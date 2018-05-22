connect 'jdbc:derby:BUSINESS_NAMES_DB';


SHOW tables in APP;


select ID, REGISTER_NAME, BN_NAME
from BN_NAMES
where BN_NAME BETWEEN 'P' and 'R'
