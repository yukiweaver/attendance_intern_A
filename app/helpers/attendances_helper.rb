module AttendancesHelper
  # 勤怠A：勤怠編集　attendances#attendance_updateで使用
  def attendances_invalid?
    attendances = true
    attendance_params.each do |id, item|
      if item[:beginning_time].blank? && item[:leaving_time].blank?
        next
      elsif item[:beginning_time].blank? || item[:leaving_time].blank?
        attendances = false
        break
      elsif item["beginning_time"].to_s > item["leaving_time"].to_s
        attendances = false
        break
      end
    end
    attendances
  end
end
