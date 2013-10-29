class Event < ActiveRecord::Base

	# 這表示 name 屬性是必填欄位
	validates_presence_of :name

	# 與 location 做一對一關聯式資料
	has_one :location  # 單數

	# 與 attendees 做一對多關連
 	has_many :attendees  # 複數	

	#
	has_many :event_groupships
	has_many :groups, :through => :event_groupships

end
