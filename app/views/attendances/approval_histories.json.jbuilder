# コントローラで定義した@mealsに対し、繰り返し処理を行い、jsonの配列を作成します。
json.array! @approval_histories do |ah|
  # meal.nameがjsonデータのnameに代入されます
  # json.〇〇の〇〇がデータから値を取り出す時に使う変数名となります
  json.month ah.attendance_day
end