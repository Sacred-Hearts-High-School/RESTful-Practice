class Attendee < ActiveRecord::Base

	# 與 event 成為一對多關連
	belongs_to :event # 單數

end
