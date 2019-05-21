# WCAデータベースを用いた大会別初参加者の集計

下記のようなロジックで集計を実施しました。

1. Resultsから参加者ごとの初参加の大会を取得
2.Competitionsから日本で開催された大会を取得
3.Resultsと2をinner join
4.3と1をpersonIdでinner join
5.その大会が初参加であるかどうかのフラグを立ててcompetitionIdごとに集計

Analyzing data from WCA DB for calculating the ratio of the first competitors in each comps in Japan.

# DATA SOURCE
> This information is based on competition results owned and maintained by the
> World Cube Assocation, published at https://worldcubeassociation.org/results
> as of May 10, 2019.
