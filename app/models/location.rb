class Location < ActiveRecord::Base

	# 與 event 做關聯式資料
	belongs_to :event  # 單數

end
