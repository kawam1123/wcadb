##日本国内で開催された大会のリストを作成する
CREATE TABLE compListJapan
AS
SELECT str_to_date(concat(year,'-',month,'-',day),'%Y-%c-%d') as date,competitionId, personId
	FROM `results`
	INNER JOIN `competitions` ON results.competitionId = competitions.id AND competitions.countryId = "Japan"
	ORDER BY date desc,competitionId desc

#全ての競技者について「初参加の大会」を抽出する。国籍は指定しない。
CREATE TABLE firstComps
AS
SELECT personId, competitionId as firstcompetitionId, date as firstdate
FROM (
	SELECT DISTINCT personId, competitionId,str_to_date(concat(year,'-',month,'-',day),'%Y-%c-%d') as date
	FROM results R
	INNER JOIN competitions C ON R.competitionId = C.id
	ORDER BY year asc,month asc
) as firstlist
	GROUP BY personId

#上記2つのテーブルを内部結合し、初参加の大会であるかを示す列を追加する
CREATE TABLE firstJapaneseComps
AS
SELECT DISTINCT L.competitionId, L.personId, L.date, F.firstdate,
	(CASE WHEN L.date=F.firstdate THEN '初参加'
	WHEN L.date>F.firstdate THEN '二回目以降'
	ELSE  null END) as 初参加有無
FROM compListJapan L
LEFT JOIN firstComps F ON L.personId = F.personId

#大会ごとに総参加者、初参加者、二回目以降の参会者、および初参加者の比率を計算し、出力する
SELECT date,competitionId,count(personId) as 総参加者, 
		count(初参加有無="初参加" OR NULL) as 初参加者,
		count(初参加有無="二回目以降" OR NULL) as 二回目以降, 
		count(初参加有無="初参加" OR NULL)/count(personId) as 比率
	FROM firstCompsJapanComp
	GROUP BY competitionId
	ORDER BY date desc
