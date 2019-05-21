##日本国内の大会の参加者リスト

CREATE TABLE compListJapan
AS
SELECT str_to_date(concat(year,'-',month,'-',day),'%Y-%c-%d') as date,competitionId, personId
	FROM `results`
	INNER JOIN `competitions` ON results.competitionId = competitions.id AND competitions.countryId = "Japan"
	ORDER BY date desc,competitionId desc

CREATE TABLE firstComps
AS
SELECT DISTINCT personId, competitionId as firstcompId, min(str_to_date(concat(year,'-',month,'-',day),'%Y-%c-%d')) as firstdate FROM `results`
	INNER JOIN `competitions` ON results.competitionId = competitions.id
	WHERE personCountryID = "japan"
	group by personId
	ORDER BY personId, firstdate


CREATE TABLE firstCompsJapanComp IF NOT EXISTS
AS
SELECT L.competitionId, L.personId, L.date, F.firstdate,
	(CASE WHEN L.date=F.firstdate THEN '初参加'
   WHEN L.date>F.firstdate THEN '二回目以降'
   ELSE  null END) as 初参加有無
	FROM compListJapan L
	INNER JOIN firstComps F
		ON L.personId = F.personId
	GROUP BY L.competitionId

SELECT date,competitionId,count(personId) as 総参加者, 
		count(初参加有無="初参加" OR NULL) as 初参加者,
		count(初参加有無="二回目以降" OR NULL) as 二回目以降, 
		count(初参加有無="初参加" OR NULL)/count(personId) as 比率
	FROM firstCompsJapanComp
	GROUP BY competitionId
	ORDER BY date desc
