#Views created to find out the error prone days

## statustotal
CREATE VIEW statustotal AS
SELECT time ::date,
       status
FROM log;

## statusfailed
CREATE VIEW statusfailed AS
SELECT time,
       count(*) AS num
FROM statustotal
WHERE status = '404 NOT FOUND'
GROUP BY time;

##statusall
CREATE VIEW statusall
SELECT time,
       count(*) AS num
FROM statustotal
WHERE status = '404 NOT FOUND'
  OR status = '200 OK'
GROUP BY time;

#percentagecount
CREATE VIEW percentagecount AS
SELECT statusall.time,
       statusall.num AS numall,
       statusfailed.num AS numfailed,
       statusfailed.num::double precision/statusall.num::double precision * 100 AS percentagefailed
FROM statusall,
     statusfailed
WHERE statusall.time = statusfailed.time;