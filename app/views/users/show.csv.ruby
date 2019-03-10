# 勤怠表示画面　CSV出力
require 'csv'

CSV.generate do |csv|
  column_names = %w(日付 出勤 退勤 備考)
  # csvファイルの列に挿入
  csv << column_names
  @date.each do |date|
    column_values = [
      date.attendance_day,
      if not date.beginning_time.nil?
        date.beginning_time.strftime("%H:%M")
      end,
      if not date.leaving_time.nil?
        date.leaving_time.strftime("%H:%M")
      end,
      date.note
    ]
    # csvファイルの行にデータを挿入
    csv << column_values
  end
end