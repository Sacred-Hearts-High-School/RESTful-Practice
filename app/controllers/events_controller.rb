class EventsController < ApplicationController

# show,edit,update,destroy 都有重複性程式碼，可以抽出來到find_event。@event=Event.find(params[:id])
before_filter :find_event, :only => [ :show, :edit, :update, :destroy ]
# 需要密碼驗證的頁面
before_filter :authenticate, :only => [ :edit, :update, :destroy ]

def index
	# 安裝 kaminari 之後可以有分頁的套件
    # @events = Event.all
	@events = Event.order("id").page(params[:page]).per(3)

    # 支援XML、JSON、Atom 的輸出
	respond_to do |format|
		format.html # index.html.erb
		format.xml { render :xml => @events.to_xml }
		format.json { render :json => @events.to_json }
		format.atom { @feed_title = "My event list" } #index.atm.builder
	end
end

def new
    @event = Event.new
end

# 處理由 new 表單送過來的資料
def create
    @event = Event.new(event_params)
	# 必須欄位沒有的話，必須回傳 new 的樣板頁面重新修改。
    if @event.save
		flash[:notice] = "event was successfully created"
		redirect_to events_url
	else
		render :action => :new
	end
end

def show
	# page_title 顯示在 layouts/application.html.erb 的 <title> 中
	# @page_title = @event.name  # 本行已經移到下面

	# 加上 XML, JSON 的支援
	respond_to do |format|
		format.html { @page_title = @event.name } #show.html.erb
		format.xml #show.xml.builder
		format.json { render :json => { id: @event.id, name: @event.name }.to_json }
	end

end

def edit
end

# 處理由 edit 表單送過來的資料
def update
	# 必須欄位驗證失敗
	if @event.update_attributes(event_params)
		flash[:notice] = "event was successfully updated"
		redirect_to event_url(@event)
	else
		render :action => :edit
	end
end

def destroy
	@event.destroy
	flash[:alert] = "event was successfully deleted"
	redirect_to :action => :index
end


protected  

def find_event
	# 這一行 show, edit, update, destroy 都有，所以可以拿出來。
	@event = Event.find(params[:id])
end

def authenticate
	authenticate_or_request_with_http_basic do |username, password|
		username == "foo" && password == "bar"
	end
end

private

# rails 4.0 之後才有的安全設定，要宣告允許使用的變數
def event_params
	params.require(:event).permit(:name,:description)
end 



end
