module AttendancesHelper
  # 勤怠A：勤怠編集 翌日対応　attendances#attendance_updateで使用
  def attendances_invalid?
    attendances = true
    attendance_params.each do |id, item|
      if item[:beginning_time].blank? && item[:leaving_time].blank?
        next
      elsif item[:beginning_time].blank? || item[:leaving_time].blank?
        attendances = false
        break
      elsif  item[:next_day] == "1"
        item["beginning_time"].to_s > item["leaving_time"].to_s
        attendances = true
        break
      else
        item["beginning_time"].to_s > item["leaving_time"].to_s
        attendances = false
      end
    end
    attendances
  end
end
